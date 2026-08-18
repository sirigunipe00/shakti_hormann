// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hardware_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HardwareItemImpl _$$HardwareItemImplFromJson(Map<String, dynamic> json) =>
    _$HardwareItemImpl(
      status: json['status'] as String?,
      slNO: json['slNO'] as String?,
      name: json['name'] as String?,
      owner: json['owner'] as String?,
      creation: json['creation'] as String?,
      modified: json['modified'] as String?,
      modifiedBy: json['modified_by'] as String?,
      boxCount: (json['box_count'] as num?)?.toInt(),
      mesBarCode: json['mes_qr__barcode_value'] as String?,
      uom: json['uom'] as String?,
      productName: json['description'] as String?,
      qtySticker: (json['qty_on_sticker'] as num?)?.toInt(),
      materialCode: json['sap_code'] as String?,
      mesStcikerImage: json['mes_sticker_image'] as String?,
      mesStickerImage: toNull(json['mesStickerImage']),
    );

Map<String, dynamic> _$$HardwareItemImplToJson(_$HardwareItemImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'slNO': instance.slNO,
      'name': instance.name,
      'owner': instance.owner,
      'creation': instance.creation,
      'modified': instance.modified,
      'modified_by': instance.modifiedBy,
      'box_count': instance.boxCount,
      'mes_qr__barcode_value': instance.mesBarCode,
      'uom': instance.uom,
      'description': instance.productName,
      'qty_on_sticker': instance.qtySticker,
      'sap_code': instance.materialCode,
      'mes_sticker_image': instance.mesStcikerImage,
    };
