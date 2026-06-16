import 'package:freezed_annotation/freezed_annotation.dart';

part 'items.freezed.dart';
part 'items.g.dart';

@freezed
class Items with _$Items {
  const factory Items({
    @JsonKey(name: 'name')String? name,
    @JsonKey(name: 'item_code') String? itemCode,
    @JsonKey(name: 'item_name') String? itemName,
    }) = _Items;

  factory Items.fromJson(Map<String, dynamic> json) =>
      _$ItemsFromJson(json);
}