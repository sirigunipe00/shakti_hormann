import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';

part 'hardware_packing_item.freezed.dart';
part 'hardware_packing_item.g.dart';

@freezed
class HardwarePackingItem with _$HardwarePackingItem {
  const factory HardwarePackingItem({
    @JsonKey(name: 'document_type') String? documentType,

    @JsonKey(name: 'order_number') String? orderNumber,

    @JsonKey(name: 'print_date') String? printDate,

    @JsonKey(name: 'mes_number') String? mesBarCode,

    @JsonKey(name: 'box_type') String? boxType,

   @JsonKey(name: 'page') String? page,

   @JsonKey(name: 'box') String? box,


    @JsonKey(name: 'sr_no') int? slNO,

    @JsonKey(name: 'sap_code') String? materialCode,

    @JsonKey(name: 'description') String? productName,

    @JsonKey(name: 'qty') int? qtySticker,

    @JsonKey(name: 'uom') String? uom,

    @Default([]) @JsonKey(name: 'items') List<HardwarePackingItem> items,

    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? mesStickerImage,

    @Default([])
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<String> deletedLines,
  }) = _HardwarePackingItem;

  factory HardwarePackingItem.fromJson(Map<String, dynamic> json) =>
      _$HardwarePackingItemFromJson(json);
}
