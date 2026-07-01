// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pallet_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PalletDetailsImpl _$$PalletDetailsImplFromJson(Map<String, dynamic> json) =>
    _$PalletDetailsImpl(
      status: (json['status'] as num?)?.toInt(),
      data:
          json['data'] == null
              ? null
              : PalletData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PalletDetailsImplToJson(_$PalletDetailsImpl instance) =>
    <String, dynamic>{'status': instance.status, 'data': instance.data};

_$PalletDataImpl _$$PalletDataImplFromJson(Map<String, dynamic> json) =>
    _$PalletDataImpl(
      doctype: json['doctype'] as String?,
      palletNo: json['pallet_no'] as String?,
      totalQty: (json['total_qty'] as num?)?.toInt(),
      salesOrders:
          (json['sales_orders'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$$PalletDataImplToJson(_$PalletDataImpl instance) =>
    <String, dynamic>{
      'doctype': instance.doctype,
      'pallet_no': instance.palletNo,
      'total_qty': instance.totalQty,
      'sales_orders': instance.salesOrders,
    };
