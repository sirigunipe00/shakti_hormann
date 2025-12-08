

import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';

part 'gate_management_form.freezed.dart';
part 'gate_management_form.g.dart';

@freezed
class GateManagementForm with _$GateManagementForm {
  const factory GateManagementForm({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? modifiedBy,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'request_type') String? requestType,
    @JsonKey(name: 'gate_entry_date') String? gateeEntrydate,
    @JsonKey(name: 'gate_entry_time') String? gateEntryTime,
    @JsonKey(name: 'purpose__remarks') String? remarks,
    @JsonKey(name: 'vehicle_no') String? vehicleNo,
    @JsonKey(name: 'vehicle_type') String? vehicleType,
    @JsonKey(name: 'vendor_invoice_no') String? vendorInvoiceNo,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'driver_mobile') String? driverMobileNo,
    @JsonKey(name: 'company__vendor_name') String? vendorName,
    @JsonKey(name: 'security_remarks') String? securityRemarks,
    @JsonKey(name: 'vehicle_photo') String? vehiclePhoto,
    @JsonKey(name: 'vehicle_back_photo') String? backPhoto,
    @JsonKey(name: 'gate_exit_date') String? gateExitdate,
    @JsonKey(name: 'gate_exit_time') String? gateExitTime,
    @JsonKey(name: 'document_photos') String? documentPhoto,

     @JsonKey(
        includeFromJson: true,
        includeToJson: false,
        toJson: toNull,
        fromJson: toNull)
    File? vehiclePhotoImg,
    @JsonKey(
        includeFromJson: true,
        includeToJson: false,
        toJson: toNull,
        fromJson: toNull)
    File? backPhotoImg,
     @JsonKey(
        includeFromJson: true,
        includeToJson: false,
        toJson: toNull,
        fromJson: toNull)
    File? documentPhotoImg,
    }) = _GateManagementForm;
factory GateManagementForm.fromJson(Map<String, dynamic> json) => _$GateManagementFormFromJson(json);
}