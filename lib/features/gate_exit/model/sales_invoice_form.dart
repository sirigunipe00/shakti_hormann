import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_invoice_form.freezed.dart';
part 'sales_invoice_form.g.dart';

@freezed
class SalesInvoiceForm with _$SalesInvoiceForm {
  const factory SalesInvoiceForm({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'company') String? plantName,
    @JsonKey(name: 'posting_date', defaultValue: '') String? postingDate,
    @JsonKey(name: 'vehicle_no', defaultValue: '') String? vehicleNo,
    @JsonKey(name: 'remarks') String? remarks,
  }) = _SalesInvoiceForm;
  factory SalesInvoiceForm.fromJson(Map<String, dynamic> json) =>
      _$SalesInvoiceFormFromJson(json);
}
