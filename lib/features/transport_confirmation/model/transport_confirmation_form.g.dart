// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_confirmation_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransportConfirmationFormImpl _$$TransportConfirmationFormImplFromJson(
  Map<String, dynamic> json,
) => _$TransportConfirmationFormImpl(
  name: json['name'] as String,
  owner: json['owner'] as String?,
  creation: json['creation'] as String? ?? '',
  modified: json['modified'] as String?,
  modifiedBy: json['modified_by'] as String?,
  docstatus: (json['docstatus'] as num?)?.toInt(),
  idx: (json['idx'] as num?)?.toInt(),
  amendedFrom: json['amended_from'] as String?,
  plantName: json['plant_name'] as String?,
  salesOrder: json['sales_order'] as String?,
  transporterName: json['transporter_name'] as String?,
  preferredVehicleType: json['preferred_vehicle_type'] as String?,
  deliveryAddress: json['delivery_address'] as String?,
  status: json['status'] as String?,
  logisticsRequestDate: json['logistics_request_date'] as String? ?? '',
  requestedDeliveryDate: json['requested_delivery_date'] as String? ?? '',
  requestedDeliveryTime: json['requested_delivery_time'] as String?,
  anySpecialInstructions: json['any_special_instructions'] as String?,
  transporterConfirmationDate: json['transporter_confirmation_date'] as String?,
  driverName: json['driver_name'] as String?,
  estimatedArrival: json['estimated_arrival'] as String?,
  transporterRemarks: json['transporter_remarks'] as String?,
  vehicleNumber: json['vehicle_number'] as String?,
  driverContact: json['driver_contact'] as String?,
  rejectReason: json['reject_reason'] as String?,
);

Map<String, dynamic> _$$TransportConfirmationFormImplToJson(
  _$TransportConfirmationFormImpl instance,
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
  'sales_order': instance.salesOrder,
  'transporter_name': instance.transporterName,
  'preferred_vehicle_type': instance.preferredVehicleType,
  'delivery_address': instance.deliveryAddress,
  'status': instance.status,
  'logistics_request_date': instance.logisticsRequestDate,
  'requested_delivery_date': instance.requestedDeliveryDate,
  'requested_delivery_time': instance.requestedDeliveryTime,
  'any_special_instructions': instance.anySpecialInstructions,
  'transporter_confirmation_date': instance.transporterConfirmationDate,
  'driver_name': instance.driverName,
  'estimated_arrival': instance.estimatedArrival,
  'transporter_remarks': instance.transporterRemarks,
  'vehicle_number': instance.vehicleNumber,
  'driver_contact': instance.driverContact,
  'reject_reason': instance.rejectReason,
};
