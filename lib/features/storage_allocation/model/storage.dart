import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';

part 'storage.freezed.dart';
part 'storage.g.dart';

@freezed
class Storage with _$Storage {
  const factory Storage({
    String? status,
    /// Unallocated / Allocated / Dispatched.
    @JsonKey(
      name: 'allocation_status',
      includeFromJson: true,
      includeToJson: false,
    )
    String? allocationStatus,
    @JsonKey(name: 'current_zone', includeFromJson: true, includeToJson: false)
    String? currentZone,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'stored_by') String? storedBy,
    @JsonKey(name: 'storage_timestamp') String? storageTimeStamp,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'location_photo') String? locationPhoto,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'sales_order') String? salesOrders,
    @JsonKey(name: 'zone_name') String? zoneName,
    @JsonKey(name: 'total_qty') int? totalQty,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'pallet_count') int? palletCount,
    @JsonKey(name: 'old_zone_name') String? oldZone,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? locationPhotoImg,
    @JsonKey(name: 'zone_qr') String? zoneQr,
    @JsonKey(name: 'pallet__box_qr_scan') String? palletBoxQr
}) = _Storage;

  factory Storage.fromJson(Map<String, dynamic> json) =>
      _$StorageFromJson(json);
}