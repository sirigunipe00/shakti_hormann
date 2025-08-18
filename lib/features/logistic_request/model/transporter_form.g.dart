// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transporter_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransportersFormImpl _$$TransportersFormImplFromJson(
  Map<String, dynamic> json,
) => _$TransportersFormImpl(
  status: json['status'] as String?,
  name: json['name'] as String?,
  suppliername: json['supplier_name'] as String?,
  supplierType: json['supplier_type'] as String?,
  isTransporter: (json['is_transporter'] as num?)?.toInt(),
);

Map<String, dynamic> _$$TransportersFormImplToJson(
  _$TransportersFormImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'name': instance.name,
  'supplier_name': instance.suppliername,
  'supplier_type': instance.supplierType,
  'is_transporter': instance.isTransporter,
};
