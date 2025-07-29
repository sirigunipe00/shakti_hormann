import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/data/auth_repo.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/auth/model/registration_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl extends BaseApiRepository implements AuthRepo {
  const AuthRepoImpl(super.client, this.storage);

  final KeyValueStorage storage;

  @override
  Future<bool> isLoggedIn() async {
    try {
      final user = await storage.getSecureString(LocalKeys.user);
      return (user.containsValidValue && json.decode(user!) is Map);
    } on Exception catch (e, st) {
      $logger.error('[repo] could not check for persisted user', e, st);
      return false;
    }
  }

  @override
  AsyncValueOf<bool> register(RegistrationForm form) async {
    final requestConfig = RequestConfig(
      url: Urls.createUser,
      parser: (p0) => p0,
      body: jsonEncode(form.toJson()),
    );
    $logger.devLog(requestConfig);
    final res = await post(requestConfig, includeAuthHeader: false);
    return res.process((r) => right(true));
  }



  @override
  AsyncValueOf<LoggedInUser> logIn(String username, String pswd) async {
    return await executeSafely(() async {

      final prefs = await SharedPreferences.getInstance();
      final requestConfig = RequestConfig(
        url: Urls.getUsers,
        parser: (res) {
          final data = res['message']['data'] as List<dynamic>;
          return LoggedInUser.fromJson(data.first);
        },
        body: jsonEncode({'usr': username, 'pwd': pswd}),
      );
      $logger.devLog(requestConfig);

      final response = await post(requestConfig, includeAuthHeader: false);

      return response.processAsync((r) async {
        if (r.data.isNull) {
          return Errors.invalidUser.asFailure();
        }
        final userWithPswd = r.data!.copyWith(password: pswd);
        await _persistUser(userWithPswd);
        await prefs.setString('userToken', userWithPswd.apiKey ?? '');
        await storage.setString(LocalKeys.apiKey, userWithPswd.apiKey ?? '');
        await storage.setString(LocalKeys.apiSecret, userWithPswd.apiSecret ?? '');
        return right(userWithPswd);
      });
    });
  }

  Future<Either<Failure, bool>> _persistUser(LoggedInUser user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await storage.setSecureString(LocalKeys.user, userJson);

      return right(true);
    } on Exception catch (e, st) {
      $logger.error('[repo] could not persisted user', e, st);
      return left(const Failure(error: 'Something went wrong'));
    }
  }

  @override
  AsyncValueOf<LoggedInUser> getPersistedUser() async {
    try {
      final userSource = await storage.getSecureString(LocalKeys.user);
      if (userSource.doesNotHaveValue) {
        return left(const Failure(error: 'No user details found'));
      }
      final userData = jsonDecode(userSource!) as Map<String, dynamic>;
      final user = LoggedInUser.fromJson(userData);
      return right(user);
    } on Exception catch (e, st) {
      $logger.error('[repo] could not get persisted user', e, st);
      return left(const Failure(error: 'Something went wrong'));
    }
  }

  @override
  AsyncValueOf<bool> signOut() async {
    try {
      await storage.clearAllValues();
      await storage.clearAllSecureValues();
      return right(true);
    } on Exception catch (e, st) {
      $logger.error('[repo] could not sign out user', e, st);
      return left(const Failure(error: 'Could not sign out'));
    }
  }

  @override
  AsyncValueOf<bool> shareOTP(String email) async {
    return await executeSafely(() async {
      final requestConfig = RequestConfig(
        url: Urls.forgotPswd,
        parser: (res) {
          final data = res['message']['data'] as List<dynamic>;
          return LoggedInUser.fromJson(data.first);
        },
        body: jsonEncode({'email': email}),
      );
      final response = await post(requestConfig);
      return response.process((r) => right(true));
    });
  }

  @override
  AsyncValueOf<bool> validateOTP(String otp, String token) async {
    return await executeSafely(() async {
      if (otp != '1111') {
        return 'Invalid OTP'.asFailure();
      }
      return right(true);
    });
  }

  @override
  AsyncValueOf<bool> confirmPassword(String pswd) async {
    return right(true);
  }
}
