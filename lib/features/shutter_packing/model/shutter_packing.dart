import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';

part 'shutter_packing.freezed.dart';
part 'shutter_packing.g.dart';

@freezed
class ShutterPacking with _$ShutterPacking {
  const factory ShutterPacking({
    String? status,
    /// Unallocated / Allocated / Dispatched (warehouse allocation lifecycle).
    @JsonKey(
      name: 'allocation_status',
      includeFromJson: true,
      includeToJson: false,
    )
    String? allocationStatus,
    @JsonKey(name: 'current_zone', includeFromJson: true, includeToJson: false)
    String? currentZone,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'packing_date') String? packingDate,
    @JsonKey(name: 'shift') String? shift,
    @JsonKey(name: 'operator') String? operator,
    @JsonKey(name: 'pallet_no') String? palletNo,
    @JsonKey(name: 'pallet_code') String? palletCode,
    @JsonKey(name: 'freeze_quantity') int? freezeQuantity,
    @JsonKey(name: 'sales_order') String? salesOrder,
    @JsonKey(name: 'pallet_photo') String? palletPhoto,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? palletPhotoImg,
    @JsonKey(name: 'total_shutters_on_pallet') int? totalShuttersOnPallet,
    @JsonKey(name: 'total_boxes_on_pallet') int? totalBoxesOnPallet,
    @JsonKey(name: 'pallet_qr_printed') int? palletQrPrinted,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'amended_from') String? amendedFrom,
    @Default(<String>[]) @JsonKey(includeFromJson: false, includeToJson: false) List<String> deletedLines,
    }) = _ShutterPacking;

  factory ShutterPacking.fromJson(Map<String, dynamic> json) =>
      _$ShutterPackingFromJson(json);
}
