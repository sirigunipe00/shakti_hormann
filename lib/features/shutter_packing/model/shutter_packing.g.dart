// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shutter_packing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShutterPackingImpl _$$ShutterPackingImplFromJson(Map<String, dynamic> json) =>
    _$ShutterPackingImpl(
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
      operator: json['operator'] as String?,
      palletNo: json['pallet_no'] as String?,
      palletPhoto: json['pallet_photo'] as String?,
      palletPhotoImg: toNull(json['palletPhotoImg']),
      totalShuttersOnPallet:
          (json['total_shutters_on_pallet'] as num?)?.toInt(),
      totalBoxesOnPallet: (json['total_boxes_on_pallet'] as num?)?.toInt(),
      palletQrPrinted: (json['pallet_qr_printed'] as num?)?.toInt(),
      remarks: json['remarks'] as String?,
      amendedFrom: json['amended_from'] as String?,
    );

Map<String, dynamic> _$$ShutterPackingImplToJson(
  _$ShutterPackingImpl instance,
) => <String, dynamic>{
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
  'operator': instance.operator,
  'pallet_no': instance.palletNo,
  'pallet_photo': instance.palletPhoto,
  'total_shutters_on_pallet': instance.totalShuttersOnPallet,
  'total_boxes_on_pallet': instance.totalBoxesOnPallet,
  'pallet_qr_printed': instance.palletQrPrinted,
  'remarks': instance.remarks,
  'amended_from': instance.amendedFrom,
};
