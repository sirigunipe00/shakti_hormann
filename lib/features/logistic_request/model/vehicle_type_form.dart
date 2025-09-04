
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_type_form.freezed.dart';
part 'vehicle_type_form.g.dart';

@freezed
class VehicleTypeForm with _$VehicleTypeForm {
  const factory VehicleTypeForm({
    @JsonKey(name: 'vehicle') String? vehicle,
    @JsonKey(name: 'name') String? name,
  }) = _VehicleTypeForm;
factory VehicleTypeForm.fromJson(Map<String, dynamic> json) => _$VehicleTypeFormFromJson(json);
}