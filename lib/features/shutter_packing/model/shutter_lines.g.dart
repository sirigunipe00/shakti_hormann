// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shutter_lines.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShutterLinesImpl _$$ShutterLinesImplFromJson(Map<String, dynamic> json) =>
    _$ShutterLinesImpl(
      shutterBarcode: json['shutterBarcode'] as String?,
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
      shutterBarcodeQr: json['shutter_barcode__qr'] as String?,
      itemCode: json['item_code'] as String?,
      itemName: json['item_name'] as String?,
      boxSerial: json['box_serial'] as String?,
      salesOrder: json['sales_order'] as String?,
      customer: json['customer'] as String?,
      scanTime: json['scan_time'] as String?,
      shutterPhoto: _photosFromJson(json['shutter_photo']),
    );

Map<String, dynamic> _$$ShutterLinesImplToJson(_$ShutterLinesImpl instance) =>
    <String, dynamic>{
      'shutterBarcode': instance.shutterBarcode,
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
      'shutter_barcode__qr': instance.shutterBarcodeQr,
      'item_code': instance.itemCode,
      'item_name': instance.itemName,
      'box_serial': instance.boxSerial,
      'sales_order': instance.salesOrder,
      'customer': instance.customer,
      'scan_time': instance.scanTime,
      'shutter_photo': _photosToJson(instance.shutterPhoto),
    };
