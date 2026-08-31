// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StorageImpl _$$StorageImplFromJson(Map<String, dynamic> json) =>
    _$StorageImpl(
      status: json['status'] as String?,
      allocationStatus: json['allocation_status'] as String?,
      currentZone: json['current_zone'] as String?,
      name: json['name'] as String?,
      storedBy: json['stored_by'] as String?,
      storageTimeStamp: json['storage_timestamp'] as String?,
      remarks: json['remarks'] as String?,
      locationPhoto: json['location_photo'] as String?,
      docStatus: (json['docstatus'] as num?)?.toInt(),
      salesOrders: json['sales_order'] as String?,
      zoneName: json['zone_name'] as String?,
      totalQty: (json['total_qty'] as num?)?.toInt(),
      creation: json['creation'] as String?,
      palletCount: (json['pallet_count'] as num?)?.toInt(),
      oldZone: json['old_zone_name'] as String?,
      locationPhotoImg: toNull(json['locationPhotoImg']),
      zoneQr: json['zone_qr'] as String?,
      palletBoxQr: json['pallet__box_qr_scan'] as String?,
    );

Map<String, dynamic> _$$StorageImplToJson(_$StorageImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'name': instance.name,
      'stored_by': instance.storedBy,
      'storage_timestamp': instance.storageTimeStamp,
      'remarks': instance.remarks,
      'location_photo': instance.locationPhoto,
      'docstatus': instance.docStatus,
      'sales_order': instance.salesOrders,
      'zone_name': instance.zoneName,
      'total_qty': instance.totalQty,
      'creation': instance.creation,
      'pallet_count': instance.palletCount,
      'old_zone_name': instance.oldZone,
      'zone_qr': instance.zoneQr,
      'pallet__box_qr_scan': instance.palletBoxQr,
    };
