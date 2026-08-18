

import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
part 'hardware_item.freezed.dart';
part 'hardware_item.g.dart';

@freezed
class HardwareItem with _$HardwareItem {
  const factory HardwareItem({
    String? status,
    String? slNO,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'box_count') int? boxCount,
    @JsonKey(name: 'mes_qr__barcode_value') String? mesBarCode,
    @JsonKey(name: 'uom') String? uom,
    @JsonKey(name: 'description') String? productName,
    @JsonKey(name: 'qty_on_sticker') int? qtySticker,
    @JsonKey(name: 'sap_code') String? materialCode,
    @JsonKey(name: 'mes_sticker_image') String? mesStcikerImage,
      @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? mesStickerImage,
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? box,
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? page,
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? boxType,
  @Default(<String>[]) @JsonKey(includeFromJson: false, includeToJson: false) List<String> deletedLines,


   }) = _HardwareItem;

  factory HardwareItem.fromJson(Map<String, dynamic> json) =>
      _$HardwareItemFromJson(json);
}
