// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_transport_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateTransportState {
  TransportConfirmationForm get form => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  TransportView get view => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateTransportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateTransportStateCopyWith<CreateTransportState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTransportStateCopyWith<$Res> {
  factory $CreateTransportStateCopyWith(
    CreateTransportState value,
    $Res Function(CreateTransportState) then,
  ) = _$CreateTransportStateCopyWithImpl<$Res, CreateTransportState>;
  @useResult
  $Res call({
    TransportConfirmationForm form,
    bool isLoading,
    bool isSuccess,
    TransportView view,
    String? successMsg,
    Failure? error,
  });

  $TransportConfirmationFormCopyWith<$Res> get form;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreateTransportStateCopyWithImpl<
  $Res,
  $Val extends CreateTransportState
>
    implements $CreateTransportStateCopyWith<$Res> {
  _$CreateTransportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateTransportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? view = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            form:
                null == form
                    ? _value.form
                    : form // ignore: cast_nullable_to_non_nullable
                        as TransportConfirmationForm,
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
            view:
                null == view
                    ? _value.view
                    : view // ignore: cast_nullable_to_non_nullable
                        as TransportView,
            successMsg:
                freezed == successMsg
                    ? _value.successMsg
                    : successMsg // ignore: cast_nullable_to_non_nullable
                        as String?,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as Failure?,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateTransportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransportConfirmationFormCopyWith<$Res> get form {
    return $TransportConfirmationFormCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreateTransportState
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
abstract class _$$CreateTransportStateImplCopyWith<$Res>
    implements $CreateTransportStateCopyWith<$Res> {
  factory _$$CreateTransportStateImplCopyWith(
    _$CreateTransportStateImpl value,
    $Res Function(_$CreateTransportStateImpl) then,
  ) = __$$CreateTransportStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TransportConfirmationForm form,
    bool isLoading,
    bool isSuccess,
    TransportView view,
    String? successMsg,
    Failure? error,
  });

  @override
  $TransportConfirmationFormCopyWith<$Res> get form;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreateTransportStateImplCopyWithImpl<$Res>
    extends _$CreateTransportStateCopyWithImpl<$Res, _$CreateTransportStateImpl>
    implements _$$CreateTransportStateImplCopyWith<$Res> {
  __$$CreateTransportStateImplCopyWithImpl(
    _$CreateTransportStateImpl _value,
    $Res Function(_$CreateTransportStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateTransportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? view = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$CreateTransportStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as TransportConfirmationForm,
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
        view:
            null == view
                ? _value.view
                : view // ignore: cast_nullable_to_non_nullable
                    as TransportView,
        successMsg:
            freezed == successMsg
                ? _value.successMsg
                : successMsg // ignore: cast_nullable_to_non_nullable
                    as String?,
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

class _$CreateTransportStateImpl implements _CreateTransportState {
  const _$CreateTransportStateImpl({
    required this.form,
    required this.isLoading,
    required this.isSuccess,
    required this.view,
    this.successMsg,
    this.error,
  });

  @override
  final TransportConfirmationForm form;
  @override
  final bool isLoading;
  @override
  final bool isSuccess;
  @override
  final TransportView view;
  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreateTransportState(form: $form, isLoading: $isLoading, isSuccess: $isSuccess, view: $view, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTransportStateImpl &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.view, view) || other.view == view) &&
            (identical(other.successMsg, successMsg) ||
                other.successMsg == successMsg) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    form,
    isLoading,
    isSuccess,
    view,
    successMsg,
    error,
  );

  /// Create a copy of CreateTransportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTransportStateImplCopyWith<_$CreateTransportStateImpl>
  get copyWith =>
      __$$CreateTransportStateImplCopyWithImpl<_$CreateTransportStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateTransportState implements CreateTransportState {
  const factory _CreateTransportState({
    required final TransportConfirmationForm form,
    required final bool isLoading,
    required final bool isSuccess,
    required final TransportView view,
    final String? successMsg,
    final Failure? error,
  }) = _$CreateTransportStateImpl;

  @override
  TransportConfirmationForm get form;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  TransportView get view;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreateTransportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateTransportStateImplCopyWith<_$CreateTransportStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
