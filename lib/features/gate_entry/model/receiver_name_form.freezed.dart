// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receiver_name_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReceiverNameForm _$ReceiverNameFormFromJson(Map<String, dynamic> json) {
  return _ReceiverNameForm.fromJson(json);
}

/// @nodoc
mixin _$ReceiverNameForm {
  String? get gstin => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String get custName => throw _privateConstructorUsedError;

  /// Serializes this ReceiverNameForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReceiverNameForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiverNameFormCopyWith<ReceiverNameForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiverNameFormCopyWith<$Res> {
  factory $ReceiverNameFormCopyWith(
    ReceiverNameForm value,
    $Res Function(ReceiverNameForm) then,
  ) = _$ReceiverNameFormCopyWithImpl<$Res, ReceiverNameForm>;
  @useResult
  $Res call({
    String? gstin,
    @JsonKey(name: 'name') String name,
    @JsonKey(name: 'customer_name') String custName,
  });
}

/// @nodoc
class _$ReceiverNameFormCopyWithImpl<$Res, $Val extends ReceiverNameForm>
    implements $ReceiverNameFormCopyWith<$Res> {
  _$ReceiverNameFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceiverNameForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gstin = freezed,
    Object? name = null,
    Object? custName = null,
  }) {
    return _then(
      _value.copyWith(
            gstin:
                freezed == gstin
                    ? _value.gstin
                    : gstin // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            custName:
                null == custName
                    ? _value.custName
                    : custName // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReceiverNameFormImplCopyWith<$Res>
    implements $ReceiverNameFormCopyWith<$Res> {
  factory _$$ReceiverNameFormImplCopyWith(
    _$ReceiverNameFormImpl value,
    $Res Function(_$ReceiverNameFormImpl) then,
  ) = __$$ReceiverNameFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? gstin,
    @JsonKey(name: 'name') String name,
    @JsonKey(name: 'customer_name') String custName,
  });
}

/// @nodoc
class __$$ReceiverNameFormImplCopyWithImpl<$Res>
    extends _$ReceiverNameFormCopyWithImpl<$Res, _$ReceiverNameFormImpl>
    implements _$$ReceiverNameFormImplCopyWith<$Res> {
  __$$ReceiverNameFormImplCopyWithImpl(
    _$ReceiverNameFormImpl _value,
    $Res Function(_$ReceiverNameFormImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReceiverNameForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gstin = freezed,
    Object? name = null,
    Object? custName = null,
  }) {
    return _then(
      _$ReceiverNameFormImpl(
        gstin:
            freezed == gstin
                ? _value.gstin
                : gstin // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        custName:
            null == custName
                ? _value.custName
                : custName // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiverNameFormImpl implements _ReceiverNameForm {
  _$ReceiverNameFormImpl({
    this.gstin,
    @JsonKey(name: 'name') required this.name,
    @JsonKey(name: 'customer_name') required this.custName,
  });

  factory _$ReceiverNameFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiverNameFormImplFromJson(json);

  @override
  final String? gstin;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'customer_name')
  final String custName;

  @override
  String toString() {
    return 'ReceiverNameForm(gstin: $gstin, name: $name, custName: $custName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiverNameFormImpl &&
            (identical(other.gstin, gstin) || other.gstin == gstin) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.custName, custName) ||
                other.custName == custName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gstin, name, custName);

  /// Create a copy of ReceiverNameForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiverNameFormImplCopyWith<_$ReceiverNameFormImpl> get copyWith =>
      __$$ReceiverNameFormImplCopyWithImpl<_$ReceiverNameFormImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiverNameFormImplToJson(this);
  }
}

abstract class _ReceiverNameForm implements ReceiverNameForm {
  factory _ReceiverNameForm({
    final String? gstin,
    @JsonKey(name: 'name') required final String name,
    @JsonKey(name: 'customer_name') required final String custName,
  }) = _$ReceiverNameFormImpl;

  factory _ReceiverNameForm.fromJson(Map<String, dynamic> json) =
      _$ReceiverNameFormImpl.fromJson;

  @override
  String? get gstin;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'customer_name')
  String get custName;

  /// Create a copy of ReceiverNameForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiverNameFormImplCopyWith<_$ReceiverNameFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
