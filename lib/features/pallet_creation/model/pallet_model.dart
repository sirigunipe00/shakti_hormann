import 'package:freezed_annotation/freezed_annotation.dart';

part 'pallet_model.freezed.dart';
part 'pallet_model.g.dart';

@freezed
class PalletModel with _$PalletModel {
  const factory PalletModel({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation',defaultValue: '') String? creationDate,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'modified') String? modifiedDate,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'sales_order') String? salesOrder,
    @JsonKey(name: 'no_of_pallets') int? noofPallets,
     }) = _PalletModel;
  factory PalletModel.fromJson(Map<String, dynamic> json) =>
      _$PalletModelFromJson(json);
}