// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_loaded_items_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemsLoadedImpl _$$ItemsLoadedImplFromJson(Map<String, dynamic> json) =>
    _$ItemsLoadedImpl(
      name: json['name'] as String?,
      owner: json['owner'] as String?,
      creation: json['creation'] as String?,
      modified: json['modified'] as String?,
      modifiedBy: json['modified_by'] as String?,
      docstatus: (json['docstatus'] as num?)?.toInt(),
      idx: (json['idx'] as num?)?.toInt(),
      itemCode: json['item_code'] as String?,
      qtyLoaded: (json['qty_loaded'] as num?)?.toInt(),
      uom: json['uom'] as String?,
      itemName: json['item_name'] as String?,
      parent: json['parent'] as String?,
      parentfield: json['parentfield'] as String?,
      parenttype: json['parenttype'] as String?,
      doctype: json['doctype'] as String?,
    );

Map<String, dynamic> _$$ItemsLoadedImplToJson(_$ItemsLoadedImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'owner': instance.owner,
      'creation': instance.creation,
      'modified': instance.modified,
      'modified_by': instance.modifiedBy,
      'docstatus': instance.docstatus,
      'idx': instance.idx,
      'item_code': instance.itemCode,
      'qty_loaded': instance.qtyLoaded,
      'uom': instance.uom,
      'item_name': instance.itemName,
      'parent': instance.parent,
      'parentfield': instance.parentfield,
      'parenttype': instance.parenttype,
      'doctype': instance.doctype,
    };
