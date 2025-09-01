import 'package:freezed_annotation/freezed_annotation.dart';

part 'transport_confirmation_form.freezed.dart';
part 'transport_confirmation_form.g.dart';

@freezed
class TransportConfirmationForm with _$TransportConfirmationForm {
  const factory TransportConfirmationForm({
    @JsonKey(name: 'name')  String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation',defaultValue: '') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docstatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'amended_from') String? amendedFrom,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'sales_order') String? salesOrder,
    @JsonKey(name: 'transporter_name') String? transporterName,
    @JsonKey(name: 'preferred_vehicle_type') String? preferredVehicleType,
    @JsonKey(name: 'delivery_address') String? deliveryAddress,
    @JsonKey(name:'delivery_address_1') String? shippingAddress1,
    @JsonKey(name:'delivery_address_2') String? shippingAddress2,
    @JsonKey(name: 'shipping_city') String? city,
    @JsonKey(name:'shipping_state') String? states,
    @JsonKey(name:'shipping_country') String? country,
    @JsonKey(name:'shipping_pin_code') String? pincode,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'logistics_request_date',defaultValue: '') String? logisticsRequestDate,
    @JsonKey(name: 'requested_delivery_date',defaultValue: '') String? requestedDeliveryDate,
    @JsonKey(name: 'requested_delivery_time') String? requestedDeliveryTime,
    @JsonKey(name: 'any_special_instructions') String? anySpecialInstructions,
    @JsonKey(name: 'transporter_confirmation_date') String? transporterConfirmationDate,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'estimated_arrival') String? estimatedArrival,
    @JsonKey(name: 'transporter_remarks') String? transporterRemarks,
    @JsonKey(name: 'vehicle_number') String? vehicleNumber,
    @JsonKey(name: 'driver_contact') String? driverContact,
    @JsonKey(name: 'reject_reason') String? rejectReason,

  }) = _TransportConfirmationForm;

  factory TransportConfirmationForm.fromJson(Map<String, dynamic> json) =>
      _$TransportConfirmationFormFromJson(json);
}
