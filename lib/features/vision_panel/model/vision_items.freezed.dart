// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vision_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VisionItems _$VisionItemsFromJson(Map<String, dynamic> json) {
  return _VisionItems.fromJson(json);
}

/// @nodoc
mixin _$VisionItems {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner')
  String? get owner => throw _privateConstructorUsedError;
  @JsonKey(name: 'creation')
  String? get creation => throw _privateConstructorUsedError;
  @JsonKey(name: 'modified')
  String? get modified => throw _privateConstructorUsedError;
  @JsonKey(name: 'modified_by')
  String? get modifiedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'docstatus')
  int? get docStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'idx')
  int? get idx => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent')
  String? get parent => throw _privateConstructorUsedError;
  @JsonKey(name: 'parentfield')
  String? get parentField => throw _privateConstructorUsedError;
  @JsonKey(name: 'parenttype')
  String? get parentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_type')
  String? get productType => throw _privateConstructorUsedError;
  @JsonKey(name: 'no_of_boxes')
  int? get noOfBoxes => throw _privateConstructorUsedError;
  @JsonKey(name: 'print_check')
  int? get printCheck => throw _privateConstructorUsedError;

  /// Serializes this VisionItems to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VisionItems
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VisionItemsCopyWith<VisionItems> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VisionItemsCopyWith<$Res> {
  factory $VisionItemsCopyWith(
    VisionItems value,
    $Res Function(VisionItems) then,
  ) = _$VisionItemsCopyWithImpl<$Res, VisionItems>;
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'parent') String? parent,
    @JsonKey(name: 'parentfield') String? parentField,
    @JsonKey(name: 'parenttype') String? parentType,
    @JsonKey(name: 'product_type') String? productType,
    @JsonKey(name: 'no_of_boxes') int? noOfBoxes,
    @JsonKey(name: 'print_check') int? printCheck,
  });
}

/// @nodoc
class _$VisionItemsCopyWithImpl<$Res, $Val extends VisionItems>
    implements $VisionItemsCopyWith<$Res> {
  _$VisionItemsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VisionItems
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? owner = freezed,
    Object? creation = freezed,
    Object? modified = freezed,
    Object? modifiedBy = freezed,
    Object? docStatus = freezed,
    Object? idx = freezed,
    Object? parent = freezed,
    Object? parentField = freezed,
    Object? parentType = freezed,
    Object? productType = freezed,
    Object? noOfBoxes = freezed,
    Object? printCheck = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            owner:
                freezed == owner
                    ? _value.owner
                    : owner // ignore: cast_nullable_to_non_nullable
                        as String?,
            creation:
                freezed == creation
                    ? _value.creation
                    : creation // ignore: cast_nullable_to_non_nullable
                        as String?,
            modified:
                freezed == modified
                    ? _value.modified
                    : modified // ignore: cast_nullable_to_non_nullable
                        as String?,
            modifiedBy:
                freezed == modifiedBy
                    ? _value.modifiedBy
                    : modifiedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            docStatus:
                freezed == docStatus
                    ? _value.docStatus
                    : docStatus // ignore: cast_nullable_to_non_nullable
                        as int?,
            idx:
                freezed == idx
                    ? _value.idx
                    : idx // ignore: cast_nullable_to_non_nullable
                        as int?,
            parent:
                freezed == parent
                    ? _value.parent
                    : parent // ignore: cast_nullable_to_non_nullable
                        as String?,
            parentField:
                freezed == parentField
                    ? _value.parentField
                    : parentField // ignore: cast_nullable_to_non_nullable
                        as String?,
            parentType:
                freezed == parentType
                    ? _value.parentType
                    : parentType // ignore: cast_nullable_to_non_nullable
                        as String?,
            productType:
                freezed == productType
                    ? _value.productType
                    : productType // ignore: cast_nullable_to_non_nullable
                        as String?,
            noOfBoxes:
                freezed == noOfBoxes
                    ? _value.noOfBoxes
                    : noOfBoxes // ignore: cast_nullable_to_non_nullable
                        as int?,
            printCheck:
                freezed == printCheck
                    ? _value.printCheck
                    : printCheck // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VisionItemsImplCopyWith<$Res>
    implements $VisionItemsCopyWith<$Res> {
  factory _$$VisionItemsImplCopyWith(
    _$VisionItemsImpl value,
    $Res Function(_$VisionItemsImpl) then,
  ) = __$$VisionItemsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'parent') String? parent,
    @JsonKey(name: 'parentfield') String? parentField,
    @JsonKey(name: 'parenttype') String? parentType,
    @JsonKey(name: 'product_type') String? productType,
    @JsonKey(name: 'no_of_boxes') int? noOfBoxes,
    @JsonKey(name: 'print_check') int? printCheck,
  });
}

