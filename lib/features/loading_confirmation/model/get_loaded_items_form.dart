import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_loaded_items_form.freezed.dart';
part 'get_loaded_items_form.g.dart';

@freezed
class ItemsLoaded with _$ItemsLoaded {
  const factory ItemsLoaded({
    String? name,
    String? owner,
    String? creation,
    String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    int? docstatus,
    int? idx,
    @JsonKey(name: 'item_code') String? itemCode,
    @JsonKey(name: 'qty_loaded') int? qtyLoaded,
    String? uom,
    @JsonKey(name: 'item_name') String? itemName,
    String? parent,
    String? parentfield,
    String? parenttype,
    String? doctype,
  }) = _ItemsLoaded;

  factory ItemsLoaded.fromJson(Map<String, dynamic> json) =>
      _$ItemsLoadedFromJson(json);
}