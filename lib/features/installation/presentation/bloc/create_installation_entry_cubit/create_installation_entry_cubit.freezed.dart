// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_installation_entry_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateInstallationState {
  InstallationModel get form => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  List<InstallationLineItems> get newLines =>
      throw _privateConstructorUsedError;
  List<InstallationLineItems> get lines => throw _privateConstructorUsedError;
  InstallationView get view => throw _privateConstructorUsedError;
  bool get isModified => throw _privateConstructorUsedError;
  bool get isUpdated => throw _privateConstructorUsedError;
  bool get isPrintLoading => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateInstallationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateInstallationStateCopyWith<CreateInstallationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateInstallationStateCopyWith<$Res> {
  factory $CreateInstallationStateCopyWith(
    CreateInstallationState value,
    $Res Function(CreateInstallationState) then,
  ) = _$CreateInstallationStateCopyWithImpl<$Res, CreateInstallationState>;
  @useResult
  $Res call({
    InstallationModel form,
    bool isLoading,
    bool isSuccess,
    List<InstallationLineItems> newLines,
    List<InstallationLineItems> lines,
    InstallationView view,
    bool isModified,
    bool isUpdated,
    bool isPrintLoading,
    String? successMsg,
    Failure? error,
  });

  $InstallationModelCopyWith<$Res> get form;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreateInstallationStateCopyWithImpl<
  $Res,
  $Val extends CreateInstallationState
>
    implements $CreateInstallationStateCopyWith<$Res> {
  _$CreateInstallationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateInstallationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? newLines = null,
    Object? lines = null,
    Object? view = null,
    Object? isModified = null,
    Object? isUpdated = null,
    Object? isPrintLoading = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            form:
                null == form
                    ? _value.form
                    : form // ignore: cast_nullable_to_non_nullable
                        as InstallationModel,
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
            newLines:
                null == newLines
                    ? _value.newLines
                    : newLines // ignore: cast_nullable_to_non_nullable
                        as List<InstallationLineItems>,
            lines:
                null == lines
                    ? _value.lines
                    : lines // ignore: cast_nullable_to_non_nullable
                        as List<InstallationLineItems>,
            view:
                null == view
                    ? _value.view
                    : view // ignore: cast_nullable_to_non_nullable
                        as InstallationView,
            isModified:
                null == isModified
                    ? _value.isModified
                    : isModified // ignore: cast_nullable_to_non_nullable
                        as bool,
            isUpdated:
                null == isUpdated
                    ? _value.isUpdated
                    : isUpdated // ignore: cast_nullable_to_non_nullable
                        as bool,
            isPrintLoading:
                null == isPrintLoading
                    ? _value.isPrintLoading
                    : isPrintLoading // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of CreateInstallationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InstallationModelCopyWith<$Res> get form {
    return $InstallationModelCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreateInstallationState
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
abstract class _$$CreateInstallationStateImplCopyWith<$Res>
    implements $CreateInstallationStateCopyWith<$Res> {
  factory _$$CreateInstallationStateImplCopyWith(
    _$CreateInstallationStateImpl value,
    $Res Function(_$CreateInstallationStateImpl) then,
  ) = __$$CreateInstallationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    InstallationModel form,
    bool isLoading,
    bool isSuccess,
    List<InstallationLineItems> newLines,
    List<InstallationLineItems> lines,
    InstallationView view,
    bool isModified,
    bool isUpdated,
    bool isPrintLoading,
    String? successMsg,
    Failure? error,
  });

  @override
  $InstallationModelCopyWith<$Res> get form;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreateInstallationStateImplCopyWithImpl<$Res>
    extends
        _$CreateInstallationStateCopyWithImpl<
          $Res,
          _$CreateInstallationStateImpl
        >
    implements _$$CreateInstallationStateImplCopyWith<$Res> {
  __$$CreateInstallationStateImplCopyWithImpl(
    _$CreateInstallationStateImpl _value,
    $Res Function(_$CreateInstallationStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateInstallationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? newLines = null,
    Object? lines = null,
    Object? view = null,
    Object? isModified = null,
    Object? isUpdated = null,
    Object? isPrintLoading = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$CreateInstallationStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as InstallationModel,
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
        newLines:
            null == newLines
                ? _value._newLines
                : newLines // ignore: cast_nullable_to_non_nullable
                    as List<InstallationLineItems>,
        lines:
            null == lines
                ? _value._lines
                : lines // ignore: cast_nullable_to_non_nullable
                    as List<InstallationLineItems>,
        view:
            null == view
                ? _value.view
                : view // ignore: cast_nullable_to_non_nullable
                    as InstallationView,
        isModified:
            null == isModified
                ? _value.isModified
                : isModified // ignore: cast_nullable_to_non_nullable
                    as bool,
        isUpdated:
            null == isUpdated
                ? _value.isUpdated
                : isUpdated // ignore: cast_nullable_to_non_nullable
                    as bool,
        isPrintLoading:
            null == isPrintLoading
                ? _value.isPrintLoading
                : isPrintLoading // ignore: cast_nullable_to_non_nullable
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

class _$CreateInstallationStateImpl implements _CreateInstallationState {
  const _$CreateInstallationStateImpl({
    required this.form,
    required this.isLoading,
    required this.isSuccess,
    final List<InstallationLineItems> newLines = const [],
    required final List<InstallationLineItems> lines,
    required this.view,
    this.isModified = false,
    this.isUpdated = false,
    this.isPrintLoading = false,
    this.successMsg,
    this.error,
  }) : _newLines = newLines,
       _lines = lines;

  @override
  final InstallationModel form;
  @override
  final bool isLoading;
  @override
  final bool isSuccess;
  final List<InstallationLineItems> _newLines;
  @override
  @JsonKey()
  List<InstallationLineItems> get newLines {
    if (_newLines is EqualUnmodifiableListView) return _newLines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newLines);
  }

  final List<InstallationLineItems> _lines;
  @override
  List<InstallationLineItems> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  final InstallationView view;
  @override
  @JsonKey()
  final bool isModified;
  @override
  @JsonKey()
  final bool isUpdated;
  @override
  @JsonKey()
  final bool isPrintLoading;
  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreateInstallationState(form: $form, isLoading: $isLoading, isSuccess: $isSuccess, newLines: $newLines, lines: $lines, view: $view, isModified: $isModified, isUpdated: $isUpdated, isPrintLoading: $isPrintLoading, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateInstallationStateImpl &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            const DeepCollectionEquality().equals(other._newLines, _newLines) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            (identical(other.view, view) || other.view == view) &&
            (identical(other.isModified, isModified) ||
                other.isModified == isModified) &&
            (identical(other.isUpdated, isUpdated) ||
                other.isUpdated == isUpdated) &&
            (identical(other.isPrintLoading, isPrintLoading) ||
                other.isPrintLoading == isPrintLoading) &&
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
    const DeepCollectionEquality().hash(_newLines),
    const DeepCollectionEquality().hash(_lines),
    view,
    isModified,
    isUpdated,
    isPrintLoading,
    successMsg,
    error,
  );

  /// Create a copy of CreateInstallationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateInstallationStateImplCopyWith<_$CreateInstallationStateImpl>
  get copyWith => __$$CreateInstallationStateImplCopyWithImpl<
    _$CreateInstallationStateImpl
  >(this, _$identity);
}

abstract class _CreateInstallationState implements CreateInstallationState {
  const factory _CreateInstallationState({
    required final InstallationModel form,
    required final bool isLoading,
    required final bool isSuccess,
    final List<InstallationLineItems> newLines,
    required final List<InstallationLineItems> lines,
    required final InstallationView view,
    final bool isModified,
    final bool isUpdated,
    final bool isPrintLoading,
    final String? successMsg,
    final Failure? error,
  }) = _$CreateInstallationStateImpl;

  @override
  InstallationModel get form;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  List<InstallationLineItems> get newLines;
  @override
  List<InstallationLineItems> get lines;
  @override
  InstallationView get view;
  @override
  bool get isModified;
  @override
  bool get isUpdated;
  @override
  bool get isPrintLoading;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreateInstallationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateInstallationStateImplCopyWith<_$CreateInstallationStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
