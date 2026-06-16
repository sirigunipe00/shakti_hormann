// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StorageImpl _$$StorageImplFromJson(Map<String, dynamic> json) =>
    _$StorageImpl(
      name: json['name'] as String?,
      storedBy: json['stored_by'] as String?,
      storageTimeStamp: json['storage_timestamp'] as String?,
      remarks: json['remarks'] as String?,
      locationPhoto: json['location_photo'] as String?,
      locationPhotoImg: toNull(json['locationPhotoImg']),
      zoneQr: json['zone_qr'] as String?,
      palletBoxQr: json['pallet__box_qr_scan'] as String?,
    );

Map<String, dynamic> _$$StorageImplToJson(_$StorageImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'stored_by': instance.storedBy,
      'storage_timestamp': instance.storageTimeStamp,
      'remarks': instance.remarks,
      'location_photo': instance.locationPhoto,
      'zone_qr': instance.zoneQr,
      'pallet__box_qr_scan': instance.palletBoxQr,
    };
