import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/auth/model/registration_form.dart';

abstract interface class AuthRepo {
  Future<bool> isLoggedIn();
  AsyncValueOf<LoggedInUser> logIn(String username,String pswd);
  AsyncValueOf<LoggedInUser> getPersistedUser();
  AsyncValueOf<bool> signOut();

  AsyncValueOf<bool> register(RegistrationForm form);

  AsyncValueOf<bool> shareOTP(String email);
  AsyncValueOf<bool> validateOTP(String otp, String token);
  AsyncValueOf<bool> confirmPassword(String pswd);
}
