// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pallet_size.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PalletSize _$PalletSizeFromJson(Map<String, dynamic> json) {
  return _PalletSize.fromJson(json);
}

/// @nodoc
mixin _$PalletSize {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this PalletSize to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PalletSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PalletSizeCopyWith<PalletSize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PalletSizeCopyWith<$Res> {
  factory $PalletSizeCopyWith(
    PalletSize value,
    $Res Function(PalletSize) then,
  ) = _$PalletSizeCopyWithImpl<$Res, PalletSize>;
  @useResult
  $Res call({@JsonKey(name: 'name') String? name});
}

/// @nodoc
class _$PalletSizeCopyWithImpl<$Res, $Val extends PalletSize>
    implements $PalletSizeCopyWith<$Res> {
  _$PalletSizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PalletSize
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
abstract class _$$PalletSizeImplCopyWith<$Res>
    implements $PalletSizeCopyWith<$Res> {
  factory _$$PalletSizeImplCopyWith(
    _$PalletSizeImpl value,
    $Res Function(_$PalletSizeImpl) then,
  ) = __$$PalletSizeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'name') String? name});
}

/// @nodoc
class __$$PalletSizeImplCopyWithImpl<$Res>
    extends _$PalletSizeCopyWithImpl<$Res, _$PalletSizeImpl>
    implements _$$PalletSizeImplCopyWith<$Res> {
  __$$PalletSizeImplCopyWithImpl(
    _$PalletSizeImpl _value,
    $Res Function(_$PalletSizeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PalletSize
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed}) {
    return _then(
      _$PalletSizeImpl(
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
class _$PalletSizeImpl implements _PalletSize {
  const _$PalletSizeImpl({@JsonKey(name: 'name') this.name});

  factory _$PalletSizeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PalletSizeImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;

  @override
  String toString() {
    return 'PalletSize(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PalletSizeImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of PalletSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PalletSizeImplCopyWith<_$PalletSizeImpl> get copyWith =>
      __$$PalletSizeImplCopyWithImpl<_$PalletSizeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PalletSizeImplToJson(this);
  }
}

abstract class _PalletSize implements PalletSize {
  const factory _PalletSize({@JsonKey(name: 'name') final String? name}) =
      _$PalletSizeImpl;

  factory _PalletSize.fromJson(Map<String, dynamic> json) =
      _$PalletSizeImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Create a copy of PalletSize
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PalletSizeImplCopyWith<_$PalletSizeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
