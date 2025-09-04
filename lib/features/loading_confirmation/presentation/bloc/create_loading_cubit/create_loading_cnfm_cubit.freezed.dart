// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_loading_cnfm_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateLaodingCnfmState {
  LoadingCnfmForm get form => throw _privateConstructorUsedError;
  List<ItemModel> get listitems => throw _privateConstructorUsedError;
  ItemModel get items => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  LoadingView get view => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateLaodingCnfmState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateLaodingCnfmStateCopyWith<CreateLaodingCnfmState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateLaodingCnfmStateCopyWith<$Res> {
  factory $CreateLaodingCnfmStateCopyWith(
    CreateLaodingCnfmState value,
    $Res Function(CreateLaodingCnfmState) then,
  ) = _$CreateLaodingCnfmStateCopyWithImpl<$Res, CreateLaodingCnfmState>;
  @useResult
  $Res call({
    LoadingCnfmForm form,
    List<ItemModel> listitems,
    ItemModel items,
    bool isLoading,
    bool isSuccess,
    LoadingView view,
    String? successMsg,
    Failure? error,
  });

  $LoadingCnfmFormCopyWith<$Res> get form;
  $ItemModelCopyWith<$Res> get items;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreateLaodingCnfmStateCopyWithImpl<
  $Res,
  $Val extends CreateLaodingCnfmState
>
    implements $CreateLaodingCnfmStateCopyWith<$Res> {
  _$CreateLaodingCnfmStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateLaodingCnfmState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? listitems = null,
    Object? items = null,
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
                        as LoadingCnfmForm,
            listitems:
                null == listitems
                    ? _value.listitems
                    : listitems // ignore: cast_nullable_to_non_nullable
                        as List<ItemModel>,
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as ItemModel,
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
                        as LoadingView,
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

  /// Create a copy of CreateLaodingCnfmState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoadingCnfmFormCopyWith<$Res> get form {
    return $LoadingCnfmFormCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreateLaodingCnfmState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ItemModelCopyWith<$Res> get items {
    return $ItemModelCopyWith<$Res>(_value.items, (value) {
      return _then(_value.copyWith(items: value) as $Val);
    });
  }

  /// Create a copy of CreateLaodingCnfmState
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
abstract class _$$CreateLaodingCnfmStateImplCopyWith<$Res>
    implements $CreateLaodingCnfmStateCopyWith<$Res> {
  factory _$$CreateLaodingCnfmStateImplCopyWith(
    _$CreateLaodingCnfmStateImpl value,
    $Res Function(_$CreateLaodingCnfmStateImpl) then,
  ) = __$$CreateLaodingCnfmStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoadingCnfmForm form,
    List<ItemModel> listitems,
    ItemModel items,
    bool isLoading,
    bool isSuccess,
    LoadingView view,
    String? successMsg,
    Failure? error,
  });

  @override
  $LoadingCnfmFormCopyWith<$Res> get form;
  @override
  $ItemModelCopyWith<$Res> get items;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreateLaodingCnfmStateImplCopyWithImpl<$Res>
    extends
        _$CreateLaodingCnfmStateCopyWithImpl<$Res, _$CreateLaodingCnfmStateImpl>
    implements _$$CreateLaodingCnfmStateImplCopyWith<$Res> {
  __$$CreateLaodingCnfmStateImplCopyWithImpl(
    _$CreateLaodingCnfmStateImpl _value,
    $Res Function(_$CreateLaodingCnfmStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateLaodingCnfmState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? listitems = null,
    Object? items = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? view = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$CreateLaodingCnfmStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as LoadingCnfmForm,
        listitems:
            null == listitems
                ? _value._listitems
                : listitems // ignore: cast_nullable_to_non_nullable
                    as List<ItemModel>,
        items:
            null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                    as ItemModel,
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
                    as LoadingView,
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

class _$CreateLaodingCnfmStateImpl implements _CreateLaodingCnfmState {
  const _$CreateLaodingCnfmStateImpl({
    required this.form,
    required final List<ItemModel> listitems,
    required this.items,
    required this.isLoading,
    required this.isSuccess,
    required this.view,
    this.successMsg,
    this.error,
  }) : _listitems = listitems;

  @override
  final LoadingCnfmForm form;
  final List<ItemModel> _listitems;
  @override
  List<ItemModel> get listitems {
    if (_listitems is EqualUnmodifiableListView) return _listitems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listitems);
  }

  @override
  final ItemModel items;
  @override
  final bool isLoading;
  @override
  final bool isSuccess;
  @override
  final LoadingView view;
  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreateLaodingCnfmState(form: $form, listitems: $listitems, items: $items, isLoading: $isLoading, isSuccess: $isSuccess, view: $view, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateLaodingCnfmStateImpl &&
            (identical(other.form, form) || other.form == form) &&
            const DeepCollectionEquality().equals(
              other._listitems,
              _listitems,
            ) &&
            (identical(other.items, items) || other.items == items) &&
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
    const DeepCollectionEquality().hash(_listitems),
    items,
    isLoading,
    isSuccess,
    view,
    successMsg,
    error,
  );

  /// Create a copy of CreateLaodingCnfmState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateLaodingCnfmStateImplCopyWith<_$CreateLaodingCnfmStateImpl>
  get copyWith =>
      __$$CreateLaodingCnfmStateImplCopyWithImpl<_$CreateLaodingCnfmStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateLaodingCnfmState implements CreateLaodingCnfmState {
  const factory _CreateLaodingCnfmState({
    required final LoadingCnfmForm form,
    required final List<ItemModel> listitems,
    required final ItemModel items,
    required final bool isLoading,
    required final bool isSuccess,
    required final LoadingView view,
    final String? successMsg,
    final Failure? error,
  }) = _$CreateLaodingCnfmStateImpl;

  @override
  LoadingCnfmForm get form;
  @override
  List<ItemModel> get listitems;
  @override
  ItemModel get items;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  LoadingView get view;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreateLaodingCnfmState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateLaodingCnfmStateImplCopyWith<_$CreateLaodingCnfmStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
