// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgot_pswd_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ForgotPswdState {
  FormStateController get controller => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  Failure? get failure => throw _privateConstructorUsedError;

  /// Create a copy of ForgotPswdState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgotPswdStateCopyWith<ForgotPswdState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPswdStateCopyWith<$Res> {
  factory $ForgotPswdStateCopyWith(
          ForgotPswdState value, $Res Function(ForgotPswdState) then) =
      _$ForgotPswdStateCopyWithImpl<$Res, ForgotPswdState>;
  @useResult
  $Res call(
      {FormStateController controller,
      bool isLoading,
      bool isSuccess,
      Failure? failure});

  $FailureCopyWith<$Res>? get failure;
}

/// @nodoc
class _$ForgotPswdStateCopyWithImpl<$Res, $Val extends ForgotPswdState>
    implements $ForgotPswdStateCopyWith<$Res> {
  _$ForgotPswdStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgotPswdState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? controller = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? failure = freezed,
  }) {
    return _then(_value.copyWith(
      controller: null == controller
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as FormStateController,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
    ) as $Val);
  }

  /// Create a copy of ForgotPswdState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res>? get failure {
    if (_value.failure == null) {
      return null;
    }

    return $FailureCopyWith<$Res>(_value.failure!, (value) {
      return _then(_value.copyWith(failure: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ForgotPswdStateImplCopyWith<$Res>
    implements $ForgotPswdStateCopyWith<$Res> {
  factory _$$ForgotPswdStateImplCopyWith(_$ForgotPswdStateImpl value,
          $Res Function(_$ForgotPswdStateImpl) then) =
      __$$ForgotPswdStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FormStateController controller,
      bool isLoading,
      bool isSuccess,
      Failure? failure});

  @override
  $FailureCopyWith<$Res>? get failure;
}

/// @nodoc
class __$$ForgotPswdStateImplCopyWithImpl<$Res>
    extends _$ForgotPswdStateCopyWithImpl<$Res, _$ForgotPswdStateImpl>
    implements _$$ForgotPswdStateImplCopyWith<$Res> {
  __$$ForgotPswdStateImplCopyWithImpl(
      _$ForgotPswdStateImpl _value, $Res Function(_$ForgotPswdStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForgotPswdState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? controller = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? failure = freezed,
  }) {
    return _then(_$ForgotPswdStateImpl(
      controller: null == controller
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as FormStateController,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
    ));
  }
}

/// @nodoc

class _$ForgotPswdStateImpl extends _ForgotPswdState {
  const _$ForgotPswdStateImpl(
      {required this.controller,
      required this.isLoading,
      required this.isSuccess,
      this.failure})
      : super._();

  @override
  final FormStateController controller;
  @override
  final bool isLoading;
  @override
  final bool isSuccess;
  @override
  final Failure? failure;

  @override
  String toString() {
    return 'ForgotPswdState(controller: $controller, isLoading: $isLoading, isSuccess: $isSuccess, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPswdStateImpl &&
            (identical(other.controller, controller) ||
                other.controller == controller) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, controller, isLoading, isSuccess, failure);

  /// Create a copy of ForgotPswdState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPswdStateImplCopyWith<_$ForgotPswdStateImpl> get copyWith =>
      __$$ForgotPswdStateImplCopyWithImpl<_$ForgotPswdStateImpl>(
          this, _$identity);
}

abstract class _ForgotPswdState extends ForgotPswdState {
  const factory _ForgotPswdState(
      {required final FormStateController controller,
      required final bool isLoading,
      required final bool isSuccess,
      final Failure? failure}) = _$ForgotPswdStateImpl;
  const _ForgotPswdState._() : super._();

  @override
  FormStateController get controller;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  Failure? get failure;

  /// Create a copy of ForgotPswdState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPswdStateImplCopyWith<_$ForgotPswdStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
