import 'package:freezed_annotation/freezed_annotation.dart';

part 'logistic_planning_form.freezed.dart';
part 'logistic_planning_form.g.dart';

@freezed
class LogisticPlanningForm with _$LogisticPlanningForm {
  const factory LogisticPlanningForm({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation', defaultValue: '') String? creation,
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
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'logistics_request_date', defaultValue: '')
    String? logisticsRequestDate,
    @JsonKey(name: 'requested_delivery_date', defaultValue: '')
    String? requestedDeliveryDate,
    @JsonKey(name: 'requested_delivery_time') String? requestedDeliveryTime,
    @JsonKey(name: 'any_special_instructions') String? anySpecialInstructions,
    @JsonKey(name: 'transporter_confirmation_date')
    String? transporterConfirmationDate,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'estimated_arrival') String? estimatedArrival,
    @JsonKey(name: 'transporter_remarks') String? transporterRemarks,
    @JsonKey(name: 'vehicle_number') String? vehicleNumber,
    @JsonKey(name: 'driver_contact') String? driverContact,
    @JsonKey(name: 'reject_reason') String? rejectReason,
    String? state,
    String? zipcode,
  }) = _LogisticPlanningForm;

  factory LogisticPlanningForm.fromJson(Map<String, dynamic> json) =>
      _$LogisticPlanningFormFromJson(json);
}
