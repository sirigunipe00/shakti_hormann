// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loading_cnfm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoadingCnfmFormImpl _$$LoadingCnfmFormImplFromJson(
  Map<String, dynamic> json,
) => _$LoadingCnfmFormImpl(
  name: json['name'] as String?,
  owner: json['owner'] as String?,
  creation: json['creation'] as String? ?? '',
  modified: json['modified'] as String? ?? '',
  modifiedBy: json['modified_by'] as String?,
  docstatus: (json['docstatus'] as num?)?.toInt(),
  idx: (json['idx'] as num?)?.toInt(),
  loadingStatus: json['dispatch_loading_status'] as String?,
  amendedFrom: json['amended_from'] as String?,
  plantName: json['plant_name'] as String?,
  vehicleReportingEntryVreDate:
      json['vehicle_reporting_entry_vre_date'] as String?,
  transporterName: json['transporter_name'] as String?,
  transporterName2: json['transporter_name2'] as String?,
  arrivalDate: json['arrival_date'] as String? ?? '',
  arrivalTime: json['arrival_time'] as String? ?? '',
  arrivalDateAndTime: json['arrivalDateAndTime'] as String?,
  driverIdPhoto: json['driver_id_proof'] as String?,
  loadedByUser: json['loaded_by_user'] as String?,
  status: json['status'] as String?,
  linkedTransporterConfirmation:
      json['linked_transporter_confirmation'] as String?,
  vehicleNumber: json['vehicle_number'] as String?,
  driverContact: json['driver_contact'] as String?,
  remarks: json['remarks'] as String?,
);

Map<String, dynamic> _$$LoadingCnfmFormImplToJson(
  _$LoadingCnfmFormImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'owner': instance.owner,
  'creation': instance.creation,
  'modified': instance.modified,
  'modified_by': instance.modifiedBy,
  'docstatus': instance.docstatus,
  'idx': instance.idx,
  'dispatch_loading_status': instance.loadingStatus,
  'amended_from': instance.amendedFrom,
  'plant_name': instance.plantName,
  'vehicle_reporting_entry_vre_date': instance.vehicleReportingEntryVreDate,
  'transporter_name': instance.transporterName,
  'transporter_name2': instance.transporterName2,
  'arrival_date': instance.arrivalDate,
  'arrival_time': instance.arrivalTime,
  'arrivalDateAndTime': instance.arrivalDateAndTime,
  'driver_id_proof': instance.driverIdPhoto,
  'loaded_by_user': instance.loadedByUser,
  'status': instance.status,
  'linked_transporter_confirmation': instance.linkedTransporterConfirmation,
  'vehicle_number': instance.vehicleNumber,
  'driver_contact': instance.driverContact,
  'remarks': instance.remarks,
};
