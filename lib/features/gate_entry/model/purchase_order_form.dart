
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_order_form.freezed.dart';
part 'purchase_order_form.g.dart';

@freezed
class PurchaseOrderForm with _$PurchaseOrderForm {
  const factory PurchaseOrderForm({
      @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'company') String? plantName,
    @JsonKey(name:'supplier') String? supplier,
    @JsonKey(name: 'custom_remarks') String? remarks,
  }) = _PurchaseOrderForm;
factory PurchaseOrderForm.fromJson(Map<String, dynamic> json) => _$PurchaseOrderFormFromJson(json);
}