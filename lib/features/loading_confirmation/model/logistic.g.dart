// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logistic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LogisticModelImpl _$$LogisticModelImplFromJson(Map<String, dynamic> json) =>
    _$LogisticModelImpl(
      name: json['sales_order'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$$LogisticModelImplToJson(_$LogisticModelImpl instance) =>
    <String, dynamic>{
      'sales_order': instance.name,
      'state': instance.state,
      'city': instance.city,
    };
