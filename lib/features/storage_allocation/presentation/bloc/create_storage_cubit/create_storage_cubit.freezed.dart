// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_storage_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateStorageState {
  Storage get form => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  StorageView get view => throw _privateConstructorUsedError;
  PalletDetails get pallet => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateStorageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateStorageStateCopyWith<CreateStorageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateStorageStateCopyWith<$Res> {
  factory $CreateStorageStateCopyWith(
    CreateStorageState value,
    $Res Function(CreateStorageState) then,
  ) = _$CreateStorageStateCopyWithImpl<$Res, CreateStorageState>;
  @useResult
  $Res call({
    Storage form,
    bool isLoading,
    bool isSuccess,
    StorageView view,
    PalletDetails pallet,
    String? successMsg,
    Failure? error,
  });

  $StorageCopyWith<$Res> get form;
  $PalletDetailsCopyWith<$Res> get pallet;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreateStorageStateCopyWithImpl<$Res, $Val extends CreateStorageState>
    implements $CreateStorageStateCopyWith<$Res> {
  _$CreateStorageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateStorageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? view = null,
    Object? pallet = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            form:
                null == form
                    ? _value.form
                    : form // ignore: cast_nullable_to_non_nullable
                        as Storage,
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
                        as StorageView,
            pallet:
                null == pallet
                    ? _value.pallet
                    : pallet // ignore: cast_nullable_to_non_nullable
                        as PalletDetails,
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

  /// Create a copy of CreateStorageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StorageCopyWith<$Res> get form {
    return $StorageCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreateStorageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PalletDetailsCopyWith<$Res> get pallet {
    return $PalletDetailsCopyWith<$Res>(_value.pallet, (value) {
      return _then(_value.copyWith(pallet: value) as $Val);
    });
  }

  /// Create a copy of CreateStorageState
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
abstract class _$$CreateStorageStateImplCopyWith<$Res>
    implements $CreateStorageStateCopyWith<$Res> {
  factory _$$CreateStorageStateImplCopyWith(
    _$CreateStorageStateImpl value,
    $Res Function(_$CreateStorageStateImpl) then,
  ) = __$$CreateStorageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Storage form,
    bool isLoading,
    bool isSuccess,
    StorageView view,
    PalletDetails pallet,
    String? successMsg,
    Failure? error,
  });

  @override
  $StorageCopyWith<$Res> get form;
  @override
  $PalletDetailsCopyWith<$Res> get pallet;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreateStorageStateImplCopyWithImpl<$Res>
    extends _$CreateStorageStateCopyWithImpl<$Res, _$CreateStorageStateImpl>
    implements _$$CreateStorageStateImplCopyWith<$Res> {
  __$$CreateStorageStateImplCopyWithImpl(
    _$CreateStorageStateImpl _value,
    $Res Function(_$CreateStorageStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateStorageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? view = null,
    Object? pallet = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$CreateStorageStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as Storage,
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
                    as StorageView,
        pallet:
            null == pallet
                ? _value.pallet
                : pallet // ignore: cast_nullable_to_non_nullable
                    as PalletDetails,
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

class _$CreateStorageStateImpl implements _CreateStorageState {
  const _$CreateStorageStateImpl({
    required this.form,
    required this.isLoading,
    required this.isSuccess,
    required this.view,
    required this.pallet,
    this.successMsg,
    this.error,
  });

  @override
  final Storage form;
  @override
  final bool isLoading;
  @override
  final bool isSuccess;
  @override
  final StorageView view;
  @override
  final PalletDetails pallet;
  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreateStorageState(form: $form, isLoading: $isLoading, isSuccess: $isSuccess, view: $view, pallet: $pallet, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateStorageStateImpl &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.view, view) || other.view == view) &&
            (identical(other.pallet, pallet) || other.pallet == pallet) &&
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
    pallet,
    successMsg,
    error,
  );

  /// Create a copy of CreateStorageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateStorageStateImplCopyWith<_$CreateStorageStateImpl> get copyWith =>
      __$$CreateStorageStateImplCopyWithImpl<_$CreateStorageStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateStorageState implements CreateStorageState {
  const factory _CreateStorageState({
    required final Storage form,
    required final bool isLoading,
    required final bool isSuccess,
    required final StorageView view,
    required final PalletDetails pallet,
    final String? successMsg,
    final Failure? error,
  }) = _$CreateStorageStateImpl;

  @override
  Storage get form;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  StorageView get view;
  @override
  PalletDetails get pallet;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreateStorageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateStorageStateImplCopyWith<_$CreateStorageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
