
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_order_form.freezed.dart';
part 'sales_order_form.g.dart';

@freezed
class SalesOrderForm with _$SalesOrderForm {
  const factory SalesOrderForm({
    @JsonKey(name:'name')  String? name,
    @JsonKey(name:'company') String? plantName,
    @JsonKey(name:'address_display')  String? addressDisplay,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name:'customers_purchase_order') String? customerPurchaseOrder,
    @JsonKey(name: 'order_date') String? orderDate,
    @JsonKey(name:'shipping_address_1') String? shippingAddress1,
    @JsonKey(name:'shipping_address_2') String? shippingAddress2,
    @JsonKey(name: 'shipping_city') String? city,
    @JsonKey(name:'shipping_state') String? states,
    @JsonKey(name:'shipping_country') String? country,
    @JsonKey(name:'shipping_pin_code') String? pincode,
  }) = _SalesOrderForm;
factory SalesOrderForm.fromJson(Map<String, dynamic> json) => _$SalesOrderFormFromJson(json);
}