import 'package:freezed_annotation/freezed_annotation.dart';

part 'receiver_name_form.freezed.dart';
part 'receiver_name_form.g.dart';

@freezed
class ReceiverNameForm with _$ReceiverNameForm {
  factory ReceiverNameForm({
    String? gstin,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'customer_name') required String custName,
  }) = _ReceiverNameForm;

  factory ReceiverNameForm.fromJson(Map<String, Object?> json) =>
      _$ReceiverNameFormFromJson(json);

  static List<String> fields = ['name'];
}
