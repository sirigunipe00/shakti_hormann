// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gate_exit_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GateExitFormImpl _$$GateExitFormImplFromJson(Map<String, dynamic> json) =>
    _$GateExitFormImpl(
      status: json['status'] as String?,
      name: json['name'] as String?,
      owner: json['owner'] as String?,
      creationDate: json['creation'] as String? ?? '',
      docStatus: (json['docstatus'] as num?)?.toInt(),
      modifiedDate: json['modified'] as String?,
      modifiedBy: json['modified_by'] as String?,
      idx: (json['idx'] as num?)?.toInt(),
      plantName: json['plant_name'] as String?,
      salesInvoices:
          (json['sales_invoices'] as List<dynamic>?)
              ?.map((e) => SalesInvoice.fromJson(e as Map<String, dynamic>))
              .toList(),
      vehicleNo: json['vehicle_no'] as String?,
      vehiclePhoto: json['vehicle_photo'] as String?,
      gateEntryDate: json['gate_entry_date'] as String?,
      vehicleBackPhoto: json['vehicle_back_photo'] as String?,
      remarks: json['remarks'] as String?,
      amendedFrom: json['amended_from'] as String?,
      vehiclePhotoImg: toNull(json['vehiclePhotoImg']),
      vehicleBackPhotoImg: toNull(json['vehicleBackPhotoImg']),
    );

Map<String, dynamic> _$$GateExitFormImplToJson(_$GateExitFormImpl instance) =>
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
      'sales_invoices': instance.salesInvoices,
      'vehicle_no': instance.vehicleNo,
      'vehicle_photo': instance.vehiclePhoto,
      'gate_entry_date': instance.gateEntryDate,
      'vehicle_back_photo': instance.vehicleBackPhoto,
      'remarks': instance.remarks,
      'amended_from': instance.amendedFrom,
    };
