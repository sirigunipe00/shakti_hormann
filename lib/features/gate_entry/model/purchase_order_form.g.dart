// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseOrderFormImpl _$$PurchaseOrderFormImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseOrderFormImpl(
  name: json['name'] as String?,
  plantName: json['company'] as String?,
  supplier: json['supplier'] as String?,
  supplierName: json['supplier_name'] as String?,
  orderDate: json['order_date'] as String? ?? '',
  remarks: json['custom_remarks'] as String?,
);

Map<String, dynamic> _$$PurchaseOrderFormImplToJson(
  _$PurchaseOrderFormImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'company': instance.plantName,
  'supplier': instance.supplier,
  'supplier_name': instance.supplierName,
  'order_date': instance.orderDate,
  'custom_remarks': instance.remarks,
};
