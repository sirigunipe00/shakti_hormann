import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';

part 'installation_line_items.freezed.dart';
part 'installation_line_items.g.dart';

@freezed
class InstallationLineItems with _$InstallationLineItems {
  const factory InstallationLineItems({
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
    @JsonKey(includeFromJson: false, includeToJson: false) String? boxNo,

    @JsonKey(name: 'image') String? image,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? installtionPhotoImg,
  }) = _InstallationLineItems;

  factory InstallationLineItems.fromJson(Map<String, dynamic> json) =>
      _$InstallationLineItemsFromJson(json);
}
