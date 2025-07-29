import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_form.freezed.dart';
part 'registration_form.g.dart';

@freezed
class RegistrationForm with _$RegistrationForm {
  const RegistrationForm._();
  const factory RegistrationForm({
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'mobile') String? mobileNumber,
    String? email,
    String? password,
    @JsonKey(includeToJson: true) String? cnfPswd,
  }) = _RegistrationForm;

  factory RegistrationForm.fromJson(Map<String, dynamic> json) =>
      _$RegistrationFormFromJson(json);
}
