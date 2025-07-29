import 'package:equatable/equatable.dart';
import 'package:shakti_hormann/app/model/otp_request_type.dart';
import 'package:shakti_hormann/core/core.dart';


class OTPInput extends Equatable {
  const OTPInput({
    required this.type,
    required this.otp,
    required this.number,
    this.usr,
    this.token,
  });

  final OTPRequestType type;
  final String otp;
  final String number;
  final String? usr;
  final String? token;

  @override
  List<Object?> get props => [type, usr, otp, token];

  Map<String, dynamic> toJson() {
    return {
      'otp_type': type.code,
      'mobile_': usr,
      'otp': otp,
      if (token.containsValidValue) ...{'token': token},
    };
  }
}
