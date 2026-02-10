// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachementInvoicesImpl _$$AttachementInvoicesImplFromJson(
  Map<String, dynamic> json,
) => _$AttachementInvoicesImpl(
  fileUrl: json['file_url'] as String?,
  attchedDocumentType: json['attached_to_doctype'] as String?,
  attchedName: json['attached_to_name'] as String?,
  attchedField: json['attached_to_field'] as String?,
);

Map<String, dynamic> _$$AttachementInvoicesImplToJson(
  _$AttachementInvoicesImpl instance,
) => <String, dynamic>{
  'file_url': instance.fileUrl,
  'attached_to_doctype': instance.attchedDocumentType,
  'attached_to_name': instance.attchedName,
  'attached_to_field': instance.attchedField,
};
