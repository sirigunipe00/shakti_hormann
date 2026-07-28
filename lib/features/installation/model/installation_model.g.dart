// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstallationModelImpl _$$InstallationModelImplFromJson(
  Map<String, dynamic> json,
) => _$InstallationModelImpl(
  status: json['status'] as String?,
  name: json['name'] as String?,
  owner: json['owner'] as String?,
  creation: json['creation'] as String?,
  modified: json['modified'] as String?,
  modifiedBy: json['modified_by'] as String?,
  docStatus: (json['docstatus'] as num?)?.toInt(),
  idx: (json['idx'] as num?)?.toInt(),
  salesOrderNo: json['sales_order_no'] as String?,
  customerName: json['customer_name'] as String?,
  packingDate: json['packing_date'] as String?,
  shift: json['shift'] as String?,
  packedBy: json['packed_by'] as String?,
  remarks: json['remarks'] as String?,
  noOfBoxes: (json['no_of_boxes'] as num?)?.toInt(),
  isStickerPrinted: (json['is_sticker_printed'] as num?)?.toInt(),
  amendedFrom: json['amended_from'] as String?,
);

Map<String, dynamic> _$$InstallationModelImplToJson(
  _$InstallationModelImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'name': instance.name,
  'owner': instance.owner,
  'creation': instance.creation,
  'modified': instance.modified,
  'modified_by': instance.modifiedBy,
  'docstatus': instance.docStatus,
  'idx': instance.idx,
  'sales_order_no': instance.salesOrderNo,
  'customer_name': instance.customerName,
  'packing_date': instance.packingDate,
  'shift': instance.shift,
  'packed_by': instance.packedBy,
  'remarks': instance.remarks,
  'no_of_boxes': instance.noOfBoxes,
  'is_sticker_printed': instance.isStickerPrinted,
  'amended_from': instance.amendedFrom,
};
