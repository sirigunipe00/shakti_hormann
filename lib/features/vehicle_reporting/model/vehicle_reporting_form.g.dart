// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_reporting_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleReportingFormImpl _$$VehicleReportingFormImplFromJson(
  Map<String, dynamic> json,
) => _$VehicleReportingFormImpl(
  name: json['name'] as String?,
  owner: json['owner'] as String?,
  creation: json['creation'] as String? ?? '',
  modified: json['modified'] as String? ?? '',
  modifiedBy: json['modified_by'] as String?,
  docstatus: (json['docstatus'] as num?)?.toInt(),
  idx: (json['idx'] as num?)?.toInt(),
  amendedFrom: json['amended_from'] as String?,
  plantName: json['plant_name'] as String?,
  vehicleReportingEntryVreDate:
      json['vehicle_reporting_entry_vre_date'] as String?,
  transporterName: json['transporter_name'] as String?,
  arrivalDateAndTime: json['arrival_date_and__time'] as String? ?? '',
  driverIdPhoto: json['driver_id_proof'] as String?,
  loadedByUser: json['loaded_by_user'] as String?,
  status: json['status'] as String?,
  linkedTransporterConfirmation:
      json['linked_transporter_confirmation'] as String?,
  vehicleNumber: json['vehicle_number'] as String?,
  driverContact: json['driver_contact'] as String?,
  remarks: json['remarks'] as String?,
);

Map<String, dynamic> _$$VehicleReportingFormImplToJson(
  _$VehicleReportingFormImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'owner': instance.owner,
  'creation': instance.creation,
  'modified': instance.modified,
  'modified_by': instance.modifiedBy,
  'docstatus': instance.docstatus,
  'idx': instance.idx,
  'amended_from': instance.amendedFrom,
  'plant_name': instance.plantName,
  'vehicle_reporting_entry_vre_date': instance.vehicleReportingEntryVreDate,
  'transporter_name': instance.transporterName,
  'arrival_date_and__time': instance.arrivalDateAndTime,
  'driver_id_proof': instance.driverIdPhoto,
  'loaded_by_user': instance.loadedByUser,
  'status': instance.status,
  'linked_transporter_confirmation': instance.linkedTransporterConfirmation,
  'vehicle_number': instance.vehicleNumber,
  'driver_contact': instance.driverContact,
  'remarks': instance.remarks,
};
