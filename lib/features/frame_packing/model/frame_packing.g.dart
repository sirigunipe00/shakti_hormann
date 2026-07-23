// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_packing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FramePackingImpl _$$FramePackingImplFromJson(Map<String, dynamic> json) =>
    _$FramePackingImpl(
      status: json['status'] as String?,
      name: json['name'] as String?,
      owner: json['owner'] as String?,
      creation: json['creation'] as String?,
      modified: json['modified'] as String?,
      modifiedBy: json['modified_by'] as String?,
      docStatus: (json['docstatus'] as num?)?.toInt(),
      idx: (json['idx'] as num?)?.toInt(),
      packingDate: json['packing_date'] as String?,
      shift: json['shift'] as String?,
      operator: json['operator__packed_by'] as String?,
      palletNo: json['pallet_no'] as String?,
      palletCode: json['pallet_code'] as String?,
      salesOrder: json['sales_order'] as String?,
      palletPhoto: json['pallet_photo'] as String?,
      palletPhotoImg: toNull(json['palletPhotoImg']),
      totalUnitsOnPallet: (json['total_units_on_pallet'] as num?)?.toInt(),
      palletQrPrinted: (json['pallet_qr_printed'] as num?)?.toInt(),
      remarks: json['remarks'] as String?,
      amendedFrom: json['amended_from'] as String?,
    );

Map<String, dynamic> _$$FramePackingImplToJson(_$FramePackingImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'name': instance.name,
      'owner': instance.owner,
      'creation': instance.creation,
      'modified': instance.modified,
      'modified_by': instance.modifiedBy,
      'docstatus': instance.docStatus,
      'idx': instance.idx,
      'packing_date': instance.packingDate,
      'shift': instance.shift,
      'operator__packed_by': instance.operator,
      'pallet_no': instance.palletNo,
      'pallet_code': instance.palletCode,
      'sales_order': instance.salesOrder,
      'pallet_photo': instance.palletPhoto,
      'total_units_on_pallet': instance.totalUnitsOnPallet,
      'pallet_qr_printed': instance.palletQrPrinted,
      'remarks': instance.remarks,
      'amended_from': instance.amendedFrom,
    };
