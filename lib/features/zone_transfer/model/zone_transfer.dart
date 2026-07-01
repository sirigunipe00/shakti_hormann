import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';

part 'zone_transfer.freezed.dart';
part 'zone_transfer.g.dart';

@freezed
class ZoneTransfer with _$ZoneTransfer {
  const factory ZoneTransfer({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'stored_by') String? storedBy,
    @JsonKey(name: 'old_zone_qr') String? oldZone,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'location_photo') String? locationPhoto,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'sales_order') String? salesOrders,
    @JsonKey(name: 'new_zone_name') String? newzoneName,
    @JsonKey(name: 'total_qty') int? totalQty,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? locationPhotoImg,
    @JsonKey(name: 'new_zone_qr') String? newzoneQr,
    @JsonKey(name: 'pallet__box_qr_scan') String? palletBoxQr
}) = _ZoneTransfer;

  factory ZoneTransfer.fromJson(Map<String, dynamic> json) =>
      _$ZoneTransferFromJson(json);
}