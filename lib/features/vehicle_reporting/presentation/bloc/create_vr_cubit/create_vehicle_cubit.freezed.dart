// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_vehicle_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateVehicleState {
  VehicleReportingForm get form => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  VehicleView get view => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateVehicleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateVehicleStateCopyWith<CreateVehicleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateVehicleStateCopyWith<$Res> {
  factory $CreateVehicleStateCopyWith(
    CreateVehicleState value,
    $Res Function(CreateVehicleState) then,
  ) = _$CreateVehicleStateCopyWithImpl<$Res, CreateVehicleState>;
  @useResult
  $Res call({
    VehicleReportingForm form,
    bool isLoading,
    bool isSuccess,
    VehicleView view,
    String? successMsg,
    Failure? error,
  });

  $VehicleReportingFormCopyWith<$Res> get form;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreateVehicleStateCopyWithImpl<$Res, $Val extends CreateVehicleState>
    implements $CreateVehicleStateCopyWith<$Res> {
  _$CreateVehicleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateVehicleState
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
                        as VehicleReportingForm,
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
                        as VehicleView,
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

  /// Create a copy of CreateVehicleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VehicleReportingFormCopyWith<$Res> get form {
    return $VehicleReportingFormCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreateVehicleState
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
abstract class _$$CreateVehicleStateImplCopyWith<$Res>
    implements $CreateVehicleStateCopyWith<$Res> {
  factory _$$CreateVehicleStateImplCopyWith(
    _$CreateVehicleStateImpl value,
    $Res Function(_$CreateVehicleStateImpl) then,
  ) = __$$CreateVehicleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    VehicleReportingForm form,
    bool isLoading,
    bool isSuccess,
    VehicleView view,
    String? successMsg,
    Failure? error,
  });

  @override
  $VehicleReportingFormCopyWith<$Res> get form;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreateVehicleStateImplCopyWithImpl<$Res>
    extends _$CreateVehicleStateCopyWithImpl<$Res, _$CreateVehicleStateImpl>
    implements _$$CreateVehicleStateImplCopyWith<$Res> {
  __$$CreateVehicleStateImplCopyWithImpl(
    _$CreateVehicleStateImpl _value,
    $Res Function(_$CreateVehicleStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateVehicleState
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
      _$CreateVehicleStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as VehicleReportingForm,
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
                    as VehicleView,
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

class _$CreateVehicleStateImpl implements _CreateVehicleState {
  const _$CreateVehicleStateImpl({
    required this.form,
    required this.isLoading,
    required this.isSuccess,
    required this.view,
    this.successMsg,
    this.error,
  });

  @override
  final VehicleReportingForm form;
  @override
  final bool isLoading;
  @override
  final bool isSuccess;
  @override
  final VehicleView view;
  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreateVehicleState(form: $form, isLoading: $isLoading, isSuccess: $isSuccess, view: $view, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateVehicleStateImpl &&
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

  /// Create a copy of CreateVehicleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateVehicleStateImplCopyWith<_$CreateVehicleStateImpl> get copyWith =>
      __$$CreateVehicleStateImplCopyWithImpl<_$CreateVehicleStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateVehicleState implements CreateVehicleState {
  const factory _CreateVehicleState({
    required final VehicleReportingForm form,
    required final bool isLoading,
    required final bool isSuccess,
    required final VehicleView view,
    final String? successMsg,
    final Failure? error,
  }) = _$CreateVehicleStateImpl;

  @override
  VehicleReportingForm get form;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  VehicleView get view;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreateVehicleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateVehicleStateImplCopyWith<_$CreateVehicleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
