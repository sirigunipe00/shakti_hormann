// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesOrderFormImpl _$$SalesOrderFormImplFromJson(Map<String, dynamic> json) =>
    _$SalesOrderFormImpl(
      name: json['name'] as String?,
      plantName: json['company'] as String?,
      addressDisplay: json['address_display'] as String?,
      customerName: json['customer_name'] as String?,
      customerPurchaseOrder: json['customers_purchase_order'] as String?,
      orderDate: json['order_date'] as String?,
      shippingAddress1: json['shipping_address_1'] as String?,
      shippingAddress2: json['shipping_address_2'] as String?,
      city: json['shipping_city'] as String?,
      states: json['shipping_state'] as String?,
      country: json['shipping_country'] as String?,
      pincode: json['shipping_pin_code'] as String?,
    );

Map<String, dynamic> _$$SalesOrderFormImplToJson(
  _$SalesOrderFormImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'company': instance.plantName,
  'address_display': instance.addressDisplay,
  'customer_name': instance.customerName,
  'customers_purchase_order': instance.customerPurchaseOrder,
  'order_date': instance.orderDate,
  'shipping_address_1': instance.shippingAddress1,
  'shipping_address_2': instance.shippingAddress2,
  'shipping_city': instance.city,
  'shipping_state': instance.states,
  'shipping_country': instance.country,
  'shipping_pin_code': instance.pincode,
};
