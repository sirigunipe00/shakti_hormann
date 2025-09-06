// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalesOrder _$SalesOrderFromJson(Map<String, dynamic> json) {
  return _SalesOrder.fromJson(json);
}

/// @nodoc
mixin _$SalesOrder {
  @JsonKey(name: 'sales_order')
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this SalesOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesOrderCopyWith<SalesOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesOrderCopyWith<$Res> {
  factory $SalesOrderCopyWith(
    SalesOrder value,
    $Res Function(SalesOrder) then,
  ) = _$SalesOrderCopyWithImpl<$Res, SalesOrder>;
  @useResult
  $Res call({@JsonKey(name: 'sales_order') String? name});
}

/// @nodoc
class _$SalesOrderCopyWithImpl<$Res, $Val extends SalesOrder>
    implements $SalesOrderCopyWith<$Res> {
  _$SalesOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed}) {
    return _then(
      _value.copyWith(
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
abstract class _$$SalesOrderImplCopyWith<$Res>
    implements $SalesOrderCopyWith<$Res> {
  factory _$$SalesOrderImplCopyWith(
    _$SalesOrderImpl value,
    $Res Function(_$SalesOrderImpl) then,
  ) = __$$SalesOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'sales_order') String? name});
}

/// @nodoc
class __$$SalesOrderImplCopyWithImpl<$Res>
    extends _$SalesOrderCopyWithImpl<$Res, _$SalesOrderImpl>
    implements _$$SalesOrderImplCopyWith<$Res> {
  __$$SalesOrderImplCopyWithImpl(
    _$SalesOrderImpl _value,
    $Res Function(_$SalesOrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalesOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed}) {
    return _then(
      _$SalesOrderImpl(
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
class _$SalesOrderImpl implements _SalesOrder {
  const _$SalesOrderImpl({@JsonKey(name: 'sales_order') this.name});

  factory _$SalesOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesOrderImplFromJson(json);

  @override
  @JsonKey(name: 'sales_order')
  final String? name;

  @override
  String toString() {
    return 'SalesOrder(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesOrderImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of SalesOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesOrderImplCopyWith<_$SalesOrderImpl> get copyWith =>
      __$$SalesOrderImplCopyWithImpl<_$SalesOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesOrderImplToJson(this);
  }
}

abstract class _SalesOrder implements SalesOrder {
  const factory _SalesOrder({
    @JsonKey(name: 'sales_order') final String? name,
  }) = _$SalesOrderImpl;

  factory _SalesOrder.fromJson(Map<String, dynamic> json) =
      _$SalesOrderImpl.fromJson;

  @override
  @JsonKey(name: 'sales_order')
  String? get name;

  /// Create a copy of SalesOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesOrderImplCopyWith<_$SalesOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
