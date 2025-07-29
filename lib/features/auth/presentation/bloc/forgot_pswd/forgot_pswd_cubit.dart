import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';

import 'package:shakti_hormann/features/auth/data/auth_repo.dart';

part 'forgot_pswd_cubit.freezed.dart';

enum FormStateController { initial, verification, update }

@injectable
class ForgotPswdCubit extends AppBaseCubit<ForgotPswdState> {
  ForgotPswdCubit(this.repo) : super(ForgotPswdState.initial());

  final AuthRepo repo;

  void updateState() {
    final nextState = switch (state.controller) {
      FormStateController.initial => FormStateController.verification,
      FormStateController.verification => FormStateController.update,
      FormStateController.update => FormStateController.update,
    };
    emitSafeState(state.copyWith(controller: nextState));
  }

  void sendOTP(String email) async {
    final isNotValidEmail = StringUtils.validateEmail(email);
    if (!isNotValidEmail) {
      return _emitError('Entered email is not valid Kindly check');
    }

    emitSafeState(state.copyWith(isLoading: true));
    final res = await repo.shareOTP(email);
    res.fold(
      (l) => emitSafeState(state.copyWith(isLoading: false, failure: l)),
      (r) => emitSafeState(state.copyWith(isLoading: false, isSuccess: r)),
    );
  }

  void verifyOTP(String? otp) async {
    if (otp.doesNotHaveValue) {
      return _emitError('Enter OTP');
    }
    if (otp!.length != 4) {
      return _emitError('Enter Valid 4 digit OTP');
    }
    emitSafeState(state.copyWith(isLoading: true));
    final res = await repo.validateOTP(otp, '');
    res.fold(
      (l) => emitSafeState(state.copyWith(isLoading: false, failure: l)),
      (r) => emitSafeState(state.copyWith(isLoading: false, isSuccess: true)),
    );
  }

  void confirmPaswd(String pswd, String cnfPswd) async {
    if (pswd.doesNotHaveValue) {
      return _emitError('Enter Valid Password');
    }

    if (cnfPswd.doesNotHaveValue) {
      return _emitError('Enter Valid Confirm Password');
    }
    final isSame = StringUtils.equalsIgnoreCase(pswd, cnfPswd);
    if (isSame) {
      emitSafeState(state.copyWith(isLoading: true));
      final res = await repo.confirmPassword(cnfPswd);
      res.fold(
        (l) => emitSafeState(state.copyWith(isLoading: false, failure: l)),
        (r) => emitSafeState(state.copyWith(isLoading: false, isSuccess: r)),
      );
    } else {
      return _emitError('Enter Password & Confirm Password are not matching.');
    }
  }

  void handled() {
    emitSafeState(
      state.copyWith(isLoading: false, failure: null, isSuccess: false),
    );
  }

  void _emitError(String error) {
    final failure = Failure(error: error);
    emitSafeState(state.copyWith(failure: failure));
  }
}

@freezed
class ForgotPswdState with _$ForgotPswdState {
  const ForgotPswdState._();
  const factory ForgotPswdState({
    required FormStateController controller,
    required bool isLoading,
    required bool isSuccess,
    Failure? failure,
  }) = _ForgotPswdState;

  factory ForgotPswdState.initial() => const ForgotPswdState(
    controller: FormStateController.initial,
    isLoading: false,
    isSuccess: false,
  );
}
