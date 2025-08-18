// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gate_entry_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GateEntryFormImpl _$$GateEntryFormImplFromJson(Map<String, dynamic> json) =>
    _$GateEntryFormImpl(
      status: json['status'] as String?,
      name: json['name'] as String?,
      owner: json['owner'] as String?,
      creationDate: json['creation'] as String? ?? '',
      docStatus: (json['docstatus'] as num?)?.toInt(),
      modifiedDate: json['modified'] as String?,
      modifiedBy: json['modified_by'] as String?,
      idx: (json['idx'] as num?)?.toInt(),
      plantName: json['plant_name'] as String?,
      purchaseOrder: json['purchase_order'] as String?,
      scanIrn: json['scan_irn'] as String?,
      vehicleNo: json['vehicle_no'] as String?,
      vendorInvoiceDate: json['vendor_invoice_date'] as String?,
      vendorInvoiceNo: json['vendor_invoice_no'] as String?,
      gateEntryDate: json['gate_entry_date'] as String?,
      invoiceQuantity: (json['invoice_qty'] as num?)?.toInt(),
      invoiceAmount: (json['invoice_amount'] as num?)?.toInt(),
      remarks: json['remarks'] as String?,
      receipt: (json['is_purchase_receipt_created'] as num?)?.toInt(),
      vehiclePhoto: json['vehicle_photo'] as String?,
      invoicePhoto: json['vendor_invoice_photo'] as String?,
      vehicleBackPhoto: json['vehicle_back_photo'] as String?,
    );

Map<String, dynamic> _$$GateEntryFormImplToJson(_$GateEntryFormImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'name': instance.name,
      'owner': instance.owner,
      'creation': instance.creationDate,
      'docstatus': instance.docStatus,
      'modified': instance.modifiedDate,
      'modified_by': instance.modifiedBy,
      'idx': instance.idx,
      'plant_name': instance.plantName,
      'purchase_order': instance.purchaseOrder,
      'scan_irn': instance.scanIrn,
      'vehicle_no': instance.vehicleNo,
      'vendor_invoice_date': instance.vendorInvoiceDate,
      'vendor_invoice_no': instance.vendorInvoiceNo,
      'gate_entry_date': instance.gateEntryDate,
      'invoice_qty': instance.invoiceQuantity,
      'invoice_amount': instance.invoiceAmount,
      'remarks': instance.remarks,
      'is_purchase_receipt_created': instance.receipt,
      'vehicle_photo': instance.vehiclePhoto,
      'vendor_invoice_photo': instance.invoicePhoto,
      'vehicle_back_photo': instance.vehicleBackPhoto,
    };