/// @nodoc
class __$$VisionItemsImplCopyWithImpl<$Res>
    extends _$VisionItemsCopyWithImpl<$Res, _$VisionItemsImpl>
    implements _$$VisionItemsImplCopyWith<$Res> {
  __$$VisionItemsImplCopyWithImpl(
    _$VisionItemsImpl _value,
    $Res Function(_$VisionItemsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VisionItems
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? owner = freezed,
    Object? creation = freezed,
    Object? modified = freezed,
    Object? modifiedBy = freezed,
    Object? docStatus = freezed,
    Object? idx = freezed,
    Object? parent = freezed,
    Object? parentField = freezed,
    Object? parentType = freezed,
    Object? productType = freezed,
    Object? noOfBoxes = freezed,
    Object? printCheck = freezed,
  }) {
    return _then(
      _$VisionItemsImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        owner:
            freezed == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                    as String?,
        creation:
            freezed == creation
                ? _value.creation
                : creation // ignore: cast_nullable_to_non_nullable
                    as String?,
        modified:
            freezed == modified
                ? _value.modified
                : modified // ignore: cast_nullable_to_non_nullable
                    as String?,
        modifiedBy:
            freezed == modifiedBy
                ? _value.modifiedBy
                : modifiedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        docStatus:
            freezed == docStatus
                ? _value.docStatus
                : docStatus // ignore: cast_nullable_to_non_nullable
                    as int?,
        idx:
            freezed == idx
                ? _value.idx
                : idx // ignore: cast_nullable_to_non_nullable
                    as int?,
        parent:
            freezed == parent
                ? _value.parent
                : parent // ignore: cast_nullable_to_non_nullable
                    as String?,
        parentField:
            freezed == parentField
                ? _value.parentField
                : parentField // ignore: cast_nullable_to_non_nullable
                    as String?,
        parentType:
            freezed == parentType
                ? _value.parentType
                : parentType // ignore: cast_nullable_to_non_nullable
                    as String?,
        productType:
            freezed == productType
                ? _value.productType
                : productType // ignore: cast_nullable_to_non_nullable
                    as String?,
        noOfBoxes:
            freezed == noOfBoxes
                ? _value.noOfBoxes
                : noOfBoxes // ignore: cast_nullable_to_non_nullable
                    as int?,
        printCheck:
            freezed == printCheck
                ? _value.printCheck
                : printCheck // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VisionItemsImpl implements _VisionItems {
  const _$VisionItemsImpl({
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'owner') this.owner,
    @JsonKey(name: 'creation') this.creation,
    @JsonKey(name: 'modified') this.modified,
    @JsonKey(name: 'modified_by') this.modifiedBy,
    @JsonKey(name: 'docstatus') this.docStatus,
    @JsonKey(name: 'idx') this.idx,
    @JsonKey(name: 'parent') this.parent,
    @JsonKey(name: 'parentfield') this.parentField,
    @JsonKey(name: 'parenttype') this.parentType,
    @JsonKey(name: 'product_type') this.productType,
    @JsonKey(name: 'no_of_boxes') this.noOfBoxes,
    @JsonKey(name: 'print_check') this.printCheck,
  });

  factory _$VisionItemsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VisionItemsImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'owner')
  final String? owner;
  @override
  @JsonKey(name: 'creation')
  final String? creation;
  @override
  @JsonKey(name: 'modified')
  final String? modified;
  @override
  @JsonKey(name: 'modified_by')
  final String? modifiedBy;
  @override
  @JsonKey(name: 'docstatus')
  final int? docStatus;
  @override
  @JsonKey(name: 'idx')
  final int? idx;
  @override
  @JsonKey(name: 'parent')
  final String? parent;
  @override
  @JsonKey(name: 'parentfield')
  final String? parentField;
  @override
  @JsonKey(name: 'parenttype')
  final String? parentType;
  @override
  @JsonKey(name: 'product_type')
  final String? productType;
  @override
  @JsonKey(name: 'no_of_boxes')
  final int? noOfBoxes;
  @override
  @JsonKey(name: 'print_check')
  final int? printCheck;

  @override
  String toString() {
    return 'VisionItems(name: $name, owner: $owner, creation: $creation, modified: $modified, modifiedBy: $modifiedBy, docStatus: $docStatus, idx: $idx, parent: $parent, parentField: $parentField, parentType: $parentType, productType: $productType, noOfBoxes: $noOfBoxes, printCheck: $printCheck)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VisionItemsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.creation, creation) ||
                other.creation == creation) &&
            (identical(other.modified, modified) ||
                other.modified == modified) &&
            (identical(other.modifiedBy, modifiedBy) ||
                other.modifiedBy == modifiedBy) &&
            (identical(other.docStatus, docStatus) ||
                other.docStatus == docStatus) &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.parentField, parentField) ||
                other.parentField == parentField) &&
            (identical(other.parentType, parentType) ||
                other.parentType == parentType) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.noOfBoxes, noOfBoxes) ||
                other.noOfBoxes == noOfBoxes) &&
            (identical(other.printCheck, printCheck) ||
                other.printCheck == printCheck));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    owner,
    creation,
    modified,
    modifiedBy,
    docStatus,
    idx,
    parent,
    parentField,
    parentType,
    productType,
    noOfBoxes,
    printCheck,
  );

  /// Create a copy of VisionItems
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VisionItemsImplCopyWith<_$VisionItemsImpl> get copyWith =>
      __$$VisionItemsImplCopyWithImpl<_$VisionItemsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VisionItemsImplToJson(this);
  }
}

