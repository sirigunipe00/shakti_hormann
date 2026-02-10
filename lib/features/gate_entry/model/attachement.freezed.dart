// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AttachementInvoices _$AttachementInvoicesFromJson(Map<String, dynamic> json) {
  return _AttachementInvoices.fromJson(json);
}

/// @nodoc
mixin _$AttachementInvoices {
  @JsonKey(name: 'file_url')
  String? get fileUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'attached_to_doctype')
  String? get attchedDocumentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'attached_to_name')
  String? get attchedName => throw _privateConstructorUsedError;
  @JsonKey(name: 'attached_to_field')
  String? get attchedField => throw _privateConstructorUsedError;

  /// Serializes this AttachementInvoices to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttachementInvoices
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttachementInvoicesCopyWith<AttachementInvoices> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachementInvoicesCopyWith<$Res> {
  factory $AttachementInvoicesCopyWith(
    AttachementInvoices value,
    $Res Function(AttachementInvoices) then,
  ) = _$AttachementInvoicesCopyWithImpl<$Res, AttachementInvoices>;
  @useResult
  $Res call({
    @JsonKey(name: 'file_url') String? fileUrl,
    @JsonKey(name: 'attached_to_doctype') String? attchedDocumentType,
    @JsonKey(name: 'attached_to_name') String? attchedName,
    @JsonKey(name: 'attached_to_field') String? attchedField,
  });
}

/// @nodoc
class _$AttachementInvoicesCopyWithImpl<$Res, $Val extends AttachementInvoices>
    implements $AttachementInvoicesCopyWith<$Res> {
  _$AttachementInvoicesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttachementInvoices
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileUrl = freezed,
    Object? attchedDocumentType = freezed,
    Object? attchedName = freezed,
    Object? attchedField = freezed,
  }) {
    return _then(
      _value.copyWith(
            fileUrl:
                freezed == fileUrl
                    ? _value.fileUrl
                    : fileUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            attchedDocumentType:
                freezed == attchedDocumentType
                    ? _value.attchedDocumentType
                    : attchedDocumentType // ignore: cast_nullable_to_non_nullable
                        as String?,
            attchedName:
                freezed == attchedName
                    ? _value.attchedName
                    : attchedName // ignore: cast_nullable_to_non_nullable
                        as String?,
            attchedField:
                freezed == attchedField
                    ? _value.attchedField
                    : attchedField // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttachementInvoicesImplCopyWith<$Res>
    implements $AttachementInvoicesCopyWith<$Res> {
  factory _$$AttachementInvoicesImplCopyWith(
    _$AttachementInvoicesImpl value,
    $Res Function(_$AttachementInvoicesImpl) then,
  ) = __$$AttachementInvoicesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'file_url') String? fileUrl,
    @JsonKey(name: 'attached_to_doctype') String? attchedDocumentType,
    @JsonKey(name: 'attached_to_name') String? attchedName,
    @JsonKey(name: 'attached_to_field') String? attchedField,
  });
}

/// @nodoc
class __$$AttachementInvoicesImplCopyWithImpl<$Res>
    extends _$AttachementInvoicesCopyWithImpl<$Res, _$AttachementInvoicesImpl>
    implements _$$AttachementInvoicesImplCopyWith<$Res> {
  __$$AttachementInvoicesImplCopyWithImpl(
    _$AttachementInvoicesImpl _value,
    $Res Function(_$AttachementInvoicesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttachementInvoices
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileUrl = freezed,
    Object? attchedDocumentType = freezed,
    Object? attchedName = freezed,
    Object? attchedField = freezed,
  }) {
    return _then(
      _$AttachementInvoicesImpl(
        fileUrl:
            freezed == fileUrl
                ? _value.fileUrl
                : fileUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        attchedDocumentType:
            freezed == attchedDocumentType
                ? _value.attchedDocumentType
                : attchedDocumentType // ignore: cast_nullable_to_non_nullable
                    as String?,
        attchedName:
            freezed == attchedName
                ? _value.attchedName
                : attchedName // ignore: cast_nullable_to_non_nullable
                    as String?,
        attchedField:
            freezed == attchedField
                ? _value.attchedField
                : attchedField // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachementInvoicesImpl implements _AttachementInvoices {
  const _$AttachementInvoicesImpl({
    @JsonKey(name: 'file_url') this.fileUrl,
    @JsonKey(name: 'attached_to_doctype') this.attchedDocumentType,
    @JsonKey(name: 'attached_to_name') this.attchedName,
    @JsonKey(name: 'attached_to_field') this.attchedField,
  });

  factory _$AttachementInvoicesImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachementInvoicesImplFromJson(json);

  @override
  @JsonKey(name: 'file_url')
  final String? fileUrl;
  @override
  @JsonKey(name: 'attached_to_doctype')
  final String? attchedDocumentType;
  @override
  @JsonKey(name: 'attached_to_name')
  final String? attchedName;
  @override
  @JsonKey(name: 'attached_to_field')
  final String? attchedField;

  @override
  String toString() {
    return 'AttachementInvoices(fileUrl: $fileUrl, attchedDocumentType: $attchedDocumentType, attchedName: $attchedName, attchedField: $attchedField)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachementInvoicesImpl &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.attchedDocumentType, attchedDocumentType) ||
                other.attchedDocumentType == attchedDocumentType) &&
            (identical(other.attchedName, attchedName) ||
                other.attchedName == attchedName) &&
            (identical(other.attchedField, attchedField) ||
                other.attchedField == attchedField));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fileUrl,
    attchedDocumentType,
    attchedName,
    attchedField,
  );

  /// Create a copy of AttachementInvoices
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachementInvoicesImplCopyWith<_$AttachementInvoicesImpl> get copyWith =>
      __$$AttachementInvoicesImplCopyWithImpl<_$AttachementInvoicesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachementInvoicesImplToJson(this);
  }
}

abstract class _AttachementInvoices implements AttachementInvoices {
  const factory _AttachementInvoices({
    @JsonKey(name: 'file_url') final String? fileUrl,
    @JsonKey(name: 'attached_to_doctype') final String? attchedDocumentType,
    @JsonKey(name: 'attached_to_name') final String? attchedName,
    @JsonKey(name: 'attached_to_field') final String? attchedField,
  }) = _$AttachementInvoicesImpl;

  factory _AttachementInvoices.fromJson(Map<String, dynamic> json) =
      _$AttachementInvoicesImpl.fromJson;

  @override
  @JsonKey(name: 'file_url')
  String? get fileUrl;
  @override
  @JsonKey(name: 'attached_to_doctype')
  String? get attchedDocumentType;
  @override
  @JsonKey(name: 'attached_to_name')
  String? get attchedName;
  @override
  @JsonKey(name: 'attached_to_field')
  String? get attchedField;

  /// Create a copy of AttachementInvoices
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttachementInvoicesImplCopyWith<_$AttachementInvoicesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
