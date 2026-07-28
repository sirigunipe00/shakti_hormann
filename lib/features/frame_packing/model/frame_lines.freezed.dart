// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'frame_lines.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FrameLines _$FrameLinesFromJson(Map<String, dynamic> json) {
  return _FrameLines.fromJson(json);
}

/// @nodoc
mixin _$FrameLines {
  String? get shutterBarcode => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'frame_barcode')
  String? get shutterBarcodeQr => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_code')
  String? get itemCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_name')
  String? get itemName => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order')
  String? get salesOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer')
  String? get customer => throw _privateConstructorUsedError;
  @JsonKey(name: 'scan_time')
  String? get scanTime => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'frame_photo',
    fromJson: _photosFromJson,
    toJson: _photosToJson,
  )
  List<String>? get shutterPhoto => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<File>? get shutterPhotoImg => throw _privateConstructorUsedError;

  /// Serializes this FrameLines to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FrameLines
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FrameLinesCopyWith<FrameLines> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FrameLinesCopyWith<$Res> {
  factory $FrameLinesCopyWith(
    FrameLines value,
    $Res Function(FrameLines) then,
  ) = _$FrameLinesCopyWithImpl<$Res, FrameLines>;
  @useResult
  $Res call({
    String? shutterBarcode,
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
    @JsonKey(name: 'frame_barcode') String? shutterBarcodeQr,
    @JsonKey(name: 'item_code') String? itemCode,
    @JsonKey(name: 'item_name') String? itemName,
    @JsonKey(name: 'sales_order') String? salesOrder,
    @JsonKey(name: 'customer') String? customer,
    @JsonKey(name: 'scan_time') String? scanTime,
    @JsonKey(
      name: 'frame_photo',
      fromJson: _photosFromJson,
      toJson: _photosToJson,
    )
    List<String>? shutterPhoto,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<File>? shutterPhotoImg,
  });
}

