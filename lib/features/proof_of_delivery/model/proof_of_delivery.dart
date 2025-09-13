import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';

part 'proof_of_delivery.freezed.dart';
part 'proof_of_delivery.g.dart';

@freezed
class ProofOfDelivery with _$ProofOfDelivery {
  const factory ProofOfDelivery({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'pod_date', defaultValue: '') String? podDate,
    @JsonKey(name: 'sales_invoice_no') String? salesInvoice,
    @JsonKey(name: 'sales_invoice_date') String? salesInvoiceDate,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'geo_longitude') double? geoLongitude,
    @JsonKey(name: 'pod_photo') String? podPhoto,
    @JsonKey(name: 'unloading_photo_1') String? unloadingPhoto1,
    @JsonKey(name: 'unloading_photo_2') String? unloadingPhoto2,
    @JsonKey(name: 'geo_latitude') double? geoLatitude,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? podPhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? unloadingPhotoImg1,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? unloadingPhotoImg2,
  }) = _ProofOfDelivery;
  factory ProofOfDelivery.fromJson(Map<String, dynamic> json) =>
      _$ProofOfDeliveryFromJson(json);
}
