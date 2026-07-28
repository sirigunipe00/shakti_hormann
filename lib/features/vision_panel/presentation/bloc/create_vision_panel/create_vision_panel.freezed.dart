// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_vision_panel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateVisionPanelState {
  VisionModel get form => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  List<VisionItems> get items => throw _privateConstructorUsedError;
  List<VisionPanelEntryLines> get imageLines =>
      throw _privateConstructorUsedError;
  VisionView get view => throw _privateConstructorUsedError;
  bool get isModified => throw _privateConstructorUsedError;
  bool get isUpdated => throw _privateConstructorUsedError;
  bool get isPrintLoading => throw _privateConstructorUsedError;
  Set<int> get uploadedItemIndexes => throw _privateConstructorUsedError;
  String? get successMsg => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateVisionPanelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateVisionPanelStateCopyWith<CreateVisionPanelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateVisionPanelStateCopyWith<$Res> {
  factory $CreateVisionPanelStateCopyWith(
    CreateVisionPanelState value,
    $Res Function(CreateVisionPanelState) then,
  ) = _$CreateVisionPanelStateCopyWithImpl<$Res, CreateVisionPanelState>;
  @useResult
  $Res call({
    VisionModel form,
    bool isLoading,
    bool isSuccess,
    List<VisionItems> items,
    List<VisionPanelEntryLines> imageLines,
    VisionView view,
    bool isModified,
    bool isUpdated,
    bool isPrintLoading,
    Set<int> uploadedItemIndexes,
    String? successMsg,
    Failure? error,
  });

  $VisionModelCopyWith<$Res> get form;
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class _$CreateVisionPanelStateCopyWithImpl<
  $Res,
  $Val extends CreateVisionPanelState
>
    implements $CreateVisionPanelStateCopyWith<$Res> {
  _$CreateVisionPanelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateVisionPanelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? items = null,
    Object? imageLines = null,
    Object? view = null,
    Object? isModified = null,
    Object? isUpdated = null,
    Object? isPrintLoading = null,
    Object? uploadedItemIndexes = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            form:
                null == form
                    ? _value.form
                    : form // ignore: cast_nullable_to_non_nullable
                        as VisionModel,
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
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<VisionItems>,
            imageLines:
                null == imageLines
                    ? _value.imageLines
                    : imageLines // ignore: cast_nullable_to_non_nullable
                        as List<VisionPanelEntryLines>,
            view:
                null == view
                    ? _value.view
                    : view // ignore: cast_nullable_to_non_nullable
                        as VisionView,
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
            uploadedItemIndexes:
                null == uploadedItemIndexes
                    ? _value.uploadedItemIndexes
                    : uploadedItemIndexes // ignore: cast_nullable_to_non_nullable
                        as Set<int>,
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

  /// Create a copy of CreateVisionPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VisionModelCopyWith<$Res> get form {
    return $VisionModelCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }

  /// Create a copy of CreateVisionPanelState
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
abstract class _$$CreateVisionPanelStateImplCopyWith<$Res>
    implements $CreateVisionPanelStateCopyWith<$Res> {
  factory _$$CreateVisionPanelStateImplCopyWith(
    _$CreateVisionPanelStateImpl value,
    $Res Function(_$CreateVisionPanelStateImpl) then,
  ) = __$$CreateVisionPanelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    VisionModel form,
    bool isLoading,
    bool isSuccess,
    List<VisionItems> items,
    List<VisionPanelEntryLines> imageLines,
    VisionView view,
    bool isModified,
    bool isUpdated,
    bool isPrintLoading,
    Set<int> uploadedItemIndexes,
    String? successMsg,
    Failure? error,
  });

  @override
  $VisionModelCopyWith<$Res> get form;
  @override
  $FailureCopyWith<$Res>? get error;
}

