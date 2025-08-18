
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_order_form.freezed.dart';
part 'sales_order_form.g.dart';

@freezed
class SalesOrderForm with _$SalesOrderForm {
  const factory SalesOrderForm({
    @JsonKey(name:'name')  String? name,
    @JsonKey(name:'company') String? plantName,
    @JsonKey(name:'address_display')  String? addressDisplay,
    


  }) = _SalesOrderForm;
factory SalesOrderForm.fromJson(Map<String, dynamic> json) => _$SalesOrderFormFromJson(json);
}