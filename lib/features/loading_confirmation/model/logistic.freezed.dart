// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logistic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LogisticModel _$LogisticModelFromJson(Map<String, dynamic> json) {
  return _LogisticModel.fromJson(json);
}

/// @nodoc
mixin _$LogisticModel {
  @JsonKey(name: 'sales_order')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'state')
  String? get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'city')
  String? get city => throw _privateConstructorUsedError;

  /// Serializes this LogisticModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LogisticModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogisticModelCopyWith<LogisticModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogisticModelCopyWith<$Res> {
  factory $LogisticModelCopyWith(
    LogisticModel value,
    $Res Function(LogisticModel) then,
  ) = _$LogisticModelCopyWithImpl<$Res, LogisticModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'sales_order') String? name,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'city') String? city,
  });
}

/// @nodoc
class _$LogisticModelCopyWithImpl<$Res, $Val extends LogisticModel>
    implements $LogisticModelCopyWith<$Res> {
  _$LogisticModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogisticModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? state = freezed,
    Object? city = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            state:
                freezed == state
                    ? _value.state
                    : state // ignore: cast_nullable_to_non_nullable
                        as String?,
            city:
                freezed == city
                    ? _value.city
                    : city // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogisticModelImplCopyWith<$Res>
    implements $LogisticModelCopyWith<$Res> {
  factory _$$LogisticModelImplCopyWith(
    _$LogisticModelImpl value,
    $Res Function(_$LogisticModelImpl) then,
  ) = __$$LogisticModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'sales_order') String? name,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'city') String? city,
  });
}

/// @nodoc
class __$$LogisticModelImplCopyWithImpl<$Res>
    extends _$LogisticModelCopyWithImpl<$Res, _$LogisticModelImpl>
    implements _$$LogisticModelImplCopyWith<$Res> {
  __$$LogisticModelImplCopyWithImpl(
    _$LogisticModelImpl _value,
    $Res Function(_$LogisticModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogisticModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? state = freezed,
    Object? city = freezed,
  }) {
    return _then(
      _$LogisticModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        state:
            freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                    as String?,
        city:
            freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LogisticModelImpl implements _LogisticModel {
  const _$LogisticModelImpl({
    @JsonKey(name: 'sales_order') this.name,
    @JsonKey(name: 'state') this.state,
    @JsonKey(name: 'city') this.city,
  });

  factory _$LogisticModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogisticModelImplFromJson(json);

  @override
  @JsonKey(name: 'sales_order')
  final String? name;
  @override
  @JsonKey(name: 'state')
  final String? state;
  @override
  @JsonKey(name: 'city')
  final String? city;

  @override
  String toString() {
    return 'LogisticModel(name: $name, state: $state, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogisticModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, state, city);

  /// Create a copy of LogisticModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogisticModelImplCopyWith<_$LogisticModelImpl> get copyWith =>
      __$$LogisticModelImplCopyWithImpl<_$LogisticModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogisticModelImplToJson(this);
  }
}

abstract class _LogisticModel implements LogisticModel {
  const factory _LogisticModel({
    @JsonKey(name: 'sales_order') final String? name,
    @JsonKey(name: 'state') final String? state,
    @JsonKey(name: 'city') final String? city,
  }) = _$LogisticModelImpl;

  factory _LogisticModel.fromJson(Map<String, dynamic> json) =
      _$LogisticModelImpl.fromJson;

  @override
  @JsonKey(name: 'sales_order')
  String? get name;
  @override
  @JsonKey(name: 'state')
  String? get state;
  @override
  @JsonKey(name: 'city')
  String? get city;

  /// Create a copy of LogisticModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogisticModelImplCopyWith<_$LogisticModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
