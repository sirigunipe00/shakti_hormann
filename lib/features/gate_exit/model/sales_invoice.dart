

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_invoice.freezed.dart';
part 'sales_invoice.g.dart';

@freezed
class SalesInvoice with _$SalesInvoice {
  const factory SalesInvoice({
    @JsonKey(name : 'sales_invoice') String? name,
  }) = _SalesInvoice;
factory SalesInvoice.fromJson(Map<String, dynamic> json) => _$SalesInvoiceFromJson(json);
}