import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
part 'frame_packing.freezed.dart';
part 'frame_packing.g.dart';

@freezed
class FramePacking with _$FramePacking {
  const factory FramePacking({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'packing_date') String? packingDate,
    @JsonKey(name: 'shift') String? shift,
    @JsonKey(name: 'operator__packed_by') String? operator,
    @JsonKey(name: 'pallet_no') String? palletNo,
    @JsonKey(name: 'pallet_photo') String? palletPhoto,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? palletPhotoImg,
    @JsonKey(name: 'total_units_on_pallet') int? totalUnitsOnPallet,
    @JsonKey(name: 'pallet_qr_printed') int? palletQrPrinted,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'amended_from') String? amendedFrom,
    @Default(<String>[]) @JsonKey(includeFromJson: false, includeToJson: false) List<String> deletedLines,
    }) = _FramePacking;

  factory FramePacking.fromJson(Map<String, dynamic> json) =>
      _$FramePackingFromJson(json);
}
