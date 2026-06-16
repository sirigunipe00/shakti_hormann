// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'frame_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FrameItems _$FrameItemsFromJson(Map<String, dynamic> json) {
  return _FrameItems.fromJson(json);
}

/// @nodoc
mixin _$FrameItems {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_code')
  String? get itemCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_name')
  String? get itemName => throw _privateConstructorUsedError;

  /// Serializes this FrameItems to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FrameItems
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FrameItemsCopyWith<FrameItems> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FrameItemsCopyWith<$Res> {
  factory $FrameItemsCopyWith(
    FrameItems value,
    $Res Function(FrameItems) then,
  ) = _$FrameItemsCopyWithImpl<$Res, FrameItems>;
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'item_code') String? itemCode,
    @JsonKey(name: 'item_name') String? itemName,
  });
}

/// @nodoc
class _$FrameItemsCopyWithImpl<$Res, $Val extends FrameItems>
    implements $FrameItemsCopyWith<$Res> {
  _$FrameItemsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FrameItems
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? itemCode = freezed,
    Object? itemName = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            itemCode:
                freezed == itemCode
                    ? _value.itemCode
                    : itemCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            itemName:
                freezed == itemName
                    ? _value.itemName
                    : itemName // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FrameItemsImplCopyWith<$Res>
    implements $FrameItemsCopyWith<$Res> {
  factory _$$FrameItemsImplCopyWith(
    _$FrameItemsImpl value,
    $Res Function(_$FrameItemsImpl) then,
  ) = __$$FrameItemsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'item_code') String? itemCode,
    @JsonKey(name: 'item_name') String? itemName,
  });
}

/// @nodoc
class __$$FrameItemsImplCopyWithImpl<$Res>
    extends _$FrameItemsCopyWithImpl<$Res, _$FrameItemsImpl>
    implements _$$FrameItemsImplCopyWith<$Res> {
  __$$FrameItemsImplCopyWithImpl(
    _$FrameItemsImpl _value,
    $Res Function(_$FrameItemsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FrameItems
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? itemCode = freezed,
    Object? itemName = freezed,
  }) {
    return _then(
      _$FrameItemsImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        itemCode:
            freezed == itemCode
                ? _value.itemCode
                : itemCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        itemName:
            freezed == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FrameItemsImpl implements _FrameItems {
  const _$FrameItemsImpl({
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'item_code') this.itemCode,
    @JsonKey(name: 'item_name') this.itemName,
  });

  factory _$FrameItemsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FrameItemsImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'item_code')
  final String? itemCode;
  @override
  @JsonKey(name: 'item_name')
  final String? itemName;

  @override
  String toString() {
    return 'FrameItems(name: $name, itemCode: $itemCode, itemName: $itemName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FrameItemsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.itemCode, itemCode) ||
                other.itemCode == itemCode) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, itemCode, itemName);

  /// Create a copy of FrameItems
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FrameItemsImplCopyWith<_$FrameItemsImpl> get copyWith =>
      __$$FrameItemsImplCopyWithImpl<_$FrameItemsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FrameItemsImplToJson(this);
  }
}

abstract class _FrameItems implements FrameItems {
  const factory _FrameItems({
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'item_code') final String? itemCode,
    @JsonKey(name: 'item_name') final String? itemName,
  }) = _$FrameItemsImpl;

  factory _FrameItems.fromJson(Map<String, dynamic> json) =
      _$FrameItemsImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'item_code')
  String? get itemCode;
  @override
  @JsonKey(name: 'item_name')
  String? get itemName;

  /// Create a copy of FrameItems
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FrameItemsImplCopyWith<_$FrameItemsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
