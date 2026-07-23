import 'package:freezed_annotation/freezed_annotation.dart';

part 'vision_items.freezed.dart';
part 'vision_items.g.dart';

@freezed
class VisionItems with _$VisionItems {
  const factory VisionItems({
    @JsonKey(name: 'name')
    String? name,

    @JsonKey(name: 'owner')
    String? owner,

    @JsonKey(name: 'creation')
    String? creation,

    @JsonKey(name: 'modified')
    String? modified,

    @JsonKey(name: 'modified_by')
    String? modifiedBy,

    @JsonKey(name: 'docstatus')
    int? docStatus,

    @JsonKey(name: 'idx')
    int? idx,

    @JsonKey(name: 'parent')
    String? parent,

    @JsonKey(name: 'parentfield')
    String? parentField,

    @JsonKey(name: 'parenttype')
    String? parentType,

    @JsonKey(name: 'product_type')
    String? productType,

    @JsonKey(name: 'no_of_boxes')
    int? noOfBoxes,
  }) = _VisionItems;

  factory VisionItems.fromJson(Map<String, dynamic> json) =>
      _$VisionItemsFromJson(json);
}