// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pallet_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PalletItems _$PalletItemsFromJson(Map<String, dynamic> json) {
  return _PalletItems.fromJson(json);
}

/// @nodoc
mixin _$PalletItems {
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
  int? get docstatus => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'size')
  String? get size => throw _privateConstructorUsedError;
  @JsonKey(name: 'no_of_pallets')
  int? get noOfPallets => throw _privateConstructorUsedError;

  /// Serializes this PalletItems to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PalletItems
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PalletItemsCopyWith<PalletItems> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PalletItemsCopyWith<$Res> {
  factory $PalletItemsCopyWith(
    PalletItems value,
    $Res Function(PalletItems) then,
  ) = _$PalletItemsCopyWithImpl<$Res, PalletItems>;
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docstatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'parent') String? parent,
    @JsonKey(name: 'parentfield') String? parentField,
    @JsonKey(name: 'parenttype') String? parentType,
    @JsonKey(name: 'product_type') String? productType,
    @JsonKey(name: 'size') String? size,
    @JsonKey(name: 'no_of_pallets') int? noOfPallets,
  });
}

/// @nodoc
class _$PalletItemsCopyWithImpl<$Res, $Val extends PalletItems>
    implements $PalletItemsCopyWith<$Res> {
  _$PalletItemsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PalletItems
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? owner = freezed,
    Object? creation = freezed,
    Object? modified = freezed,
    Object? modifiedBy = freezed,
    Object? docstatus = freezed,
    Object? idx = freezed,
    Object? parent = freezed,
    Object? parentField = freezed,
    Object? parentType = freezed,
    Object? productType = freezed,
    Object? size = freezed,
    Object? noOfPallets = freezed,
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
            docstatus:
                freezed == docstatus
                    ? _value.docstatus
                    : docstatus // ignore: cast_nullable_to_non_nullable
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
            size:
                freezed == size
                    ? _value.size
                    : size // ignore: cast_nullable_to_non_nullable
                        as String?,
            noOfPallets:
                freezed == noOfPallets
                    ? _value.noOfPallets
                    : noOfPallets // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PalletItemsImplCopyWith<$Res>
    implements $PalletItemsCopyWith<$Res> {
  factory _$$PalletItemsImplCopyWith(
    _$PalletItemsImpl value,
    $Res Function(_$PalletItemsImpl) then,
  ) = __$$PalletItemsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docstatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'parent') String? parent,
    @JsonKey(name: 'parentfield') String? parentField,
    @JsonKey(name: 'parenttype') String? parentType,
    @JsonKey(name: 'product_type') String? productType,
    @JsonKey(name: 'size') String? size,
    @JsonKey(name: 'no_of_pallets') int? noOfPallets,
  });
}

/// @nodoc
class __$$PalletItemsImplCopyWithImpl<$Res>
    extends _$PalletItemsCopyWithImpl<$Res, _$PalletItemsImpl>
    implements _$$PalletItemsImplCopyWith<$Res> {
  __$$PalletItemsImplCopyWithImpl(
    _$PalletItemsImpl _value,
    $Res Function(_$PalletItemsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PalletItems
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? owner = freezed,
    Object? creation = freezed,
    Object? modified = freezed,
    Object? modifiedBy = freezed,
    Object? docstatus = freezed,
    Object? idx = freezed,
    Object? parent = freezed,
    Object? parentField = freezed,
    Object? parentType = freezed,
    Object? productType = freezed,
    Object? size = freezed,
    Object? noOfPallets = freezed,
  }) {
    return _then(
      _$PalletItemsImpl(
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
        docstatus:
            freezed == docstatus
                ? _value.docstatus
                : docstatus // ignore: cast_nullable_to_non_nullable
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
        size:
            freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                    as String?,
        noOfPallets:
            freezed == noOfPallets
                ? _value.noOfPallets
                : noOfPallets // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PalletItemsImpl implements _PalletItems {
  const _$PalletItemsImpl({
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'owner') this.owner,
    @JsonKey(name: 'creation') this.creation,
    @JsonKey(name: 'modified') this.modified,
    @JsonKey(name: 'modified_by') this.modifiedBy,
    @JsonKey(name: 'docstatus') this.docstatus,
    @JsonKey(name: 'idx') this.idx,
    @JsonKey(name: 'parent') this.parent,
    @JsonKey(name: 'parentfield') this.parentField,
    @JsonKey(name: 'parenttype') this.parentType,
    @JsonKey(name: 'product_type') this.productType,
    @JsonKey(name: 'size') this.size,
    @JsonKey(name: 'no_of_pallets') this.noOfPallets,
  });

  factory _$PalletItemsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PalletItemsImplFromJson(json);

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
  final int? docstatus;
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
  @JsonKey(name: 'size')
  final String? size;
  @override
  @JsonKey(name: 'no_of_pallets')
  final int? noOfPallets;

  @override
  String toString() {
    return 'PalletItems(name: $name, owner: $owner, creation: $creation, modified: $modified, modifiedBy: $modifiedBy, docstatus: $docstatus, idx: $idx, parent: $parent, parentField: $parentField, parentType: $parentType, productType: $productType, size: $size, noOfPallets: $noOfPallets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PalletItemsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.creation, creation) ||
                other.creation == creation) &&
            (identical(other.modified, modified) ||
                other.modified == modified) &&
            (identical(other.modifiedBy, modifiedBy) ||
                other.modifiedBy == modifiedBy) &&
            (identical(other.docstatus, docstatus) ||
                other.docstatus == docstatus) &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.parentField, parentField) ||
                other.parentField == parentField) &&
            (identical(other.parentType, parentType) ||
                other.parentType == parentType) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.noOfPallets, noOfPallets) ||
                other.noOfPallets == noOfPallets));
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
    docstatus,
    idx,
    parent,
    parentField,
    parentType,
    productType,
    size,
    noOfPallets,
  );

  /// Create a copy of PalletItems
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PalletItemsImplCopyWith<_$PalletItemsImpl> get copyWith =>
      __$$PalletItemsImplCopyWithImpl<_$PalletItemsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PalletItemsImplToJson(this);
  }
}

abstract class _PalletItems implements PalletItems {
  const factory _PalletItems({
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'owner') final String? owner,
    @JsonKey(name: 'creation') final String? creation,
    @JsonKey(name: 'modified') final String? modified,
    @JsonKey(name: 'modified_by') final String? modifiedBy,
    @JsonKey(name: 'docstatus') final int? docstatus,
    @JsonKey(name: 'idx') final int? idx,
    @JsonKey(name: 'parent') final String? parent,
    @JsonKey(name: 'parentfield') final String? parentField,
    @JsonKey(name: 'parenttype') final String? parentType,
    @JsonKey(name: 'product_type') final String? productType,
    @JsonKey(name: 'size') final String? size,
    @JsonKey(name: 'no_of_pallets') final int? noOfPallets,
  }) = _$PalletItemsImpl;

  factory _PalletItems.fromJson(Map<String, dynamic> json) =
      _$PalletItemsImpl.fromJson;

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
  int? get docstatus;
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
  @JsonKey(name: 'size')
  String? get size;
  @override
  @JsonKey(name: 'no_of_pallets')
  int? get noOfPallets;

  /// Create a copy of PalletItems
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PalletItemsImplCopyWith<_$PalletItemsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