/// @nodoc
class __$$CreateVisionPanelStateImplCopyWithImpl<$Res>
    extends
        _$CreateVisionPanelStateCopyWithImpl<$Res, _$CreateVisionPanelStateImpl>
    implements _$$CreateVisionPanelStateImplCopyWith<$Res> {
  __$$CreateVisionPanelStateImplCopyWithImpl(
    _$CreateVisionPanelStateImpl _value,
    $Res Function(_$CreateVisionPanelStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateVisionPanelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? form = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? items = null,
    Object? imageLines = null,
    Object? view = null,
    Object? isModified = null,
    Object? isUpdated = null,
    Object? isPrintLoading = null,
    Object? uploadedItemIndexes = null,
    Object? successMsg = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$CreateVisionPanelStateImpl(
        form:
            null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                    as VisionModel,
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
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<VisionItems>,
        imageLines:
            null == imageLines
                ? _value._imageLines
                : imageLines // ignore: cast_nullable_to_non_nullable
                    as List<VisionPanelEntryLines>,
        view:
            null == view
                ? _value.view
                : view // ignore: cast_nullable_to_non_nullable
                    as VisionView,
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
        uploadedItemIndexes:
            null == uploadedItemIndexes
                ? _value._uploadedItemIndexes
                : uploadedItemIndexes // ignore: cast_nullable_to_non_nullable
                    as Set<int>,
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

class _$CreateVisionPanelStateImpl implements _CreateVisionPanelState {
  const _$CreateVisionPanelStateImpl({
    required this.form,
    required this.isLoading,
    required this.isSuccess,
    final List<VisionItems> items = const [],
    final List<VisionPanelEntryLines> imageLines = const [],
    required this.view,
    this.isModified = false,
    this.isUpdated = false,
    this.isPrintLoading = false,
    final Set<int> uploadedItemIndexes = const <int>{},
    this.successMsg,
    this.error,
  }) : _items = items,
       _imageLines = imageLines,
       _uploadedItemIndexes = uploadedItemIndexes;

  @override
  final VisionModel form;
  @override
  final bool isLoading;
  @override
  final bool isSuccess;
  final List<VisionItems> _items;
  @override
  @JsonKey()
  List<VisionItems> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<VisionPanelEntryLines> _imageLines;
  @override
  @JsonKey()
  List<VisionPanelEntryLines> get imageLines {
    if (_imageLines is EqualUnmodifiableListView) return _imageLines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageLines);
  }

  @override
  final VisionView view;
  @override
  @JsonKey()
  final bool isModified;
  @override
  @JsonKey()
  final bool isUpdated;
  @override
  @JsonKey()
  final bool isPrintLoading;
  final Set<int> _uploadedItemIndexes;
  @override
  @JsonKey()
  Set<int> get uploadedItemIndexes {
    if (_uploadedItemIndexes is EqualUnmodifiableSetView)
      return _uploadedItemIndexes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_uploadedItemIndexes);
  }

  @override
  final String? successMsg;
  @override
  final Failure? error;

  @override
  String toString() {
    return 'CreateVisionPanelState(form: $form, isLoading: $isLoading, isSuccess: $isSuccess, items: $items, imageLines: $imageLines, view: $view, isModified: $isModified, isUpdated: $isUpdated, isPrintLoading: $isPrintLoading, uploadedItemIndexes: $uploadedItemIndexes, successMsg: $successMsg, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateVisionPanelStateImpl &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._imageLines,
              _imageLines,
            ) &&
            (identical(other.view, view) || other.view == view) &&
            (identical(other.isModified, isModified) ||
                other.isModified == isModified) &&
            (identical(other.isUpdated, isUpdated) ||
                other.isUpdated == isUpdated) &&
            (identical(other.isPrintLoading, isPrintLoading) ||
                other.isPrintLoading == isPrintLoading) &&
            const DeepCollectionEquality().equals(
              other._uploadedItemIndexes,
              _uploadedItemIndexes,
            ) &&
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
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_imageLines),
    view,
    isModified,
    isUpdated,
    isPrintLoading,
    const DeepCollectionEquality().hash(_uploadedItemIndexes),
    successMsg,
    error,
  );

  /// Create a copy of CreateVisionPanelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateVisionPanelStateImplCopyWith<_$CreateVisionPanelStateImpl>
  get copyWith =>
      __$$CreateVisionPanelStateImplCopyWithImpl<_$CreateVisionPanelStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateVisionPanelState implements CreateVisionPanelState {
  const factory _CreateVisionPanelState({
    required final VisionModel form,
    required final bool isLoading,
    required final bool isSuccess,
    final List<VisionItems> items,
    final List<VisionPanelEntryLines> imageLines,
    required final VisionView view,
    final bool isModified,
    final bool isUpdated,
    final bool isPrintLoading,
    final Set<int> uploadedItemIndexes,
    final String? successMsg,
    final Failure? error,
  }) = _$CreateVisionPanelStateImpl;

  @override
  VisionModel get form;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  List<VisionItems> get items;
  @override
  List<VisionPanelEntryLines> get imageLines;
  @override
  VisionView get view;
  @override
  bool get isModified;
  @override
  bool get isUpdated;
  @override
  bool get isPrintLoading;
  @override
  Set<int> get uploadedItemIndexes;
  @override
  String? get successMsg;
  @override
  Failure? get error;

  /// Create a copy of CreateVisionPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateVisionPanelStateImplCopyWith<_$CreateVisionPanelStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
