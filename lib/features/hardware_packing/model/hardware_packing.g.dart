// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hardware_packing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HardwarePackingImpl _$$HardwarePackingImplFromJson(
  Map<String, dynamic> json,
) => _$HardwarePackingImpl(
  status: json['status'] as String?,
  allocationStatus: json['allocation_status'] as String?,
  currentZone: json['current_zone'] as String?,
  name: json['name'] as String?,
  owner: json['owner'] as String?,
  creation: json['creation'] as String?,
  modified: json['modified'] as String?,
  modifiedBy: json['modified_by'] as String?,
  docStatus: (json['docstatus'] as num?)?.toInt(),
  idx: (json['idx'] as num?)?.toInt(),
  boxCount: (json['box_count'] as num?)?.toInt(),
  salesOrderNo: json['sales_order_no'] as String?,
  customerName: json['customer_name'] as String?,
  captueDate: json['capture_date'] as String?,
  operator: json['operator'] as String?,
  mesSystem: json['mes_number'] as String?,
  remarks: json['remarks'] as String?,
);

Map<String, dynamic> _$$HardwarePackingImplToJson(
  _$HardwarePackingImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'name': instance.name,
  'owner': instance.owner,
  'creation': instance.creation,
  'modified': instance.modified,
  'modified_by': instance.modifiedBy,
  'docstatus': instance.docStatus,
  'idx': instance.idx,
  'box_count': instance.boxCount,
  'sales_order_no': instance.salesOrderNo,
  'customer_name': instance.customerName,
  'capture_date': instance.captueDate,
  'operator': instance.operator,
  'mes_number': instance.mesSystem,
  'remarks': instance.remarks,
};
