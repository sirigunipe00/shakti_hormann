import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_form.freezed.dart';
part 'company_form.g.dart';

@freezed
class CompanyForm with _$CompanyForm {
  const factory CompanyForm({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'company_name')  String? companyName,
    @JsonKey(name: 'custom_company_type') String? companyType,
  }) = _CompanyForm;

  factory CompanyForm.fromJson(Map<String, dynamic> json) =>
      _$CompanyFormFromJson(json);
}
