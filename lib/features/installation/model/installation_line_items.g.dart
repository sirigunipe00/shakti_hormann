// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installation_line_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstallationLineItemsImpl _$$InstallationLineItemsImplFromJson(
  Map<String, dynamic> json,
) => _$InstallationLineItemsImpl(
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
  boxNo: json['box_no'] as String?,
  image: json['image'] as String?,
  installtionPhotoImg: toNull(json['installtionPhotoImg']),
);

Map<String, dynamic> _$$InstallationLineItemsImplToJson(
  _$InstallationLineItemsImpl instance,
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
  'box_no': instance.boxNo,
  'image': instance.image,
};
