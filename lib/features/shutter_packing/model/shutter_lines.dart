import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'shutter_lines.freezed.dart';
part 'shutter_lines.g.dart';

@freezed
class ShutterLines with _$ShutterLines {
  const factory ShutterLines({
    String? shutterBarcode,
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

    @JsonKey(name: 'shutter_barcode__qr') String? shutterBarcodeQr,

    @JsonKey(name: 'item_code') String? itemCode,

    @JsonKey(name: 'item_name') String? itemName,

    @JsonKey(name: 'box_serial') String? boxSerial,

    @JsonKey(name: 'sales_order') String? salesOrder,

    @JsonKey(name: 'customer') String? customer,

    @JsonKey(name: 'scan_time') String? scanTime,

    @JsonKey(
      name: 'shutter_photo',
      fromJson: _photosFromJson,
      toJson: _photosToJson,
    )
    List<String>? shutterPhoto,

    @JsonKey(includeFromJson: false, includeToJson: false)
    List<File>? shutterPhotoImg,
  }) = _ShutterLines;

  factory ShutterLines.fromJson(Map<String, dynamic> json) =>
      _$ShutterLinesFromJson(json);
}

List<File>? toNullList(dynamic _) => null;
List<String>? _photosFromJson(dynamic json) {
  if (json == null) return null;

  if (json is String) {
    return [json];
  }

  if (json is List) {
    return json.cast<String>();
  }

  return null;
}

dynamic _photosToJson(List<String>? value) => value;
