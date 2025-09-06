// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logistic_planning_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LogisticPlanningFormImpl _$$LogisticPlanningFormImplFromJson(
  Map<String, dynamic> json,
) => _$LogisticPlanningFormImpl(
  name: json['name'] as String,
  owner: json['owner'] as String?,
  creation: json['creation'] as String? ?? '',
  modified: json['modified'] as String?,
  modifiedBy: json['modified_by'] as String?,
  docstatus: (json['docstatus'] as num?)?.toInt(),
  idx: (json['idx'] as num?)?.toInt(),
  amendedFrom: json['amended_from'] as String?,
  plantName: json['plant_name'] as String?,
  salesOrder:
      (json['sales_orders'] as List<dynamic>?)
          ?.map((e) => SalesOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
  transporterName: json['transporter_name'] as String?,
  preferredVehicleType: json['preferred_vehicle_type'] as String?,
  deliveryAddress: json['delivery_address'] as String?,
  status: json['status'] as String?,
  logisticsRequestDate: json['logistics_request_date'] as String? ?? '',
  requestedDeliveryDate: json['requested_delivery_date'] as String? ?? '',
  shippingAddress1: json['delivery_address_1'] as String?,
  shippingAddress2: json['delivery_address_2'] as String?,
  city: json['shipping_city'] as String?,
  states: json['shipping_state'] as String?,
  country: json['shipping_country'] as String?,
  pincode: json['shipping_pin_code'] as String?,
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

Map<String, dynamic> _$$LogisticPlanningFormImplToJson(
  _$LogisticPlanningFormImpl instance,
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
  'sales_orders': instance.salesOrder,
  'transporter_name': instance.transporterName,
  'preferred_vehicle_type': instance.preferredVehicleType,
  'delivery_address': instance.deliveryAddress,
  'status': instance.status,
  'logistics_request_date': instance.logisticsRequestDate,
  'requested_delivery_date': instance.requestedDeliveryDate,
  'delivery_address_1': instance.shippingAddress1,
  'delivery_address_2': instance.shippingAddress2,
  'shipping_city': instance.city,
  'shipping_state': instance.states,
  'shipping_country': instance.country,
  'shipping_pin_code': instance.pincode,
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
