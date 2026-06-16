// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_frame_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateFrameState {
  FramePacking get form => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  List<FrameLines> get lines => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  List<FrameLines> get newLines => throw _privateConstructorUsedError;
  FrameView get view => throw _privateConstructorUsedError;
  bool get isModified => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateFrameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateFrameStateCopyWith<CreateFrameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateFrameStateCopyWith<$Res> {
  factory $CreateFrameStateCopyWith(
    CreateFrameState value,
    $Res Function(CreateFrameState) then,
  ) = _$CreateFrameStateCopyWithImpl<$Res, CreateFrameState>;
  @useResult
  $Res call({
    FramePacking form,
    bool isLoading,
    List<FrameLines> lines,
    bool isSuccess,
    List<FrameLines> newLines,
    FrameView view,
    bool isModified,
    String? successMsg,
    Failure? error,
  });

  $FramePackingCopyWith<$Res> get form;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreateFrameStateCopyWithImpl<$Res, $Val extends CreateFrameState>
    implements $CreateFrameStateCopyWith<$Res> {
  _$CreateFrameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateFrameState
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
                        as FramePacking,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            lines:
                null == lines
                    ? _value.lines
                    : lines // ignore: cast_nullable_to_non_nullable
                        as List<FrameLines>,
            isSuccess:
                null == isSuccess
                    ? _value.isSuccess
                    : isSuccess // ignore: cast_nullable_to_non_nullable
                        as bool,
            newLines:
                null == newLines
                    ? _value.newLines
                    : newLines // ignore: cast_nullable_to_non_nullable
                        as List<FrameLines>,
            view:
                null == view
                    ? _value.view
                    : view // ignore: cast_nullable_to_non_nullable
                        as FrameView,
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

  /// Create a copy of CreateFrameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FramePackingCopyWith<$Res> get form {
    return $FramePackingCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreateFrameState
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
abstract class _$$CreateFrameStateImplCopyWith<$Res>
    implements $CreateFrameStateCopyWith<$Res> {
  factory _$$CreateFrameStateImplCopyWith(
    _$CreateFrameStateImpl value,
    $Res Function(_$CreateFrameStateImpl) then,
  ) = __$$CreateFrameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    FramePacking form,
    bool isLoading,
    List<FrameLines> lines,
    bool isSuccess,
    List<FrameLines> newLines,
    FrameView view,
    bool isModified,
    String? successMsg,
    Failure? error,
  });

  @override
  $FramePackingCopyWith<$Res> get form;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreateFrameStateImplCopyWithImpl<$Res>
    extends _$CreateFrameStateCopyWithImpl<$Res, _$CreateFrameStateImpl>
    implements _$$CreateFrameStateImplCopyWith<$Res> {
  __$$CreateFrameStateImplCopyWithImpl(
    _$CreateFrameStateImpl _value,
    $Res Function(_$CreateFrameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateFrameState
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
      _$CreateFrameStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as FramePacking,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        lines:
            null == lines
                ? _value._lines
                : lines // ignore: cast_nullable_to_non_nullable
                    as List<FrameLines>,
        isSuccess:
            null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                    as bool,
        newLines:
            null == newLines
                ? _value._newLines
                : newLines // ignore: cast_nullable_to_non_nullable
                    as List<FrameLines>,
        view:
            null == view
                ? _value.view
                : view // ignore: cast_nullable_to_non_nullable
                    as FrameView,
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

class _$CreateFrameStateImpl implements _CreateFrameState {
  const _$CreateFrameStateImpl({
    required this.form,
    required this.isLoading,
    required final List<FrameLines> lines,
    required this.isSuccess,
    final List<FrameLines> newLines = const [],
    required this.view,
    this.isModified = false,
    this.successMsg,
    this.error,
  }) : _lines = lines,
       _newLines = newLines;

  @override
  final FramePacking form;
  @override
  final bool isLoading;
  final List<FrameLines> _lines;
  @override
  List<FrameLines> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  final bool isSuccess;
  final List<FrameLines> _newLines;
  @override
  @JsonKey()
  List<FrameLines> get newLines {
    if (_newLines is EqualUnmodifiableListView) return _newLines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newLines);
  }

  @override
  final FrameView view;
  @override
  @JsonKey()
  final bool isModified;
  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreateFrameState(form: $form, isLoading: $isLoading, lines: $lines, isSuccess: $isSuccess, newLines: $newLines, view: $view, isModified: $isModified, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateFrameStateImpl &&
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

  /// Create a copy of CreateFrameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateFrameStateImplCopyWith<_$CreateFrameStateImpl> get copyWith =>
      __$$CreateFrameStateImplCopyWithImpl<_$CreateFrameStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateFrameState implements CreateFrameState {
  const factory _CreateFrameState({
    required final FramePacking form,
    required final bool isLoading,
    required final List<FrameLines> lines,
    required final bool isSuccess,
    final List<FrameLines> newLines,
    required final FrameView view,
    final bool isModified,
    final String? successMsg,
    final Failure? error,
  }) = _$CreateFrameStateImpl;

  @override
  FramePacking get form;
  @override
  bool get isLoading;
  @override
  List<FrameLines> get lines;
  @override
  bool get isSuccess;
  @override
  List<FrameLines> get newLines;
  @override
  FrameView get view;
  @override
  bool get isModified;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreateFrameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateFrameStateImplCopyWith<_$CreateFrameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
