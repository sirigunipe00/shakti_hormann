
import 'package:freezed_annotation/freezed_annotation.dart';


part 'gate_entry_form.freezed.dart';
part 'gate_entry_form.g.dart';

@freezed
class GateEntryForm with _$GateEntryForm {
  const factory GateEntryForm({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation',defaultValue: '') String? creationDate,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'modified') String? modifiedDate,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'purchase_order') String? purchaseOrder,
    @JsonKey(name: 'scan_irn') String? scanIrn,
    @JsonKey(name: 'vehicle_no') String? vehicleNo,
    @JsonKey(name: 'vendor_invoice_date')
    String? vendorInvoiceDate,
    @JsonKey(name: 'vendor_invoice_no')
    String? vendorInvoiceNo,
    @JsonKey(name: 'gate_entry_date') String? gateEntryDate,
    @JsonKey(name: 'invoice_qty') int? invoiceQuantity,
    @JsonKey(name: 'invoice_amount') int? invoiceAmount,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'is_purchase_receipt_created') int? receipt,
    @JsonKey(name: 'vehicle_photo') String? vehiclePhoto,
    @JsonKey(name: 'vendor_invoice_photo') String? invoicePhoto,
    @JsonKey(name: 'vehicle_back_photo') String? vehicleBackPhoto,
  }) = _GateEntryForm;
  factory GateEntryForm.fromJson(Map<String, dynamic> json) =>
      _$GateEntryFormFromJson(json);
}
