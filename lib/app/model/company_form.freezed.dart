// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CompanyForm _$CompanyFormFromJson(Map<String, dynamic> json) {
  return _CompanyForm.fromJson(json);
}

/// @nodoc
mixin _$CompanyForm {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'custom_company_type')
  String? get companyType => throw _privateConstructorUsedError;

  /// Serializes this CompanyForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyFormCopyWith<CompanyForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyFormCopyWith<$Res> {
  factory $CompanyFormCopyWith(
    CompanyForm value,
    $Res Function(CompanyForm) then,
  ) = _$CompanyFormCopyWithImpl<$Res, CompanyForm>;
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'custom_company_type') String? companyType,
  });
}

/// @nodoc
class _$CompanyFormCopyWithImpl<$Res, $Val extends CompanyForm>
    implements $CompanyFormCopyWith<$Res> {
  _$CompanyFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? companyName = freezed,
    Object? companyType = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            companyName:
                freezed == companyName
                    ? _value.companyName
                    : companyName // ignore: cast_nullable_to_non_nullable
                        as String?,
            companyType:
                freezed == companyType
                    ? _value.companyType
                    : companyType // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompanyFormImplCopyWith<$Res>
    implements $CompanyFormCopyWith<$Res> {
  factory _$$CompanyFormImplCopyWith(
    _$CompanyFormImpl value,
    $Res Function(_$CompanyFormImpl) then,
  ) = __$$CompanyFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'custom_company_type') String? companyType,
  });
}

/// @nodoc
class __$$CompanyFormImplCopyWithImpl<$Res>
    extends _$CompanyFormCopyWithImpl<$Res, _$CompanyFormImpl>
    implements _$$CompanyFormImplCopyWith<$Res> {
  __$$CompanyFormImplCopyWithImpl(
    _$CompanyFormImpl _value,
    $Res Function(_$CompanyFormImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompanyForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? companyName = freezed,
    Object? companyType = freezed,
  }) {
    return _then(
      _$CompanyFormImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        companyName:
            freezed == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                    as String?,
        companyType:
            freezed == companyType
                ? _value.companyType
                : companyType // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyFormImpl implements _CompanyForm {
  const _$CompanyFormImpl({
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'company_name') this.companyName,
    @JsonKey(name: 'custom_company_type') this.companyType,
  });

  factory _$CompanyFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyFormImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  @JsonKey(name: 'custom_company_type')
  final String? companyType;

  @override
  String toString() {
    return 'CompanyForm(name: $name, companyName: $companyName, companyType: $companyType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyFormImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyType, companyType) ||
                other.companyType == companyType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, companyName, companyType);

  /// Create a copy of CompanyForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyFormImplCopyWith<_$CompanyFormImpl> get copyWith =>
      __$$CompanyFormImplCopyWithImpl<_$CompanyFormImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyFormImplToJson(this);
  }
}

abstract class _CompanyForm implements CompanyForm {
  const factory _CompanyForm({
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'company_name') final String? companyName,
    @JsonKey(name: 'custom_company_type') final String? companyType,
  }) = _$CompanyFormImpl;

  factory _CompanyForm.fromJson(Map<String, dynamic> json) =
      _$CompanyFormImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  @JsonKey(name: 'custom_company_type')
  String? get companyType;

  /// Create a copy of CompanyForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyFormImplCopyWith<_$CompanyFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
