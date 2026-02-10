

import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachement.freezed.dart';
part 'attachement.g.dart';

@freezed
class AttachementInvoices with _$AttachementInvoices {
  const factory AttachementInvoices({
    @JsonKey(name: 'file_url') String? fileUrl,
    @JsonKey(name: 'attached_to_doctype') String? attchedDocumentType,
    @JsonKey(name: 'attached_to_name') String? attchedName, 
    @JsonKey(name: 'attached_to_field') String? attchedField,
  }) = _AttachementInvoices;
factory AttachementInvoices.fromJson(Map<String, dynamic> json) => _$AttachementInvoicesFromJson(json);
}