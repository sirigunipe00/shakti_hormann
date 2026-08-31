// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PalletModelImpl _$$PalletModelImplFromJson(Map<String, dynamic> json) =>
    _$PalletModelImpl(
      status: json['status'] as String?,
      name: json['name'] as String?,
      owner: json['owner'] as String?,
      creationDate: json['creation'] as String? ?? '',
      docStatus: (json['docstatus'] as num?)?.toInt(),
      modifiedDate: json['modified'] as String?,
      modifiedBy: json['modified_by'] as String?,
      idx: (json['idx'] as num?)?.toInt(),
      salesOrder: json['sales_order'] as String?,
      customerName: json['customer_name'] as String?,
      orderDate: json['order_date'] as String?,
      noofPallets: (json['no_of_pallets'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PalletModelImplToJson(_$PalletModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'name': instance.name,
      'owner': instance.owner,
      'creation': instance.creationDate,
      'docstatus': instance.docStatus,
      'modified': instance.modifiedDate,
      'modified_by': instance.modifiedBy,
      'idx': instance.idx,
      'sales_order': instance.salesOrder,
      'customer_name': instance.customerName,
      'order_date': instance.orderDate,
      'no_of_pallets': instance.noofPallets,
    };
