
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gate_number_form.freezed.dart';
part 'gate_number_form.g.dart';

@freezed
class GateNumberForm with _$GateNumberForm {
  const factory GateNumberForm({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name : 'unloading_point_name' ) String? pointName,
  }) = _GateNumberForm;
factory GateNumberForm.fromJson(Map<String, dynamic> json) => _$GateNumberFormFromJson(json);
}