abstract class _VisionItems implements VisionItems {
  const factory _VisionItems({
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'owner') final String? owner,
    @JsonKey(name: 'creation') final String? creation,
    @JsonKey(name: 'modified') final String? modified,
    @JsonKey(name: 'modified_by') final String? modifiedBy,
    @JsonKey(name: 'docstatus') final int? docStatus,
    @JsonKey(name: 'idx') final int? idx,
    @JsonKey(name: 'parent') final String? parent,
    @JsonKey(name: 'parentfield') final String? parentField,
    @JsonKey(name: 'parenttype') final String? parentType,
    @JsonKey(name: 'product_type') final String? productType,
    @JsonKey(name: 'no_of_boxes') final int? noOfBoxes,
    @JsonKey(name: 'print_check') final int? printCheck,
  }) = _$VisionItemsImpl;

  factory _VisionItems.fromJson(Map<String, dynamic> json) =
      _$VisionItemsImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'owner')
  String? get owner;
  @override
  @JsonKey(name: 'creation')
  String? get creation;
  @override
  @JsonKey(name: 'modified')
  String? get modified;
  @override
  @JsonKey(name: 'modified_by')
  String? get modifiedBy;
  @override
  @JsonKey(name: 'docstatus')
  int? get docStatus;
  @override
  @JsonKey(name: 'idx')
  int? get idx;
  @override
  @JsonKey(name: 'parent')
  String? get parent;
  @override
  @JsonKey(name: 'parentfield')
  String? get parentField;
  @override
  @JsonKey(name: 'parenttype')
  String? get parentType;
  @override
  @JsonKey(name: 'product_type')
  String? get productType;
  @override
  @JsonKey(name: 'no_of_boxes')
  int? get noOfBoxes;
  @override
  @JsonKey(name: 'print_check')
  int? get printCheck;

  /// Create a copy of VisionItems
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VisionItemsImplCopyWith<_$VisionItemsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
