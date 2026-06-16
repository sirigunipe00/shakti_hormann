import 'package:freezed_annotation/freezed_annotation.dart';

part 'frame_items.freezed.dart';
part 'frame_items.g.dart';

@freezed
class FrameItems with _$FrameItems {
  const factory FrameItems({
    @JsonKey(name: 'name')String? name,
    @JsonKey(name: 'item_code') String? itemCode,
    @JsonKey(name: 'item_name') String? itemName,
    }) = _FrameItems;

  factory FrameItems.fromJson(Map<String, dynamic> json) =>
      _$FrameItemsFromJson(json);
}