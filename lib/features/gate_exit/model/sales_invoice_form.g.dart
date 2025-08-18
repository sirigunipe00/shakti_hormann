// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_invoice_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesInvoiceFormImpl _$$SalesInvoiceFormImplFromJson(
  Map<String, dynamic> json,
) => _$SalesInvoiceFormImpl(
  name: json['name'] as String?,
  plantName: json['company'] as String?,
  postingDate: json['posting_date'] as String? ?? '',
  vehicleNo: json['vehicle_no'] as String? ?? '',
  remarks: json['remarks'] as String?,
);

Map<String, dynamic> _$$SalesInvoiceFormImplToJson(
  _$SalesInvoiceFormImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'company': instance.plantName,
  'posting_date': instance.postingDate,
  'vehicle_no': instance.vehicleNo,
  'remarks': instance.remarks,
};
