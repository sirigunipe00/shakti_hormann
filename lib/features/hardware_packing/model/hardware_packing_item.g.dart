// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hardware_packing_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HardwarePackingItemImpl _$$HardwarePackingItemImplFromJson(
  Map<String, dynamic> json,
) => _$HardwarePackingItemImpl(
  documentType: json['document_type'] as String?,
  orderNumber: json['order_number'] as String?,
  printDate: json['print_date'] as String?,
  mesBarCode: json['mes_number'] as String?,
  boxType: json['box_type'] as String?,
  page: json['page'] as String?,
  box: json['box'] as String?,
  slNO: (json['sr_no'] as num?)?.toInt(),
  materialCode: json['sap_code'] as String?,
  productName: json['description'] as String?,
  qtySticker: (json['qty'] as num?)?.toInt(),
  uom: json['uom'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => HardwarePackingItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  mesStickerImage: toNull(json['mesStickerImage']),
);

Map<String, dynamic> _$$HardwarePackingItemImplToJson(
  _$HardwarePackingItemImpl instance,
) => <String, dynamic>{
  'document_type': instance.documentType,
  'order_number': instance.orderNumber,
  'print_date': instance.printDate,
  'mes_number': instance.mesBarCode,
  'box_type': instance.boxType,
  'page': instance.page,
  'box': instance.box,
  'sr_no': instance.slNO,
  'sap_code': instance.materialCode,
  'description': instance.productName,
  'qty': instance.qtySticker,
  'uom': instance.uom,
  'items': instance.items,
};
