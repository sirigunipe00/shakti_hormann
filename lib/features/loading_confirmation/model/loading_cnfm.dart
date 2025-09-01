import 'package:freezed_annotation/freezed_annotation.dart';
part 'loading_cnfm.freezed.dart';
part 'loading_cnfm.g.dart';

@freezed
class LoadingCnfmForm with _$LoadingCnfmForm {
  const factory LoadingCnfmForm({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation', defaultValue: '') String? creation,
    @JsonKey(name: 'modified', defaultValue: '') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docstatus,
    @JsonKey(name: 'idx') int? idx,

    @JsonKey(name: 'amended_from') String? amendedFrom,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'vehicle_reporting_entry_vre_date')
    String? vehicleReportingEntryVreDate,
    @JsonKey(name: 'transporter_name') String? transporterName,
    @JsonKey(name: 'arrival_date_and__time', defaultValue: '')
    String? arrivalDateAndTime,
    @JsonKey(name: 'driver_id_proof') String? driverIdPhoto,
    @JsonKey(name: 'loaded_by_user') String? loadedByUser,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'linked_transporter_confirmation')
    String? linkedTransporterConfirmation,
    @JsonKey(name: 'vehicle_number') String? vehicleNumber,
    @JsonKey(name: 'driver_contact') String? driverContact,
    @JsonKey(name: 'remarks') String? remarks,
  }) = _LoadingCnfmForm;
  factory LoadingCnfmForm.fromJson(Map<String, dynamic> json) =>
      _$LoadingCnfmFormFromJson(json);
}
