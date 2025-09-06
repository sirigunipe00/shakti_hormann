
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_order.freezed.dart';
part 'purchase_order.g.dart';

@freezed
class PurchaseOrder with _$PurchaseOrder {
  const factory PurchaseOrder({
    @JsonKey(name : 'purchase_order') String? name,
  }) = _PurchaseOrder;
factory PurchaseOrder.fromJson(Map<String, dynamic> json) => _$PurchaseOrderFromJson(json);
}