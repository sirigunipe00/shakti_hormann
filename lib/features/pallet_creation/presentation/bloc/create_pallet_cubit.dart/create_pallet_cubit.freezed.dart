// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_pallet_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreatePalletState {
  PalletModel get form => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  List<PalletItems> get lines => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  PalletView get view => throw _privateConstructorUsedError;
  bool get isModified => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreatePalletState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePalletStateCopyWith<CreatePalletState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePalletStateCopyWith<$Res> {
  factory $CreatePalletStateCopyWith(
    CreatePalletState value,
    $Res Function(CreatePalletState) then,
  ) = _$CreatePalletStateCopyWithImpl<$Res, CreatePalletState>;
  @useResult
  $Res call({
    PalletModel form,
    bool isLoading,
    List<PalletItems> lines,
    bool isSuccess,
    PalletView view,
    bool isModified,
    String? successMsg,
    Failure? error,
  });

  $PalletModelCopyWith<$Res> get form;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreatePalletStateCopyWithImpl<$Res, $Val extends CreatePalletState>
    implements $CreatePalletStateCopyWith<$Res> {
  _$CreatePalletStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePalletState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? lines = null,
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
                        as PalletModel,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            lines:
                null == lines
                    ? _value.lines
                    : lines // ignore: cast_nullable_to_non_nullable
                        as List<PalletItems>,
            isSuccess:
                null == isSuccess
                    ? _value.isSuccess
                    : isSuccess // ignore: cast_nullable_to_non_nullable
                        as bool,
            view:
                null == view
                    ? _value.view
                    : view // ignore: cast_nullable_to_non_nullable
                        as PalletView,
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

  /// Create a copy of CreatePalletState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PalletModelCopyWith<$Res> get form {
    return $PalletModelCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreatePalletState
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
abstract class _$$CreatePalletStateImplCopyWith<$Res>
    implements $CreatePalletStateCopyWith<$Res> {
  factory _$$CreatePalletStateImplCopyWith(
    _$CreatePalletStateImpl value,
    $Res Function(_$CreatePalletStateImpl) then,
  ) = __$$CreatePalletStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PalletModel form,
    bool isLoading,
    List<PalletItems> lines,
    bool isSuccess,
    PalletView view,
    bool isModified,
    String? successMsg,
    Failure? error,
  });

  @override
  $PalletModelCopyWith<$Res> get form;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreatePalletStateImplCopyWithImpl<$Res>
    extends _$CreatePalletStateCopyWithImpl<$Res, _$CreatePalletStateImpl>
    implements _$$CreatePalletStateImplCopyWith<$Res> {
  __$$CreatePalletStateImplCopyWithImpl(
    _$CreatePalletStateImpl _value,
    $Res Function(_$CreatePalletStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatePalletState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? lines = null,
    Object? isSuccess = null,
    Object? view = null,
    Object? isModified = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$CreatePalletStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as PalletModel,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        lines:
            null == lines
                ? _value._lines
                : lines // ignore: cast_nullable_to_non_nullable
                    as List<PalletItems>,
        isSuccess:
            null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                    as bool,
        view:
            null == view
                ? _value.view
                : view // ignore: cast_nullable_to_non_nullable
                    as PalletView,
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

class _$CreatePalletStateImpl implements _CreatePalletState {
  const _$CreatePalletStateImpl({
    required this.form,
    required this.isLoading,
    required final List<PalletItems> lines,
    required this.isSuccess,
    required this.view,
    this.isModified = false,
    this.successMsg,
    this.error,
  }) : _lines = lines;

  @override
  final PalletModel form;
  @override
  final bool isLoading;
  final List<PalletItems> _lines;
  @override
  List<PalletItems> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  final bool isSuccess;
  @override
  final PalletView view;
  @override
  @JsonKey()
  final bool isModified;
  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreatePalletState(form: $form, isLoading: $isLoading, lines: $lines, isSuccess: $isSuccess, view: $view, isModified: $isModified, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePalletStateImpl &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
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
    isLoading,
    const DeepCollectionEquality().hash(_lines),
    isSuccess,
    view,
    isModified,
    successMsg,
    error,
  );

  /// Create a copy of CreatePalletState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePalletStateImplCopyWith<_$CreatePalletStateImpl> get copyWith =>
      __$$CreatePalletStateImplCopyWithImpl<_$CreatePalletStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreatePalletState implements CreatePalletState {
  const factory _CreatePalletState({
    required final PalletModel form,
    required final bool isLoading,
    required final List<PalletItems> lines,
    required final bool isSuccess,
    required final PalletView view,
    final bool isModified,
    final String? successMsg,
    final Failure? error,
  }) = _$CreatePalletStateImpl;

  @override
  PalletModel get form;
  @override
  bool get isLoading;
  @override
  List<PalletItems> get lines;
  @override
  bool get isSuccess;
  @override
  PalletView get view;
  @override
  bool get isModified;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreatePalletState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePalletStateImplCopyWith<_$CreatePalletStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
