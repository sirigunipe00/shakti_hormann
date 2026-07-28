// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vision_panel_entry_lines.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisionPanelEntryLinesImpl _$$VisionPanelEntryLinesImplFromJson(
  Map<String, dynamic> json,
) => _$VisionPanelEntryLinesImpl(
  name: json['name'] as String?,
  owner: json['owner'] as String?,
  creation: json['creation'] as String?,
  modified: json['modified'] as String?,
  modifiedBy: json['modified_by'] as String?,
  docStatus: (json['docstatus'] as num?)?.toInt(),
  idx: (json['idx'] as num?)?.toInt(),
  parent: json['parent'] as String?,
  parentField: json['parentfield'] as String?,
  parentType: json['parenttype'] as String?,
  productType: json['product_type'] as String?,
  itemIndex: (json['itemIndex'] as num?)?.toInt(),
  image: json['image'] as String?,
  visionPhotoImg: toNull(json['visionPhotoImg']),
);

Map<String, dynamic> _$$VisionPanelEntryLinesImplToJson(
  _$VisionPanelEntryLinesImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'owner': instance.owner,
  'creation': instance.creation,
  'modified': instance.modified,
  'modified_by': instance.modifiedBy,
  'docstatus': instance.docStatus,
  'idx': instance.idx,
  'parent': instance.parent,
  'parentfield': instance.parentField,
  'parenttype': instance.parentType,
  'product_type': instance.productType,
  'itemIndex': instance.itemIndex,
  'image': instance.image,
};
