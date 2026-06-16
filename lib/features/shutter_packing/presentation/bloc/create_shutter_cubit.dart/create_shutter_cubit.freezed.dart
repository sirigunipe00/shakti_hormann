// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_shutter_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateShutterState {
  ShutterPacking get form => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  List<ShutterLines> get lines => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  List<ShutterLines> get newLines => throw _privateConstructorUsedError;
  ShutterView get view => throw _privateConstructorUsedError;
  bool get isModified => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateShutterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateShutterStateCopyWith<CreateShutterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateShutterStateCopyWith<$Res> {
  factory $CreateShutterStateCopyWith(
    CreateShutterState value,
    $Res Function(CreateShutterState) then,
  ) = _$CreateShutterStateCopyWithImpl<$Res, CreateShutterState>;
  @useResult
  $Res call({
    ShutterPacking form,
    bool isLoading,
    List<ShutterLines> lines,
    bool isSuccess,
    List<ShutterLines> newLines,
    ShutterView view,
    bool isModified,
    String? successMsg,
    Failure? error,
  });

  $ShutterPackingCopyWith<$Res> get form;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreateShutterStateCopyWithImpl<$Res, $Val extends CreateShutterState>
    implements $CreateShutterStateCopyWith<$Res> {
  _$CreateShutterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateShutterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? lines = null,
    Object? isSuccess = null,
    Object? newLines = null,
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
                        as ShutterPacking,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            lines:
                null == lines
                    ? _value.lines
                    : lines // ignore: cast_nullable_to_non_nullable
                        as List<ShutterLines>,
            isSuccess:
                null == isSuccess
                    ? _value.isSuccess
                    : isSuccess // ignore: cast_nullable_to_non_nullable
                        as bool,
            newLines:
                null == newLines
                    ? _value.newLines
                    : newLines // ignore: cast_nullable_to_non_nullable
                        as List<ShutterLines>,
            view:
                null == view
                    ? _value.view
                    : view // ignore: cast_nullable_to_non_nullable
                        as ShutterView,
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

  /// Create a copy of CreateShutterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShutterPackingCopyWith<$Res> get form {
    return $ShutterPackingCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreateShutterState
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
abstract class _$$CreateShutterStateImplCopyWith<$Res>
    implements $CreateShutterStateCopyWith<$Res> {
  factory _$$CreateShutterStateImplCopyWith(
    _$CreateShutterStateImpl value,
    $Res Function(_$CreateShutterStateImpl) then,
  ) = __$$CreateShutterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ShutterPacking form,
    bool isLoading,
    List<ShutterLines> lines,
    bool isSuccess,
    List<ShutterLines> newLines,
    ShutterView view,
    bool isModified,
    String? successMsg,
    Failure? error,
  });

  @override
  $ShutterPackingCopyWith<$Res> get form;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreateShutterStateImplCopyWithImpl<$Res>
    extends _$CreateShutterStateCopyWithImpl<$Res, _$CreateShutterStateImpl>
    implements _$$CreateShutterStateImplCopyWith<$Res> {
  __$$CreateShutterStateImplCopyWithImpl(
    _$CreateShutterStateImpl _value,
    $Res Function(_$CreateShutterStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateShutterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? lines = null,
    Object? isSuccess = null,
    Object? newLines = null,
    Object? view = null,
    Object? isModified = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$CreateShutterStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as ShutterPacking,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        lines:
            null == lines
                ? _value._lines
                : lines // ignore: cast_nullable_to_non_nullable
                    as List<ShutterLines>,
        isSuccess:
            null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                    as bool,
        newLines:
            null == newLines
                ? _value._newLines
                : newLines // ignore: cast_nullable_to_non_nullable
                    as List<ShutterLines>,
        view:
            null == view
                ? _value.view
                : view // ignore: cast_nullable_to_non_nullable
                    as ShutterView,
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

class _$CreateShutterStateImpl implements _CreateShutterState {
  const _$CreateShutterStateImpl({
    required this.form,
    required this.isLoading,
    required final List<ShutterLines> lines,
    required this.isSuccess,
    final List<ShutterLines> newLines = const [],
    required this.view,
    this.isModified = false,
    this.successMsg,
    this.error,
  }) : _lines = lines,
       _newLines = newLines;

  @override
  final ShutterPacking form;
  @override
  final bool isLoading;
  final List<ShutterLines> _lines;
  @override
  List<ShutterLines> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  final bool isSuccess;
  final List<ShutterLines> _newLines;
  @override
  @JsonKey()
  List<ShutterLines> get newLines {
    if (_newLines is EqualUnmodifiableListView) return _newLines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newLines);
  }

  @override
  final ShutterView view;
  @override
  @JsonKey()
  final bool isModified;
  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreateShutterState(form: $form, isLoading: $isLoading, lines: $lines, isSuccess: $isSuccess, newLines: $newLines, view: $view, isModified: $isModified, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateShutterStateImpl &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            const DeepCollectionEquality().equals(other._newLines, _newLines) &&
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
    isLoading,
    const DeepCollectionEquality().hash(_lines),
    isSuccess,
    const DeepCollectionEquality().hash(_newLines),
    view,
    isModified,
    successMsg,
    error,
  );

  /// Create a copy of CreateShutterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateShutterStateImplCopyWith<_$CreateShutterStateImpl> get copyWith =>
      __$$CreateShutterStateImplCopyWithImpl<_$CreateShutterStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateShutterState implements CreateShutterState {
  const factory _CreateShutterState({
    required final ShutterPacking form,
    required final bool isLoading,
    required final List<ShutterLines> lines,
    required final bool isSuccess,
    final List<ShutterLines> newLines,
    required final ShutterView view,
    final bool isModified,
    final String? successMsg,
    final Failure? error,
  }) = _$CreateShutterStateImpl;

  @override
  ShutterPacking get form;
  @override
  bool get isLoading;
  @override
  List<ShutterLines> get lines;
  @override
  bool get isSuccess;
  @override
  List<ShutterLines> get newLines;
  @override
  ShutterView get view;
  @override
  bool get isModified;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreateShutterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateShutterStateImplCopyWith<_$CreateShutterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
