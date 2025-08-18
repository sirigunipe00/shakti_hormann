import 'package:freezed_annotation/freezed_annotation.dart';

part 'logged_in_user.freezed.dart';
part 'logged_in_user.g.dart';

@freezed
class LoggedInUser with _$LoggedInUser {
  const LoggedInUser._();
  const factory LoggedInUser({
    required  String name,
    required String username,
    @JsonKey(name: 'first_name', defaultValue: '') String? firstName,
    @JsonKey(name: 'last_name', defaultValue: '') String? lastName,
    @JsonKey(name: 'api_key', defaultValue: '') required String apiKey,
    @JsonKey(name: 'api_secret', defaultValue: '') required String apiSecret,
    @JsonKey(name: 'email', defaultValue: '') String? email,
    @JsonKey(defaultValue: '') String? password,
    @JsonKey(name: 'role_profile_name', defaultValue: '')
    String? roleProfileName,
    @JsonKey(name: 'user_type') String? userType,
    @JsonKey(name: 'gender') String? gender,
    @JsonKey(name: 'birth_date') String? bithDate,
    @JsonKey(name: 'depo_name') String? depoName,
    @JsonKey(name: 'full_name') required String? fullName,
    String? phone,
    String? location,
    String? bio,
    @JsonKey(name: 'mobile_no') String? mobileNo,
    @JsonKey(name: 'otp_verified') bool? isOtpVerfied,
  }) = _LoggedInUser;

  factory LoggedInUser.fromJson(Map<String, dynamic> json) =>
      _$LoggedInUserFromJson(json);
}


