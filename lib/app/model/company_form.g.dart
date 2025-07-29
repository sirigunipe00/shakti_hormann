// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyFormImpl _$$CompanyFormImplFromJson(Map<String, dynamic> json) =>
    _$CompanyFormImpl(
      name: json['name'] as String?,
      companyName: json['company_name'] as String?,
      companyType: json['custom_company_type'] as String?,
    );

Map<String, dynamic> _$$CompanyFormImplToJson(_$CompanyFormImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'company_name': instance.companyName,
      'custom_company_type': instance.companyType,
    };
