// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationForm _$RegistrationFormFromJson(Map<String, dynamic> json) {
  return _RegistrationForm.fromJson(json);
}

/// @nodoc
mixin _$RegistrationForm {
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'mobile')
  String? get mobileNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: true)
  String? get cnfPswd => throw _privateConstructorUsedError;

  /// Serializes this RegistrationForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegistrationForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistrationFormCopyWith<RegistrationForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationFormCopyWith<$Res> {
  factory $RegistrationFormCopyWith(
          RegistrationForm value, $Res Function(RegistrationForm) then) =
      _$RegistrationFormCopyWithImpl<$Res, RegistrationForm>;
  @useResult
  $Res call(
      {@JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'mobile') String? mobileNumber,
      String? email,
      String? password,
      @JsonKey(includeToJson: true) String? cnfPswd});
}

/// @nodoc
class _$RegistrationFormCopyWithImpl<$Res, $Val extends RegistrationForm>
    implements $RegistrationFormCopyWith<$Res> {
  _$RegistrationFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = freezed,
    Object? mobileNumber = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? cnfPswd = freezed,
  }) {
    return _then(_value.copyWith(
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileNumber: freezed == mobileNumber
          ? _value.mobileNumber
          : mobileNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      cnfPswd: freezed == cnfPswd
          ? _value.cnfPswd
          : cnfPswd // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationFormImplCopyWith<$Res>
    implements $RegistrationFormCopyWith<$Res> {
  factory _$$RegistrationFormImplCopyWith(_$RegistrationFormImpl value,
          $Res Function(_$RegistrationFormImpl) then) =
      __$$RegistrationFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'mobile') String? mobileNumber,
      String? email,
      String? password,
      @JsonKey(includeToJson: true) String? cnfPswd});
}

/// @nodoc
class __$$RegistrationFormImplCopyWithImpl<$Res>
    extends _$RegistrationFormCopyWithImpl<$Res, _$RegistrationFormImpl>
    implements _$$RegistrationFormImplCopyWith<$Res> {
  __$$RegistrationFormImplCopyWithImpl(_$RegistrationFormImpl _value,
      $Res Function(_$RegistrationFormImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = freezed,
    Object? mobileNumber = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? cnfPswd = freezed,
  }) {
    return _then(_$RegistrationFormImpl(
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileNumber: freezed == mobileNumber
          ? _value.mobileNumber
          : mobileNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      cnfPswd: freezed == cnfPswd
          ? _value.cnfPswd
          : cnfPswd // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationFormImpl extends _RegistrationForm {
  const _$RegistrationFormImpl(
      {@JsonKey(name: 'full_name') this.fullName,
      @JsonKey(name: 'mobile') this.mobileNumber,
      this.email,
      this.password,
      @JsonKey(includeToJson: true) this.cnfPswd})
      : super._();

  factory _$RegistrationFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationFormImplFromJson(json);

  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  @JsonKey(name: 'mobile')
  final String? mobileNumber;
  @override
  final String? email;
  @override
  final String? password;
  @override
  @JsonKey(includeToJson: true)
  final String? cnfPswd;

  @override
  String toString() {
    return 'RegistrationForm(fullName: $fullName, mobileNumber: $mobileNumber, email: $email, password: $password, cnfPswd: $cnfPswd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationFormImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.mobileNumber, mobileNumber) ||
                other.mobileNumber == mobileNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.cnfPswd, cnfPswd) || other.cnfPswd == cnfPswd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, fullName, mobileNumber, email, password, cnfPswd);

  /// Create a copy of RegistrationForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationFormImplCopyWith<_$RegistrationFormImpl> get copyWith =>
      __$$RegistrationFormImplCopyWithImpl<_$RegistrationFormImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationFormImplToJson(
      this,
    );
  }
}

abstract class _RegistrationForm extends RegistrationForm {
  const factory _RegistrationForm(
          {@JsonKey(name: 'full_name') final String? fullName,
          @JsonKey(name: 'mobile') final String? mobileNumber,
          final String? email,
          final String? password,
          @JsonKey(includeToJson: true) final String? cnfPswd}) =
      _$RegistrationFormImpl;
  const _RegistrationForm._() : super._();

  factory _RegistrationForm.fromJson(Map<String, dynamic> json) =
      _$RegistrationFormImpl.fromJson;

  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  @JsonKey(name: 'mobile')
  String? get mobileNumber;
  @override
  String? get email;
  @override
  String? get password;
  @override
  @JsonKey(includeToJson: true)
  String? get cnfPswd;

  /// Create a copy of RegistrationForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationFormImplCopyWith<_$RegistrationFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
