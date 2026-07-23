// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vision_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisionModelImpl _$$VisionModelImplFromJson(Map<String, dynamic> json) =>
    _$VisionModelImpl(
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
      totalBoxes: (json['total_boxes'] as num?)?.toInt(),
      remarks: json['remarks'] as String?,
      amendedFrom: json['amended_from'] as String?,
    );

Map<String, dynamic> _$$VisionModelImplToJson(_$VisionModelImpl instance) =>
    <String, dynamic>{
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
      'total_boxes': instance.totalBoxes,
      'remarks': instance.remarks,
      'amended_from': instance.amendedFrom,
    };
