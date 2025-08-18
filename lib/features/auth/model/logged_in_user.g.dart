// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_in_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoggedInUserImpl _$$LoggedInUserImplFromJson(Map<String, dynamic> json) =>
    _$LoggedInUserImpl(
      name: json['name'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      apiKey: json['api_key'] as String? ?? '',
      apiSecret: json['api_secret'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      roleProfileName: json['role_profile_name'] as String? ?? '',
      userType: json['user_type'] as String?,
      gender: json['gender'] as String?,
      bithDate: json['birth_date'] as String?,
      depoName: json['depo_name'] as String?,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      mobileNo: json['mobile_no'] as String?,
      isOtpVerfied: json['otp_verified'] as bool?,
    );

Map<String, dynamic> _$$LoggedInUserImplToJson(_$LoggedInUserImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'api_key': instance.apiKey,
      'api_secret': instance.apiSecret,
      'email': instance.email,
      'password': instance.password,
      'role_profile_name': instance.roleProfileName,
      'user_type': instance.userType,
      'gender': instance.gender,
      'birth_date': instance.bithDate,
      'depo_name': instance.depoName,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'location': instance.location,
      'bio': instance.bio,
      'mobile_no': instance.mobileNo,
      'otp_verified': instance.isOtpVerfied,
    };
