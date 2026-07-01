// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_hardware_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateHardwareState {
  HardwarePacking get form => throw _privateConstructorUsedError;
  List<HardwareItem> get lines => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  HardwareView get view => throw _privateConstructorUsedError;
  bool get isModified => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateHardwareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateHardwareStateCopyWith<CreateHardwareState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateHardwareStateCopyWith<$Res> {
  factory $CreateHardwareStateCopyWith(
    CreateHardwareState value,
    $Res Function(CreateHardwareState) then,
  ) = _$CreateHardwareStateCopyWithImpl<$Res, CreateHardwareState>;
  @useResult
  $Res call({
    HardwarePacking form,
    List<HardwareItem> lines,
    bool isLoading,
    bool isSuccess,
    HardwareView view,
    bool isModified,
    String? successMsg,
    Failure? error,
  });

  $HardwarePackingCopyWith<$Res> get form;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreateHardwareStateCopyWithImpl<$Res, $Val extends CreateHardwareState>
    implements $CreateHardwareStateCopyWith<$Res> {
  _$CreateHardwareStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateHardwareState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? lines = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? view = null,
    Object? isModified = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            form:
                null == form
                    ? _value.form
                    : form // ignore: cast_nullable_to_non_nullable
                        as HardwarePacking,
            lines:
                null == lines
                    ? _value.lines
                    : lines // ignore: cast_nullable_to_non_nullable
                        as List<HardwareItem>,
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
                        as HardwareView,
            isModified:
                null == isModified
                    ? _value.isModified
                    : isModified // ignore: cast_nullable_to_non_nullable
                        as bool,
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

  /// Create a copy of CreateHardwareState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HardwarePackingCopyWith<$Res> get form {
    return $HardwarePackingCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreateHardwareState
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
abstract class _$$CreateHardwareStateImplCopyWith<$Res>
    implements $CreateHardwareStateCopyWith<$Res> {
  factory _$$CreateHardwareStateImplCopyWith(
    _$CreateHardwareStateImpl value,
    $Res Function(_$CreateHardwareStateImpl) then,
  ) = __$$CreateHardwareStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    HardwarePacking form,
    List<HardwareItem> lines,
    bool isLoading,
    bool isSuccess,
    HardwareView view,
    bool isModified,
    String? successMsg,
    Failure? error,
  });

  @override
  $HardwarePackingCopyWith<$Res> get form;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreateHardwareStateImplCopyWithImpl<$Res>
    extends _$CreateHardwareStateCopyWithImpl<$Res, _$CreateHardwareStateImpl>
    implements _$$CreateHardwareStateImplCopyWith<$Res> {
  __$$CreateHardwareStateImplCopyWithImpl(
    _$CreateHardwareStateImpl _value,
    $Res Function(_$CreateHardwareStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateHardwareState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? lines = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? view = null,
    Object? isModified = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$CreateHardwareStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as HardwarePacking,
        lines:
            null == lines
                ? _value._lines
                : lines // ignore: cast_nullable_to_non_nullable
                    as List<HardwareItem>,
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
                    as HardwareView,
        isModified:
            null == isModified
                ? _value.isModified
                : isModified // ignore: cast_nullable_to_non_nullable
                    as bool,
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

class _$CreateHardwareStateImpl implements _CreateHardwareState {
  const _$CreateHardwareStateImpl({
    required this.form,
    required final List<HardwareItem> lines,
    required this.isLoading,
    required this.isSuccess,
    required this.view,
    this.isModified = false,
    this.successMsg,
    this.error,
  }) : _lines = lines;

  @override
  final HardwarePacking form;
  final List<HardwareItem> _lines;
  @override
  List<HardwareItem> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  final bool isLoading;
  @override
  final bool isSuccess;
  @override
  final HardwareView view;
  @override
  @JsonKey()
  final bool isModified;
  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreateHardwareState(form: $form, lines: $lines, isLoading: $isLoading, isSuccess: $isSuccess, view: $view, isModified: $isModified, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateHardwareStateImpl &&
            (identical(other.form, form) || other.form == form) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.view, view) || other.view == view) &&
            (identical(other.isModified, isModified) ||
                other.isModified == isModified) &&
            (identical(other.successMsg, successMsg) ||
                other.successMsg == successMsg) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    form,
    const DeepCollectionEquality().hash(_lines),
    isLoading,
    isSuccess,
    view,
    isModified,
    successMsg,
    error,
  );

  /// Create a copy of CreateHardwareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateHardwareStateImplCopyWith<_$CreateHardwareStateImpl> get copyWith =>
      __$$CreateHardwareStateImplCopyWithImpl<_$CreateHardwareStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateHardwareState implements CreateHardwareState {
  const factory _CreateHardwareState({
    required final HardwarePacking form,
    required final List<HardwareItem> lines,
    required final bool isLoading,
    required final bool isSuccess,
    required final HardwareView view,
    final bool isModified,
    final String? successMsg,
    final Failure? error,
  }) = _$CreateHardwareStateImpl;

  @override
  HardwarePacking get form;
  @override
  List<HardwareItem> get lines;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  HardwareView get view;
  @override
  bool get isModified;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreateHardwareState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateHardwareStateImplCopyWith<_$CreateHardwareStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
