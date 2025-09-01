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
  customerName: json['customer_name'] as String?,
  orderDate: json['order_date'] as String?,
  remarks: json['remarks'] as String?,
);

Map<String, dynamic> _$$SalesInvoiceFormImplToJson(
  _$SalesInvoiceFormImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'company': instance.plantName,
  'posting_date': instance.postingDate,
  'vehicle_no': instance.vehicleNo,
  'customer_name': instance.customerName,
  'order_date': instance.orderDate,
  'remarks': instance.remarks,
};
