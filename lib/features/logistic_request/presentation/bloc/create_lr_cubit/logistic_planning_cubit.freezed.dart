// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logistic_planning_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateLogisticState {
  LogisticPlanningForm get form => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  LogisticPlanningView get view => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateLogisticState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateLogisticStateCopyWith<CreateLogisticState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateLogisticStateCopyWith<$Res> {
  factory $CreateLogisticStateCopyWith(
    CreateLogisticState value,
    $Res Function(CreateLogisticState) then,
  ) = _$CreateLogisticStateCopyWithImpl<$Res, CreateLogisticState>;
  @useResult
  $Res call({
    LogisticPlanningForm form,
    bool isLoading,
    bool isSuccess,
    LogisticPlanningView view,
    String? successMsg,
    Failure? error,
  });

  $LogisticPlanningFormCopyWith<$Res> get form;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreateLogisticStateCopyWithImpl<$Res, $Val extends CreateLogisticState>
    implements $CreateLogisticStateCopyWith<$Res> {
  _$CreateLogisticStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateLogisticState
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
                        as LogisticPlanningForm,
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
                        as LogisticPlanningView,
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

  /// Create a copy of CreateLogisticState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LogisticPlanningFormCopyWith<$Res> get form {
    return $LogisticPlanningFormCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreateLogisticState
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
abstract class _$$CreateLogisticStateImplCopyWith<$Res>
    implements $CreateLogisticStateCopyWith<$Res> {
  factory _$$CreateLogisticStateImplCopyWith(
    _$CreateLogisticStateImpl value,
    $Res Function(_$CreateLogisticStateImpl) then,
  ) = __$$CreateLogisticStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LogisticPlanningForm form,
    bool isLoading,
    bool isSuccess,
    LogisticPlanningView view,
    String? successMsg,
    Failure? error,
  });

  @override
  $LogisticPlanningFormCopyWith<$Res> get form;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreateLogisticStateImplCopyWithImpl<$Res>
    extends _$CreateLogisticStateCopyWithImpl<$Res, _$CreateLogisticStateImpl>
    implements _$$CreateLogisticStateImplCopyWith<$Res> {
  __$$CreateLogisticStateImplCopyWithImpl(
    _$CreateLogisticStateImpl _value,
    $Res Function(_$CreateLogisticStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateLogisticState
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
      _$CreateLogisticStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as LogisticPlanningForm,
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
                    as LogisticPlanningView,
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

class _$CreateLogisticStateImpl implements _CreateLogisticState {
  const _$CreateLogisticStateImpl({
    required this.form,
    required this.isLoading,
    required this.isSuccess,
    required this.view,
    this.successMsg,
    this.error,
  });

  @override
  final LogisticPlanningForm form;
  @override
  final bool isLoading;
  @override
  final bool isSuccess;
  @override
  final LogisticPlanningView view;
  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreateLogisticState(form: $form, isLoading: $isLoading, isSuccess: $isSuccess, view: $view, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateLogisticStateImpl &&
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

  /// Create a copy of CreateLogisticState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateLogisticStateImplCopyWith<_$CreateLogisticStateImpl> get copyWith =>
      __$$CreateLogisticStateImplCopyWithImpl<_$CreateLogisticStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateLogisticState implements CreateLogisticState {
  const factory _CreateLogisticState({
    required final LogisticPlanningForm form,
    required final bool isLoading,
    required final bool isSuccess,
    required final LogisticPlanningView view,
    final String? successMsg,
    final Failure? error,
  }) = _$CreateLogisticStateImpl;

  @override
  LogisticPlanningForm get form;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  LogisticPlanningView get view;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreateLogisticState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateLogisticStateImplCopyWith<_$CreateLogisticStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
