// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_order_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalesOrderForm _$SalesOrderFormFromJson(Map<String, dynamic> json) {
  return _SalesOrderForm.fromJson(json);
}

/// @nodoc
mixin _$SalesOrderForm {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'company')
  String? get plantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_display')
  String? get addressDisplay => throw _privateConstructorUsedError;

  /// Serializes this SalesOrderForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesOrderForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesOrderFormCopyWith<SalesOrderForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesOrderFormCopyWith<$Res> {
  factory $SalesOrderFormCopyWith(
    SalesOrderForm value,
    $Res Function(SalesOrderForm) then,
  ) = _$SalesOrderFormCopyWithImpl<$Res, SalesOrderForm>;
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'company') String? plantName,
    @JsonKey(name: 'address_display') String? addressDisplay,
  });
}

/// @nodoc
class _$SalesOrderFormCopyWithImpl<$Res, $Val extends SalesOrderForm>
    implements $SalesOrderFormCopyWith<$Res> {
  _$SalesOrderFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesOrderForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? plantName = freezed,
    Object? addressDisplay = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            plantName:
                freezed == plantName
                    ? _value.plantName
                    : plantName // ignore: cast_nullable_to_non_nullable
                        as String?,
            addressDisplay:
                freezed == addressDisplay
                    ? _value.addressDisplay
                    : addressDisplay // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalesOrderFormImplCopyWith<$Res>
    implements $SalesOrderFormCopyWith<$Res> {
  factory _$$SalesOrderFormImplCopyWith(
    _$SalesOrderFormImpl value,
    $Res Function(_$SalesOrderFormImpl) then,
  ) = __$$SalesOrderFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'company') String? plantName,
    @JsonKey(name: 'address_display') String? addressDisplay,
  });
}

/// @nodoc
class __$$SalesOrderFormImplCopyWithImpl<$Res>
    extends _$SalesOrderFormCopyWithImpl<$Res, _$SalesOrderFormImpl>
    implements _$$SalesOrderFormImplCopyWith<$Res> {
  __$$SalesOrderFormImplCopyWithImpl(
    _$SalesOrderFormImpl _value,
    $Res Function(_$SalesOrderFormImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalesOrderForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? plantName = freezed,
    Object? addressDisplay = freezed,
  }) {
    return _then(
      _$SalesOrderFormImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        plantName:
            freezed == plantName
                ? _value.plantName
                : plantName // ignore: cast_nullable_to_non_nullable
                    as String?,
        addressDisplay:
            freezed == addressDisplay
                ? _value.addressDisplay
                : addressDisplay // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesOrderFormImpl implements _SalesOrderForm {
  const _$SalesOrderFormImpl({
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'company') this.plantName,
    @JsonKey(name: 'address_display') this.addressDisplay,
  });

  factory _$SalesOrderFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesOrderFormImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'company')
  final String? plantName;
  @override
  @JsonKey(name: 'address_display')
  final String? addressDisplay;

  @override
  String toString() {
    return 'SalesOrderForm(name: $name, plantName: $plantName, addressDisplay: $addressDisplay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesOrderFormImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.plantName, plantName) ||
                other.plantName == plantName) &&
            (identical(other.addressDisplay, addressDisplay) ||
                other.addressDisplay == addressDisplay));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, plantName, addressDisplay);

  /// Create a copy of SalesOrderForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesOrderFormImplCopyWith<_$SalesOrderFormImpl> get copyWith =>
      __$$SalesOrderFormImplCopyWithImpl<_$SalesOrderFormImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesOrderFormImplToJson(this);
  }
}

abstract class _SalesOrderForm implements SalesOrderForm {
  const factory _SalesOrderForm({
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'company') final String? plantName,
    @JsonKey(name: 'address_display') final String? addressDisplay,
  }) = _$SalesOrderFormImpl;

  factory _SalesOrderForm.fromJson(Map<String, dynamic> json) =
      _$SalesOrderFormImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'company')
  String? get plantName;
  @override
  @JsonKey(name: 'address_display')
  String? get addressDisplay;

  /// Create a copy of SalesOrderForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesOrderFormImplCopyWith<_$SalesOrderFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
