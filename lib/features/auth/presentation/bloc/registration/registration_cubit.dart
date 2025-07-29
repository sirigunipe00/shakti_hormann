import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';


import 'package:shakti_hormann/features/auth/data/auth_repo.dart';
import 'package:shakti_hormann/features/auth/model/registration_form.dart';

part 'registration_cubit.freezed.dart';

@injectable
class RegistrationCubit extends AppBaseCubit<RegistrationState> {
  RegistrationCubit(this.repo) : super(RegistrationState.initial());

  final AuthRepo repo;

  void onFieldChange({
    String? fullName,
    String? email,
    String? mobileNumber,
    String? password,
    String? cnfPassword,
  }) {
    final form = state.form;
    final updatedForm = form.copyWith(fullName: fullName ?? form.fullName,
      email: email ?? form.email,
      mobileNumber: mobileNumber ?? form.mobileNumber,
      password: password ?? form.password,
      cnfPswd: cnfPassword ?? form.cnfPswd,
    );
    emitSafeState(state.copyWith(form: updatedForm));
  }

  void signUp() async {
    emitSafeState(state.copyWith(isLoading: true));
    final res = await repo.register(state.form);
    return res.fold(
      (l) => emitSafeState(state.copyWith(isLoading: false, failure: l)), 
      (r) => emitSafeState(state.copyWith(isLoading: false, isSuccess: true)),
    );
  }

  Option<String> validate() {
    final form = state.form;
    if(form.fullName.doesNotHaveValue) {
      return optionOf('Enter Full Name');
    } else if(form.email.doesNotHaveValue) {
      return optionOf('Enter Email');
    } else if (!isEmailValid(form.email!)) {
      return optionOf('Please Enter Valid Email Address');
    } else if(form.mobileNumber.doesNotHaveValue) {
      return optionOf('Enter Mobile Number');
    } else if(form.password.doesNotHaveValue) {
      return optionOf('Enter Password');
    } else  if(!_isValidPswd(state.form.password!)) {
      return optionOf('Entered password should contain at least one capital letter and a number.');
    } else if(form.cnfPswd.doesNotHaveValue) {
      return optionOf('Enter Re-enter Password');
    } else if (form.password != form.cnfPswd) {
      return optionOf('Password & Confirm Password are not matching. Please check.');
    } 
    return const None();
  }

  void emitError(String msg) {
    final failure = Failure(error: msg);
    emitSafeState(state.copyWith(failure: failure));
  }

  void errorHandled() {
    emitSafeState(state.copyWith(failure: null));
  }

  bool _isValidPswd(String pswd) {
    final hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(pswd);
    final hasNumber = RegExp(r'[0-9]').hasMatch(pswd);
    return hasCapitalLetter && hasNumber;
  }

  bool isEmailValid(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}


@freezed
class RegistrationState with _$RegistrationState {
  const RegistrationState._();
  const factory RegistrationState({
    required bool isLoading,
    required bool isSuccess,
    required RegistrationForm form,
    Failure? failure,
  }) = _RegistrationState;

  factory RegistrationState.initial() => const RegistrationState(
    form: RegistrationForm(),
    isLoading: false,
    isSuccess: false,
  );
}
