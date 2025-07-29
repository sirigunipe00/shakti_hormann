import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/presentation/bloc/forgot_pswd/forgot_pswd_cubit.dart';
import 'package:shakti_hormann/login_scrn.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/text_styles.dart';
import 'package:shakti_hormann/widgets/app_spacer.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/go_back_icon_btn.dart';
import 'package:shakti_hormann/widgets/inputs/app_text_field.dart';
import 'package:shakti_hormann/widgets/inputs/otp_field_style.dart';
import 'package:shakti_hormann/widgets/inputs/otp_text_field.dart';

class ForgotPswdScrn extends StatefulWidget {
  const ForgotPswdScrn({super.key});

  @override
  State<ForgotPswdScrn> createState() => _ForgotPswdScrnState();
}

class _ForgotPswdScrnState extends State<ForgotPswdScrn> {
  late final TextEditingController emailController;
  late final TextEditingController pswdController;
  late final TextEditingController cnfPswdController;
  final OtpFieldController otpController = OtpFieldController();
  String? enteredOtp;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    pswdController = TextEditingController();
    cnfPswdController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: context.sizeOfWidth,
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<ForgotPswdCubit, ForgotPswdState>(
              listener: (_, state) async {
                final formState = state.controller;
                if (state.failure.isNotNull) {
                  AppDialog.showErrorDialog(
                    context,
                    content: state.failure!.error.valueOrEmpty,
                    onTapDismiss: context.exit,
                  );
                  context.cubit<ForgotPswdCubit>().handled();
                  return;
                }
                if (state.isSuccess) {
                  final strMessage = switch (formState) {
                    FormStateController.initial =>
                      'The OTP has been shared to registered email',
                    FormStateController.verification =>
                      'OTP verfied Successfully',
                    FormStateController.update =>
                      'Password Updated successfully. Thank you.',
                  };

                  await AppDialog.showSuccessDialog(
                    context,
                    content: strMessage,
                    onTapDismiss: context.exit,
                  );
                  if (!context.mounted) return;
                  context.cubit<ForgotPswdCubit>()
                    ..handled()
                    ..updateState();

                  if (formState == FormStateController.update) {
                    // AppRoute.login.go(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScrnWidget(),
                      ),
                    );
                  }
                }
              },
              builder: (_, state) {
                final controller = state.controller;

                final btnLabeltext = switch (controller) {
                  FormStateController.initial => 'Proceed',
                  FormStateController.verification => 'Verify',
                  FormStateController.update => 'Confirm Password',
                };

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GoBackIconBtn(),
                    if (controller == FormStateController.initial) ...[
                      _InitialFormWidget(controller: emailController),
                    ] else if (controller ==
                        FormStateController.verification) ...[
                      _OTPVerificationWidget(
                        controller: otpController,
                        onResend: () {
                          context.cubit<ForgotPswdCubit>().sendOTP(
                            emailController.text,
                          );
                        },
                        onChanged: (p0) {
                          setState(() {
                            enteredOtp = p0;
                          });
                        },
                      ),
                    ] else ...[
                      _UpdatePasswordWidget(
                        pswdController: pswdController,
                        cnfPswdController: cnfPswdController,
                      ),
                    ],
                    SizedBox(height: context.sizeOfHeight * .05),
                    AppButton(
                      bgColor: AppColors.darkBlue,
                      isLoading: state.isLoading,
                      label: btnLabeltext,
                      onPressed: () {
                        if (controller == FormStateController.initial) {
                          context.cubit<ForgotPswdCubit>().sendOTP(
                            emailController.text,
                          );
                        } else if (controller ==
                            FormStateController.verification) {
                          context.cubit<ForgotPswdCubit>().verifyOTP(
                            enteredOtp,
                          );
                        } else if (controller == FormStateController.update) {
                          context.cubit<ForgotPswdCubit>().confirmPaswd(
                            pswdController.text,
                            cnfPswdController.text,
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _InitialFormWidget extends StatelessWidget {
  const _InitialFormWidget({required this.controller});

  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Change Password',
          style: TextStyles.titleBold(context).copyWith(color: AppColors.black),
        ),
        AppSpacer.p24(),
        Text(
          "Seems You've forgot your password",
          style: TextStyles.labelLarge(context),
        ),
        SizedBox(height: context.sizeOfHeight * .15),
        AppTextField(
          title: 'Registered Email',
          controller: controller,
          isRequired: true,
          inputType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}

class _OTPVerificationWidget extends StatelessWidget {
  const _OTPVerificationWidget({
    required this.controller,
    required this.onResend,
    required this.onChanged,
  });

  final OtpFieldController controller;
  final VoidCallback onResend;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Verify Code',
          style: TextStyles.titleBold(context).copyWith(color: AppColors.black),
        ),
        AppSpacer.p24(),
        Text('Enter Code', style: TextStyles.labelLarge(context)),
        SizedBox(height: context.sizeOfHeight * .05),
        OTPTextField(
          controller: controller,
          contentPadding: const EdgeInsets.all(18),
          length: 4,
          width: context.sizeOfWidth,
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldWidth: 60,
          otpFieldStyle: const OtpFieldStyle(
            enabledBorderColor: AppColors.grey,
            focusBorderColor: AppColors.darkBlue,
          ),
          fieldStyle: FieldStyle.box,
          outlineBorderRadius: 12,
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
          onChanged: onChanged,
          onCompleted: (pin) {},
        ),
        SizedBox(height: context.sizeOfHeight * .05),
        Text(
          "Didn't receive OTP?",
          style: TextStyles.titleBold(context).copyWith(color: AppColors.black),
        ),
        GestureDetector(
          onTap: onResend,
          child: Text(
            'Resend Code',
            style: TextStyles.labelLarge(
              context,
            )?.copyWith(color: AppColors.darkBlue),
          ),
        ),
      ],
    );
  }
}

class _UpdatePasswordWidget extends StatelessWidget {
  const _UpdatePasswordWidget({
    required this.pswdController,
    required this.cnfPswdController,
  });

  final TextEditingController pswdController;
  final TextEditingController cnfPswdController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Change Password',
          style: TextStyles.titleBold(context).copyWith(color: AppColors.black),
        ),
        AppSpacer.p24(),
        Text(
          'Please change your password',
          style: TextStyles.labelLarge(context),
        ),
        SizedBox(height: context.sizeOfHeight * .15),
        AppTextField(
          title: 'Password',
          controller: pswdController,
          isRequired: true,
          obscureText: true,
        ),
        AppSpacer.p12(),
        AppTextField(
          title: 'Confirm Password',
          controller: cnfPswdController,
          isRequired: true,
          obscureText: true,
        ),
      ],
    );
  }
}
