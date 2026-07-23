// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pallet_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PalletItemsImpl _$$PalletItemsImplFromJson(Map<String, dynamic> json) =>
    _$PalletItemsImpl(
      name: json['name'] as String?,
      owner: json['owner'] as String?,
      creation: json['creation'] as String?,
      modified: json['modified'] as String?,
      modifiedBy: json['modified_by'] as String?,
      docstatus: (json['docstatus'] as num?)?.toInt(),
      idx: (json['idx'] as num?)?.toInt(),
      parent: json['parent'] as String?,
      parentField: json['parentfield'] as String?,
      parentType: json['parenttype'] as String?,
      productType: json['product_type'] as String?,
      size: json['size'] as String?,
      noOfPallets: (json['no_of_pallets'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PalletItemsImplToJson(_$PalletItemsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'owner': instance.owner,
      'creation': instance.creation,
      'modified': instance.modified,
      'modified_by': instance.modifiedBy,
      'docstatus': instance.docstatus,
      'idx': instance.idx,
      'parent': instance.parent,
      'parentfield': instance.parentField,
      'parenttype': instance.parentType,
      'product_type': instance.productType,
      'size': instance.size,
      'no_of_pallets': instance.noOfPallets,
    };
