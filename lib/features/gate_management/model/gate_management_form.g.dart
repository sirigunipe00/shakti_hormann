// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gate_management_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GateManagementFormImpl _$$GateManagementFormImplFromJson(
  Map<String, dynamic> json,
) => _$GateManagementFormImpl(
  status: json['status'] as String?,
  name: json['name'] as String?,
  docStatus: (json['docstatus'] as num?)?.toInt(),
  owner: json['owner'] as String?,
  modifiedBy: json['creation'] as String?,
  plantName: json['plant_name'] as String?,
  gateeEntrydate: json['gate_entry_date'] as String?,
  gateEntryTime: json['gate_entry_time'] as String?,
  remarks: json['purpose__remarks'] as String?,
  vehicleNo: json['vehicle_no'] as String?,
  vehicleType: json['vehicle_type'] as String?,
  vendorInvoiceNo: json['vendor_invoice_no'] as String?,
  driverName: json['driver_name'] as String?,
  driverMobileNo: json['driver_mobile'] as String?,
  vendorName: json['company__vendor_name'] as String?,
  securityRemarks: json['security_remarks'] as String?,
  vehiclePhoto: json['vehicle_photo'] as String?,
  backPhoto: json['vehicle_back_photo'] as String?,
  gateExitdate: json['gate_exit_date'] as String?,
  gateExitTime: json['gate_exit_time'] as String?,
  invoicePhotos: _stringOrListToStringList(json['document_photos']),
  requestType:
      (_extractRequestTypes(json, 'requestType') as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  vehiclePhotoImg: toNull(json['vehiclePhotoImg']),
  backPhotoImg: toNull(json['backPhotoImg']),
  documentPhotoImg: toNull(json['documentPhotoImg']),
);

Map<String, dynamic> _$$GateManagementFormImplToJson(
  _$GateManagementFormImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'name': instance.name,
  'docstatus': instance.docStatus,
  'owner': instance.owner,
  'creation': instance.modifiedBy,
  'plant_name': instance.plantName,
  'gate_entry_date': instance.gateeEntrydate,
  'gate_entry_time': instance.gateEntryTime,
  'purpose__remarks': instance.remarks,
  'vehicle_no': instance.vehicleNo,
  'vehicle_type': instance.vehicleType,
  'vendor_invoice_no': instance.vendorInvoiceNo,
  'driver_name': instance.driverName,
  'driver_mobile': instance.driverMobileNo,
  'company__vendor_name': instance.vendorName,
  'security_remarks': instance.securityRemarks,
  'vehicle_photo': instance.vehiclePhoto,
  'vehicle_back_photo': instance.backPhoto,
  'gate_exit_date': instance.gateExitdate,
  'gate_exit_time': instance.gateExitTime,
  'document_photos': instance.invoicePhotos,
  'requestType': instance.requestType,
};
