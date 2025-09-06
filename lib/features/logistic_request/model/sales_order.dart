
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_order.freezed.dart';
part 'sales_order.g.dart';

@freezed
class SalesOrder with _$SalesOrder {
  const factory SalesOrder({
    @JsonKey(name : 'sales_order') String? name
  }) = _SalesOrder;
factory SalesOrder.fromJson(Map<String, dynamic> json) => _$SalesOrderFromJson(json);
}