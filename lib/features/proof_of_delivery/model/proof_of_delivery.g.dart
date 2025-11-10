// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof_of_delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProofOfDeliveryImpl _$$ProofOfDeliveryImplFromJson(
  Map<String, dynamic> json,
) => _$ProofOfDeliveryImpl(
  status: json['status'] as String?,
  name: json['name'] as String?,
  docStatus: (json['docstatus'] as num?)?.toInt(),
  podDate: json['pod_date'] as String? ?? '',
  salesInvoice: json['sales_invoice_no'] as String?,
  salesInvoiceDate: json['sales_invoice_date'] as String?,
  customerName: json['customer_name'] as String?,
  plantName: json['plant_name'] as String?,
  geoLongitude: json['geo_longitude'] as String?,
  podPhoto: json['pod_photo'] as String?,
  unloadingPhoto1: json['unloading_photo_1'] as String?,
  unloadingPhoto2: json['unloading_photo_2'] as String?,
  geoLatitude: json['geo_latitude'] as String?,
  podPhotoImg: toNull(json['podPhotoImg']),
  unloadingPhotoImg1: toNull(json['unloadingPhotoImg1']),
  unloadingPhotoImg2: toNull(json['unloadingPhotoImg2']),
);

Map<String, dynamic> _$$ProofOfDeliveryImplToJson(
  _$ProofOfDeliveryImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'name': instance.name,
  'docstatus': instance.docStatus,
  'pod_date': instance.podDate,
  'sales_invoice_no': instance.salesInvoice,
  'sales_invoice_date': instance.salesInvoiceDate,
  'customer_name': instance.customerName,
  'plant_name': instance.plantName,
  'geo_longitude': instance.geoLongitude,
  'pod_photo': instance.podPhoto,
  'unloading_photo_1': instance.unloadingPhoto1,
  'unloading_photo_2': instance.unloadingPhoto2,
  'geo_latitude': instance.geoLatitude,
};
