import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';

part 'vision_panel_entry_lines.freezed.dart';
part 'vision_panel_entry_lines.g.dart';

@freezed
class VisionPanelEntryLines with _$VisionPanelEntryLines {
  const factory VisionPanelEntryLines({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'parent') String? parent,
    @JsonKey(name: 'parentfield') String? parentField,
    @JsonKey(name: 'parenttype') String? parentType,
    @JsonKey(name: 'product_type') String? productType,
    @JsonKey(name: 'box_no') String? boxNo,
    @JsonKey(name: 'box_index') int? boxIndex,
    @JsonKey(name: 'box_code') String? boxCode,
     int? itemIndex,
    @JsonKey(name: 'image') String? image,
    /// Per-box warehouse status (server-only). Unallocated / Allocated / Dispatched.
    @JsonKey(
      name: 'allocation_status',
      includeFromJson: true,
      includeToJson: false,
    )
    String? allocationStatus,
    @JsonKey(name: 'current_zone', includeFromJson: true, includeToJson: false)
    String? currentZone,
     @JsonKey(
        includeFromJson: true,
        includeToJson: false,
        toJson: toNull,
        fromJson: toNull)
    File? visionPhotoImg,
  }) = _VisionPanelEntryLines;

  factory VisionPanelEntryLines.fromJson(Map<String, dynamic> json) =>
      _$VisionPanelEntryLinesFromJson(json);
}