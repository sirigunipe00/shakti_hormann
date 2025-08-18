import 'package:freezed_annotation/freezed_annotation.dart';
part 'gate_exit_form.freezed.dart';
part 'gate_exit_form.g.dart';

@freezed
class GateExitForm with _$GateExitForm {
  const factory GateExitForm({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation', defaultValue: '') String? creationDate,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'modified') String? modifiedDate,
    @JsonKey(name: 'modified_by') String? modifiedBy,

    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'plant_name') String? plantName,

    @JsonKey(name: 'sales_invoice') String? salesInvoice,

    @JsonKey(name: 'vehicle_no') String? vehicleNo,

    @JsonKey(name: 'vehicle_photo') String? vehiclePhoto,
    

    @JsonKey(name: 'gate_entry_date') String? gateEntryDate,
     
    @JsonKey(name: 'vehicle_back_photo') String? vehicleBackPhoto,

    @JsonKey(name: 'remarks') String? remarks,

    @JsonKey(name: 'amended_from') String? amendedFrom,
  }) = _GateExitForm;
  factory GateExitForm.fromJson(Map<String, dynamic> json) =>
      _$GateExitFormFromJson(json);
}
