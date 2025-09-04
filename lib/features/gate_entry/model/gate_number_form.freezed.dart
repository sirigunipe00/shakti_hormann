// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gate_number_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GateNumberForm _$GateNumberFormFromJson(Map<String, dynamic> json) {
  return _GateNumberForm.fromJson(json);
}

/// @nodoc
mixin _$GateNumberForm {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'unloading_point_name')
  String? get pointName => throw _privateConstructorUsedError;

  /// Serializes this GateNumberForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GateNumberForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GateNumberFormCopyWith<GateNumberForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GateNumberFormCopyWith<$Res> {
  factory $GateNumberFormCopyWith(
    GateNumberForm value,
    $Res Function(GateNumberForm) then,
  ) = _$GateNumberFormCopyWithImpl<$Res, GateNumberForm>;
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'unloading_point_name') String? pointName,
  });
}

/// @nodoc
class _$GateNumberFormCopyWithImpl<$Res, $Val extends GateNumberForm>
    implements $GateNumberFormCopyWith<$Res> {
  _$GateNumberFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GateNumberForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? pointName = freezed}) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            pointName:
                freezed == pointName
                    ? _value.pointName
                    : pointName // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GateNumberFormImplCopyWith<$Res>
    implements $GateNumberFormCopyWith<$Res> {
  factory _$$GateNumberFormImplCopyWith(
    _$GateNumberFormImpl value,
    $Res Function(_$GateNumberFormImpl) then,
  ) = __$$GateNumberFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'unloading_point_name') String? pointName,
  });
}

/// @nodoc
class __$$GateNumberFormImplCopyWithImpl<$Res>
    extends _$GateNumberFormCopyWithImpl<$Res, _$GateNumberFormImpl>
    implements _$$GateNumberFormImplCopyWith<$Res> {
  __$$GateNumberFormImplCopyWithImpl(
    _$GateNumberFormImpl _value,
    $Res Function(_$GateNumberFormImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GateNumberForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? pointName = freezed}) {
    return _then(
      _$GateNumberFormImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        pointName:
            freezed == pointName
                ? _value.pointName
                : pointName // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GateNumberFormImpl implements _GateNumberForm {
  const _$GateNumberFormImpl({
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'unloading_point_name') this.pointName,
  });

  factory _$GateNumberFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$GateNumberFormImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'unloading_point_name')
  final String? pointName;

  @override
  String toString() {
    return 'GateNumberForm(name: $name, pointName: $pointName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GateNumberFormImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.pointName, pointName) ||
                other.pointName == pointName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, pointName);

  /// Create a copy of GateNumberForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GateNumberFormImplCopyWith<_$GateNumberFormImpl> get copyWith =>
      __$$GateNumberFormImplCopyWithImpl<_$GateNumberFormImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GateNumberFormImplToJson(this);
  }
}

abstract class _GateNumberForm implements GateNumberForm {
  const factory _GateNumberForm({
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'unloading_point_name') final String? pointName,
  }) = _$GateNumberFormImpl;

  factory _GateNumberForm.fromJson(Map<String, dynamic> json) =
      _$GateNumberFormImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'unloading_point_name')
  String? get pointName;

  /// Create a copy of GateNumberForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GateNumberFormImplCopyWith<_$GateNumberFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
