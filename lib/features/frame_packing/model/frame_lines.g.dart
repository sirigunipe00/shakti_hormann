// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_lines.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FrameLinesImpl _$$FrameLinesImplFromJson(Map<String, dynamic> json) =>
    _$FrameLinesImpl(
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
      shutterBarcodeQr: json['frame_barcode'] as String?,
      itemCode: json['item_code'] as String?,
      itemName: json['item_name'] as String?,
      salesOrder: json['sales_order'] as String?,
      customer: json['customer'] as String?,
      scanTime: json['scan_time'] as String?,
      shutterPhoto: _photosFromJson(json['frame_photo']),
    );

Map<String, dynamic> _$$FrameLinesImplToJson(_$FrameLinesImpl instance) =>
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
      'frame_barcode': instance.shutterBarcodeQr,
      'item_code': instance.itemCode,
      'item_name': instance.itemName,
      'sales_order': instance.salesOrder,
      'customer': instance.customer,
      'scan_time': instance.scanTime,
      'frame_photo': _photosToJson(instance.shutterPhoto),
    };
