import 'package:freezed_annotation/freezed_annotation.dart';

part 'installation_model.freezed.dart';
part 'installation_model.g.dart';

@freezed
class InstallationModel with _$InstallationModel {
  const factory InstallationModel({
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

    @JsonKey(name: 'remarks') String? remarks,

    @JsonKey(name: 'no_of_boxes') int? noOfBoxes,

    @JsonKey(name: 'is_sticker_printed') int? isStickerPrinted,

    @JsonKey(name: 'amended_from') String? amendedFrom,
  }) = _InstallationModel;

  factory InstallationModel.fromJson(Map<String, dynamic> json) =>
      _$InstallationModelFromJson(json);
}
