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
    // @JsonKey(name: 'request_type') List<String>? requestType,
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
    // @JsonKey(name: 'document_photos') String? documentPhoto,
     @JsonKey(
      name: 'document_photos',
      fromJson: _stringOrListToStringList,
    )
    List<String>? invoicePhotos,
    @JsonKey(readValue: _extractRequestTypes) 
    List<String>? requestType,

    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? vehiclePhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? backPhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    List<File>? documentPhotoImg,
  }) = _GateManagementForm;
  factory GateManagementForm.fromJson(Map<String, dynamic> json) =>
      _$GateManagementFormFromJson(json);
}

Object? _extractRequestTypes(Map json, String key) {
  final List<String> selected = [];

  // Map: "JSON_KEY": "UI_LABEL"
  const typeMapping = {
    'purchase_return_invoice': 'Purchase Return Invoice',
    'amazon': 'Amazon',
    'canteen_vehicle': 'Canteen Vehicle',
    'courier_vehicle': 'Courier Vehicle',
    'dc_vehicle': 'DC Vehicle',
    'internal_memo': 'Internal Memo',
    'swiggy': 'Swiggy',
    'jai_adithya_fabrication_and_jobworks': 'Jai Adithya Fabrication&Jobworks',
    'non_returnable_gate_pass': 'Non- Returnable Gate Pass',
    'returnable_gate_pass': 'Returnable Gate Pass',
    'others_remarks': 'Others (Remarks)',
  };

  typeMapping.forEach((apiKey, uiLabel) {
    if (json[apiKey] == 1) {
      selected.add(uiLabel);
    }
  });

  return selected.isEmpty ? null : selected;
}
List<String>? _stringOrListToStringList(dynamic value) {
  if (value == null) return null;

  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }

  if (value is String && value.isNotEmpty) {
    return [value];
  }

  return [];
}