import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'hardware_packing.freezed.dart';
part 'hardware_packing.g.dart';

@freezed
class HardwarePacking with _$HardwarePacking {
  const factory HardwarePacking({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'box_count') int? boxCount,
    @JsonKey(name: 'sales_order_no') String? salesOrderNo,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'capture_date') String? captueDate,
    @JsonKey(name: 'operator') String? operator,
    @JsonKey(name: 'mes_number') String? mesSystem,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(includeFromJson: false, includeToJson: false)
    File? mesStickerImage,
    @JsonKey(includeFromJson: false, includeToJson: false) int? totalBoxCount,
    @Default(<int>[])
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<int> scannedBoxNumbers,
  }) = _HardwarePacking;

  factory HardwarePacking.fromJson(Map<String, dynamic> json) =>
      _$HardwarePackingFromJson(json);
}
