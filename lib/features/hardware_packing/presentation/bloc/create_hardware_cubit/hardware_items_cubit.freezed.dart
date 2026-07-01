// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hardware_items_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HardwarePackingItemsState {
  HardwarePackingItem? get response => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of HardwarePackingItemsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HardwarePackingItemsStateCopyWith<HardwarePackingItemsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HardwarePackingItemsStateCopyWith<$Res> {
  factory $HardwarePackingItemsStateCopyWith(
    HardwarePackingItemsState value,
    $Res Function(HardwarePackingItemsState) then,
  ) = _$HardwarePackingItemsStateCopyWithImpl<$Res, HardwarePackingItemsState>;
  @useResult
  $Res call({
    HardwarePackingItem? response,
    bool isLoading,
    bool isSuccess,
    Failure? error,
  });

  $HardwarePackingItemCopyWith<$Res>? get response;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$HardwarePackingItemsStateCopyWithImpl<
  $Res,
  $Val extends HardwarePackingItemsState
>
    implements $HardwarePackingItemsStateCopyWith<$Res> {
  _$HardwarePackingItemsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HardwarePackingItemsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = freezed,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            response:
                freezed == response
                    ? _value.response
                    : response // ignore: cast_nullable_to_non_nullable
                        as HardwarePackingItem?,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            isSuccess:
                null == isSuccess
                    ? _value.isSuccess
                    : isSuccess // ignore: cast_nullable_to_non_nullable
                        as bool,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as Failure?,
          )
          as $Val,
    );
  }

  /// Create a copy of HardwarePackingItemsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HardwarePackingItemCopyWith<$Res>? get response {
    if (_value.response == null) {
      return null;
    }

    return $HardwarePackingItemCopyWith<$Res>(_value.response!, (value) {
      return _then(_value.copyWith(response: value) as $Val);
    });
  }

  /// Create a copy of HardwarePackingItemsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res>? get error {
    if (_value.error == null) {
      return null;
    }

    return $FailureCopyWith<$Res>(_value.error!, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HardwarePackingItemsStateImplCopyWith<$Res>
    implements $HardwarePackingItemsStateCopyWith<$Res> {
  factory _$$HardwarePackingItemsStateImplCopyWith(
    _$HardwarePackingItemsStateImpl value,
    $Res Function(_$HardwarePackingItemsStateImpl) then,
  ) = __$$HardwarePackingItemsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    HardwarePackingItem? response,
    bool isLoading,
    bool isSuccess,
    Failure? error,
  });

  @override
  $HardwarePackingItemCopyWith<$Res>? get response;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$HardwarePackingItemsStateImplCopyWithImpl<$Res>
    extends
        _$HardwarePackingItemsStateCopyWithImpl<
          $Res,
          _$HardwarePackingItemsStateImpl
        >
    implements _$$HardwarePackingItemsStateImplCopyWith<$Res> {
  __$$HardwarePackingItemsStateImplCopyWithImpl(
    _$HardwarePackingItemsStateImpl _value,
    $Res Function(_$HardwarePackingItemsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HardwarePackingItemsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = freezed,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? error = freezed,
  }) {
    return _then(
      _$HardwarePackingItemsStateImpl(
        response:
            freezed == response
                ? _value.response
                : response // ignore: cast_nullable_to_non_nullable
                    as HardwarePackingItem?,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        isSuccess:
            null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                    as bool,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as Failure?,
      ),
    );
  }
}

/// @nodoc

class _$HardwarePackingItemsStateImpl implements _HardwarePackingItemsState {
  const _$HardwarePackingItemsStateImpl({
    this.response,
    required this.isLoading,
    required this.isSuccess,
    this.error,
  });

  @override
  final HardwarePackingItem? response;
  @override
  final bool isLoading;
  @override
  final bool isSuccess;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'HardwarePackingItemsState(response: $response, isLoading: $isLoading, isSuccess: $isSuccess, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HardwarePackingItemsStateImpl &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, response, isLoading, isSuccess, error);

  /// Create a copy of HardwarePackingItemsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HardwarePackingItemsStateImplCopyWith<_$HardwarePackingItemsStateImpl>
  get copyWith => __$$HardwarePackingItemsStateImplCopyWithImpl<
    _$HardwarePackingItemsStateImpl
  >(this, _$identity);
}

abstract class _HardwarePackingItemsState implements HardwarePackingItemsState {
  const factory _HardwarePackingItemsState({
    final HardwarePackingItem? response,
    required final bool isLoading,
    required final bool isSuccess,
    final Failure? error,
  }) = _$HardwarePackingItemsStateImpl;

  @override
  HardwarePackingItem? get response;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  Failure? get error;

  /// Create a copy of HardwarePackingItemsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HardwarePackingItemsStateImplCopyWith<_$HardwarePackingItemsStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
