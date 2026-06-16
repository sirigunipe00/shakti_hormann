import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';

part 'frame_lines.freezed.dart';
part 'frame_lines.g.dart';

@freezed
class FrameLines with _$FrameLines {
  const factory FrameLines({
    String? shutterBarcode,
    @JsonKey(name: 'name')
    String? name,

    @JsonKey(name: 'owner')
    String? owner,

    @JsonKey(name: 'creation')
    String? creation,

    @JsonKey(name: 'modified')
    String? modified,

    @JsonKey(name: 'modified_by')
    String? modifiedBy,

    @JsonKey(name: 'docstatus')
    int? docStatus,

    @JsonKey(name: 'idx')
    int? idx,

    @JsonKey(name: 'parent')
    String? parent,

    @JsonKey(name: 'parentfield')
    String? parentField,

    @JsonKey(name: 'parenttype')
    String? parentType,

    @JsonKey(name: 'frame_barcode')
    String? shutterBarcodeQr,

    @JsonKey(name: 'item_code')
    String? itemCode,

    @JsonKey(name: 'item_name')
    String? itemName,

    @JsonKey(name: 'sales_order')
    String? salesOrder,

    @JsonKey(name: 'customer')
    String? customer,

    @JsonKey(name: 'scan_time')
    String? scanTime,

    @JsonKey(name: 'frame_photo')
    String? shutterPhoto,

    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? shutterPhotoImg,

  }) = _FrameLines;


  factory FrameLines.fromJson(Map<String, dynamic> json) =>
      _$FrameLinesFromJson(json);
}


