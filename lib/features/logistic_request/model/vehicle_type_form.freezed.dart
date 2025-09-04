// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_type_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VehicleTypeForm _$VehicleTypeFormFromJson(Map<String, dynamic> json) {
  return _VehicleTypeForm.fromJson(json);
}

/// @nodoc
mixin _$VehicleTypeForm {
  @JsonKey(name: 'vehicle')
  String? get vehicle => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this VehicleTypeForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleTypeForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleTypeFormCopyWith<VehicleTypeForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleTypeFormCopyWith<$Res> {
  factory $VehicleTypeFormCopyWith(
    VehicleTypeForm value,
    $Res Function(VehicleTypeForm) then,
  ) = _$VehicleTypeFormCopyWithImpl<$Res, VehicleTypeForm>;
  @useResult
  $Res call({
    @JsonKey(name: 'vehicle') String? vehicle,
    @JsonKey(name: 'name') String? name,
  });
}

/// @nodoc
class _$VehicleTypeFormCopyWithImpl<$Res, $Val extends VehicleTypeForm>
    implements $VehicleTypeFormCopyWith<$Res> {
  _$VehicleTypeFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleTypeForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vehicle = freezed, Object? name = freezed}) {
    return _then(
      _value.copyWith(
            vehicle:
                freezed == vehicle
                    ? _value.vehicle
                    : vehicle // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleTypeFormImplCopyWith<$Res>
    implements $VehicleTypeFormCopyWith<$Res> {
  factory _$$VehicleTypeFormImplCopyWith(
    _$VehicleTypeFormImpl value,
    $Res Function(_$VehicleTypeFormImpl) then,
  ) = __$$VehicleTypeFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'vehicle') String? vehicle,
    @JsonKey(name: 'name') String? name,
  });
}

/// @nodoc
class __$$VehicleTypeFormImplCopyWithImpl<$Res>
    extends _$VehicleTypeFormCopyWithImpl<$Res, _$VehicleTypeFormImpl>
    implements _$$VehicleTypeFormImplCopyWith<$Res> {
  __$$VehicleTypeFormImplCopyWithImpl(
    _$VehicleTypeFormImpl _value,
    $Res Function(_$VehicleTypeFormImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleTypeForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vehicle = freezed, Object? name = freezed}) {
    return _then(
      _$VehicleTypeFormImpl(
        vehicle:
            freezed == vehicle
                ? _value.vehicle
                : vehicle // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleTypeFormImpl implements _VehicleTypeForm {
  const _$VehicleTypeFormImpl({
    @JsonKey(name: 'vehicle') this.vehicle,
    @JsonKey(name: 'name') this.name,
  });

  factory _$VehicleTypeFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleTypeFormImplFromJson(json);

  @override
  @JsonKey(name: 'vehicle')
  final String? vehicle;
  @override
  @JsonKey(name: 'name')
  final String? name;

  @override
  String toString() {
    return 'VehicleTypeForm(vehicle: $vehicle, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleTypeFormImpl &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vehicle, name);

  /// Create a copy of VehicleTypeForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleTypeFormImplCopyWith<_$VehicleTypeFormImpl> get copyWith =>
      __$$VehicleTypeFormImplCopyWithImpl<_$VehicleTypeFormImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleTypeFormImplToJson(this);
  }
}

abstract class _VehicleTypeForm implements VehicleTypeForm {
  const factory _VehicleTypeForm({
    @JsonKey(name: 'vehicle') final String? vehicle,
    @JsonKey(name: 'name') final String? name,
  }) = _$VehicleTypeFormImpl;

  factory _VehicleTypeForm.fromJson(Map<String, dynamic> json) =
      _$VehicleTypeFormImpl.fromJson;

  @override
  @JsonKey(name: 'vehicle')
  String? get vehicle;
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Create a copy of VehicleTypeForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleTypeFormImplCopyWith<_$VehicleTypeFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