/// @nodoc
class _$FrameLinesCopyWithImpl<$Res, $Val extends FrameLines>
    implements $FrameLinesCopyWith<$Res> {
  _$FrameLinesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FrameLines
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shutterBarcode = freezed,
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
    Object? shutterBarcodeQr = freezed,
    Object? itemCode = freezed,
    Object? itemName = freezed,
    Object? salesOrder = freezed,
    Object? customer = freezed,
    Object? scanTime = freezed,
    Object? shutterPhoto = freezed,
    Object? shutterPhotoImg = freezed,
  }) {
    return _then(
      _value.copyWith(
            shutterBarcode:
                freezed == shutterBarcode
                    ? _value.shutterBarcode
                    : shutterBarcode // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            shutterBarcodeQr:
                freezed == shutterBarcodeQr
                    ? _value.shutterBarcodeQr
                    : shutterBarcodeQr // ignore: cast_nullable_to_non_nullable
                        as String?,
            itemCode:
                freezed == itemCode
                    ? _value.itemCode
                    : itemCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            itemName:
                freezed == itemName
                    ? _value.itemName
                    : itemName // ignore: cast_nullable_to_non_nullable
                        as String?,
            salesOrder:
                freezed == salesOrder
                    ? _value.salesOrder
                    : salesOrder // ignore: cast_nullable_to_non_nullable
                        as String?,
            customer:
                freezed == customer
                    ? _value.customer
                    : customer // ignore: cast_nullable_to_non_nullable
                        as String?,
            scanTime:
                freezed == scanTime
                    ? _value.scanTime
                    : scanTime // ignore: cast_nullable_to_non_nullable
                        as String?,
            shutterPhoto:
                freezed == shutterPhoto
                    ? _value.shutterPhoto
                    : shutterPhoto // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            shutterPhotoImg:
                freezed == shutterPhotoImg
                    ? _value.shutterPhotoImg
                    : shutterPhotoImg // ignore: cast_nullable_to_non_nullable
                        as List<File>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FrameLinesImplCopyWith<$Res>
    implements $FrameLinesCopyWith<$Res> {
  factory _$$FrameLinesImplCopyWith(
    _$FrameLinesImpl value,
    $Res Function(_$FrameLinesImpl) then,
  ) = __$$FrameLinesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? shutterBarcode,
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
    @JsonKey(name: 'frame_barcode') String? shutterBarcodeQr,
    @JsonKey(name: 'item_code') String? itemCode,
    @JsonKey(name: 'item_name') String? itemName,
    @JsonKey(name: 'sales_order') String? salesOrder,
    @JsonKey(name: 'customer') String? customer,
    @JsonKey(name: 'scan_time') String? scanTime,
    @JsonKey(
      name: 'frame_photo',
      fromJson: _photosFromJson,
      toJson: _photosToJson,
    )
    List<String>? shutterPhoto,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<File>? shutterPhotoImg,
  });
}

/// @nodoc
class __$$FrameLinesImplCopyWithImpl<$Res>
    extends _$FrameLinesCopyWithImpl<$Res, _$FrameLinesImpl>
    implements _$$FrameLinesImplCopyWith<$Res> {
  __$$FrameLinesImplCopyWithImpl(
    _$FrameLinesImpl _value,
    $Res Function(_$FrameLinesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FrameLines
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shutterBarcode = freezed,
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
    Object? shutterBarcodeQr = freezed,
    Object? itemCode = freezed,
    Object? itemName = freezed,
    Object? salesOrder = freezed,
    Object? customer = freezed,
    Object? scanTime = freezed,
    Object? shutterPhoto = freezed,
    Object? shutterPhotoImg = freezed,
  }) {
    return _then(
      _$FrameLinesImpl(
        shutterBarcode:
            freezed == shutterBarcode
                ? _value.shutterBarcode
                : shutterBarcode // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        shutterBarcodeQr:
            freezed == shutterBarcodeQr
                ? _value.shutterBarcodeQr
                : shutterBarcodeQr // ignore: cast_nullable_to_non_nullable
                    as String?,
        itemCode:
            freezed == itemCode
                ? _value.itemCode
                : itemCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        itemName:
            freezed == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                    as String?,
        salesOrder:
            freezed == salesOrder
                ? _value.salesOrder
                : salesOrder // ignore: cast_nullable_to_non_nullable
                    as String?,
        customer:
            freezed == customer
                ? _value.customer
                : customer // ignore: cast_nullable_to_non_nullable
                    as String?,
        scanTime:
            freezed == scanTime
                ? _value.scanTime
                : scanTime // ignore: cast_nullable_to_non_nullable
                    as String?,
        shutterPhoto:
            freezed == shutterPhoto
                ? _value._shutterPhoto
                : shutterPhoto // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        shutterPhotoImg:
            freezed == shutterPhotoImg
                ? _value._shutterPhotoImg
                : shutterPhotoImg // ignore: cast_nullable_to_non_nullable
                    as List<File>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FrameLinesImpl implements _FrameLines {
  const _$FrameLinesImpl({
    this.shutterBarcode,
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
    @JsonKey(name: 'frame_barcode') this.shutterBarcodeQr,
    @JsonKey(name: 'item_code') this.itemCode,
    @JsonKey(name: 'item_name') this.itemName,
    @JsonKey(name: 'sales_order') this.salesOrder,
    @JsonKey(name: 'customer') this.customer,
    @JsonKey(name: 'scan_time') this.scanTime,
    @JsonKey(
      name: 'frame_photo',
      fromJson: _photosFromJson,
      toJson: _photosToJson,
    )
    final List<String>? shutterPhoto,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<File>? shutterPhotoImg,
  }) : _shutterPhoto = shutterPhoto,
       _shutterPhotoImg = shutterPhotoImg;

  factory _$FrameLinesImpl.fromJson(Map<String, dynamic> json) =>
      _$$FrameLinesImplFromJson(json);

  @override
  final String? shutterBarcode;
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
  @JsonKey(name: 'frame_barcode')
  final String? shutterBarcodeQr;
  @override
  @JsonKey(name: 'item_code')
  final String? itemCode;
  @override
  @JsonKey(name: 'item_name')
  final String? itemName;
  @override
  @JsonKey(name: 'sales_order')
  final String? salesOrder;
  @override
  @JsonKey(name: 'customer')
  final String? customer;
  @override
  @JsonKey(name: 'scan_time')
  final String? scanTime;
  final List<String>? _shutterPhoto;
  @override
  @JsonKey(
    name: 'frame_photo',
    fromJson: _photosFromJson,
    toJson: _photosToJson,
  )
  List<String>? get shutterPhoto {
    final value = _shutterPhoto;
    if (value == null) return null;
    if (_shutterPhoto is EqualUnmodifiableListView) return _shutterPhoto;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<File>? _shutterPhotoImg;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<File>? get shutterPhotoImg {
    final value = _shutterPhotoImg;
    if (value == null) return null;
    if (_shutterPhotoImg is EqualUnmodifiableListView) return _shutterPhotoImg;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FrameLines(shutterBarcode: $shutterBarcode, name: $name, owner: $owner, creation: $creation, modified: $modified, modifiedBy: $modifiedBy, docStatus: $docStatus, idx: $idx, parent: $parent, parentField: $parentField, parentType: $parentType, shutterBarcodeQr: $shutterBarcodeQr, itemCode: $itemCode, itemName: $itemName, salesOrder: $salesOrder, customer: $customer, scanTime: $scanTime, shutterPhoto: $shutterPhoto, shutterPhotoImg: $shutterPhotoImg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FrameLinesImpl &&
            (identical(other.shutterBarcode, shutterBarcode) ||
                other.shutterBarcode == shutterBarcode) &&
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
            (identical(other.shutterBarcodeQr, shutterBarcodeQr) ||
                other.shutterBarcodeQr == shutterBarcodeQr) &&
            (identical(other.itemCode, itemCode) ||
                other.itemCode == itemCode) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.salesOrder, salesOrder) ||
                other.salesOrder == salesOrder) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.scanTime, scanTime) ||
                other.scanTime == scanTime) &&
            const DeepCollectionEquality().equals(
              other._shutterPhoto,
              _shutterPhoto,
            ) &&
            const DeepCollectionEquality().equals(
              other._shutterPhotoImg,
              _shutterPhotoImg,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    shutterBarcode,
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
    shutterBarcodeQr,
    itemCode,
    itemName,
    salesOrder,
    customer,
    scanTime,
    const DeepCollectionEquality().hash(_shutterPhoto),
    const DeepCollectionEquality().hash(_shutterPhotoImg),
  ]);

  /// Create a copy of FrameLines
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FrameLinesImplCopyWith<_$FrameLinesImpl> get copyWith =>
      __$$FrameLinesImplCopyWithImpl<_$FrameLinesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FrameLinesImplToJson(this);
  }
}

abstract class _FrameLines implements FrameLines {
  const factory _FrameLines({
    final String? shutterBarcode,
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
    @JsonKey(name: 'frame_barcode') final String? shutterBarcodeQr,
    @JsonKey(name: 'item_code') final String? itemCode,
    @JsonKey(name: 'item_name') final String? itemName,
    @JsonKey(name: 'sales_order') final String? salesOrder,
    @JsonKey(name: 'customer') final String? customer,
    @JsonKey(name: 'scan_time') final String? scanTime,
    @JsonKey(
      name: 'frame_photo',
      fromJson: _photosFromJson,
      toJson: _photosToJson,
    )
    final List<String>? shutterPhoto,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<File>? shutterPhotoImg,
  }) = _$FrameLinesImpl;

  factory _FrameLines.fromJson(Map<String, dynamic> json) =
      _$FrameLinesImpl.fromJson;

  @override
  String? get shutterBarcode;
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
  @JsonKey(name: 'frame_barcode')
  String? get shutterBarcodeQr;
  @override
  @JsonKey(name: 'item_code')
  String? get itemCode;
  @override
  @JsonKey(name: 'item_name')
  String? get itemName;
  @override
  @JsonKey(name: 'sales_order')
  String? get salesOrder;
  @override
  @JsonKey(name: 'customer')
  String? get customer;
  @override
  @JsonKey(name: 'scan_time')
  String? get scanTime;
  @override
  @JsonKey(
    name: 'frame_photo',
    fromJson: _photosFromJson,
    toJson: _photosToJson,
  )
  List<String>? get shutterPhoto;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<File>? get shutterPhotoImg;

  /// Create a copy of FrameLines
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FrameLinesImplCopyWith<_$FrameLinesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
