// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationFormImpl _$$RegistrationFormImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationFormImpl(
      fullName: json['full_name'] as String?,
      mobileNumber: json['mobile'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      cnfPswd: json['cnfPswd'] as String?,
    );

Map<String, dynamic> _$$RegistrationFormImplToJson(
        _$RegistrationFormImpl instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'mobile': instance.mobileNumber,
      'email': instance.email,
      'password': instance.password,
      'cnfPswd': instance.cnfPswd,
    };
