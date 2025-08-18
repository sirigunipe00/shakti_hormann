import 'package:freezed_annotation/freezed_annotation.dart';

part 'transporter_form.freezed.dart';
part 'transporter_form.g.dart';

@freezed
class TransportersForm with _$TransportersForm {
  const factory TransportersForm({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'supplier_name') String? suppliername,
    @JsonKey(name: 'supplier_type') String? supplierType,
    @JsonKey(name: 'is_transporter') int? isTransporter,
  }) = _TransportersForm;
  factory TransportersForm.fromJson(Map<String, dynamic> json) =>
      _$TransportersFormFromJson(json);

      static List<String> fields = ['name'];
          
}
