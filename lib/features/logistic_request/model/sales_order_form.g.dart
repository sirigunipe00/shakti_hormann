// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesOrderFormImpl _$$SalesOrderFormImplFromJson(Map<String, dynamic> json) =>
    _$SalesOrderFormImpl(
      name: json['name'] as String?,
      plantName: json['company'] as String?,
      addressDisplay: json['address_display'] as String?,
    );

Map<String, dynamic> _$$SalesOrderFormImplToJson(
  _$SalesOrderFormImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'company': instance.plantName,
  'address_display': instance.addressDisplay,
};
