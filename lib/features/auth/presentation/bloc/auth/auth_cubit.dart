import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';

import 'package:shakti_hormann/core/cubit/base/base_cubit.dart';
import 'package:shakti_hormann/core/local_storage/key_vale_storage.dart';
import 'package:shakti_hormann/core/local_storage/local_keys.dart';
import 'package:shakti_hormann/features/auth/data/auth_repo.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';

part 'auth_cubit.freezed.dart';

@injectable
class AuthCubit extends AppBaseCubit<AuthState> {
  AuthCubit(this.repo, this.storage) : super(const AuthState.loading());

  final AuthRepo repo;
  final KeyValueStorage storage;

  void authCheckRequested({bool? isOtpverified}) async {
    emitSafeState(const _Loading());
    try {

      final isloggedIn = await repo.isLoggedIn();
 
      if (isloggedIn) {
        final userdata = await repo.getPersistedUser();
        userdata.fold(
          (l) => l,
          (user) async {
            LoggedInUser updatedUser = user;

            if (isOtpverified == true) {
              updatedUser = user.copyWith(isOtpVerfied: true);

              final userJson = json.encode(updatedUser.toJson());

              await storage.setSecureString(LocalKeys.user, userJson);
            }

            if (updatedUser.isOtpVerfied != true) {
              emitSafeState(const _UnAuthenticated());
              return;
            }

            await register<LoggedInUser>(updatedUser);
            emitSafeState(const _Authenticated());
          },
        );
      }
      if (!isloggedIn) {
        emitSafeState(const _UnAuthenticated());
        return;
      }
    } on Exception catch (e, st) {
      $logger.error('[AuthCheck Exception]', e, st);
      emitSafeState(const _UnAuthenticated());
    }
  }

  void signOut() async {
    try {
      emitSafeState(const _Loading());
      await repo.signOut();
      await Future.wait([
        unregister<LoggedInUser>(),
        unregister<String>(instanceName: 'fbo_id'),
      ]);
      emitSafeState(const _UnAuthenticated());
    } on Exception catch (e, st) {
      $logger.error('[Auth Cubit] cant able to logout', e, st);
      emitSafeState(const _UnAuthenticated());
    }
  }
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.unAuthenticated() = _UnAuthenticated;
}
