import 'package:freezed_annotation/freezed_annotation.dart';

part 'pallet_items.freezed.dart';
part 'pallet_items.g.dart';

@freezed
class PalletItems with _$PalletItems {
  const factory PalletItems({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docstatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'parent') String? parent,
    @JsonKey(name: 'parentfield') String? parentField,
    @JsonKey(name: 'parenttype') String? parentType,
    @JsonKey(name: 'product_type') String? productType,
    @JsonKey(name: 'size') String? size,
    @JsonKey(name: 'no_of_pallets') int? noOfPallets,
  }) = _PalletItems;

  factory PalletItems.fromJson(Map<String, dynamic> json) =>
      _$PalletItemsFromJson(json);
}