// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ZoneTransferImpl _$$ZoneTransferImplFromJson(Map<String, dynamic> json) =>
    _$ZoneTransferImpl(
      status: json['status'] as String?,
      name: json['name'] as String?,
      storedBy: json['stored_by'] as String?,
      oldZone: json['old_zone_qr'] as String?,
      remarks: json['remarks'] as String?,
      locationPhoto: json['location_photo'] as String?,
      docStatus: (json['docstatus'] as num?)?.toInt(),
      salesOrders: json['sales_order'] as String?,
      newzoneName: json['new_zone_name'] as String?,
      totalQty: (json['total_qty'] as num?)?.toInt(),
      creation: json['creation'] as String?,
      locationPhotoImg: toNull(json['locationPhotoImg']),
      newzoneQr: json['new_zone_qr'] as String?,
      palletBoxQr: json['pallet__box_qr_scan'] as String?,
    );

Map<String, dynamic> _$$ZoneTransferImplToJson(_$ZoneTransferImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'name': instance.name,
      'stored_by': instance.storedBy,
      'old_zone_qr': instance.oldZone,
      'remarks': instance.remarks,
      'location_photo': instance.locationPhoto,
      'docstatus': instance.docStatus,
      'sales_order': instance.salesOrders,
      'new_zone_name': instance.newzoneName,
      'total_qty': instance.totalQty,
      'creation': instance.creation,
      'new_zone_qr': instance.newzoneQr,
      'pallet__box_qr_scan': instance.palletBoxQr,
    };
