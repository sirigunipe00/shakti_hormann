import 'package:shakti_hormann/core/core.dart';

import 'package:shakti_hormann/app/model/otp_inp.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';

abstract interface class AppRepo {
  AsyncValueOf<bool> sendOTP(OTPInput inp);
    // AsyncValueOf<bool> isAppUpdateAvailable();
}