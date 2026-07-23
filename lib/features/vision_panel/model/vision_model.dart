import 'package:freezed_annotation/freezed_annotation.dart';

part 'vision_model.freezed.dart';
part 'vision_model.g.dart';

@freezed
class VisionModel with _$VisionModel {
  const factory VisionModel({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'sales_order_no') String? salesOrderNo,

    @JsonKey(name: 'customer_name') String? customerName,

    @JsonKey(name: 'packing_date') String? packingDate,

    @JsonKey(name: 'shift') String? shift,

    @JsonKey(name: 'packed_by') String? packedBy,

    @JsonKey(name: 'total_boxes') int? totalBoxes,

    @JsonKey(name: 'remarks') String? remarks,

    @JsonKey(name: 'amended_from') String? amendedFrom,
  }) = _VisionModel;

  factory VisionModel.fromJson(Map<String, dynamic> json) =>
      _$VisionModelFromJson(json);
}
