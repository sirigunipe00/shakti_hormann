// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hardware_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HardwareItem _$HardwareItemFromJson(Map<String, dynamic> json) {
  return _HardwareItem.fromJson(json);
}

/// @nodoc
mixin _$HardwareItem {
  String? get status => throw _privateConstructorUsedError;

  /// Per-MES / box warehouse status (server-only).
  @JsonKey(
    name: 'allocation_status',
    includeFromJson: true,
    includeToJson: false,
  )
  String? get allocationStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_zone', includeFromJson: true, includeToJson: false)
  String? get currentZone => throw _privateConstructorUsedError;
  String? get slNO => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'box_count')
  int? get boxCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'mes_qr__barcode_value')
  String? get mesBarCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'uom')
  String? get uom => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_on_sticker')
  int? get qtySticker => throw _privateConstructorUsedError;
  @JsonKey(name: 'sap_code')
  String? get materialCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'mes_number')
  String? get mesNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'mes_sticker_image')
  String? get mesStcikerImage => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get mesStickerImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'box')
  String? get box => throw _privateConstructorUsedError;
  @JsonKey(name: 'page')
  String? get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'box_type')
  String? get boxType => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get deletedLines => throw _privateConstructorUsedError;

  /// Serializes this HardwareItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HardwareItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HardwareItemCopyWith<HardwareItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HardwareItemCopyWith<$Res> {
  factory $HardwareItemCopyWith(
    HardwareItem value,
    $Res Function(HardwareItem) then,
  ) = _$HardwareItemCopyWithImpl<$Res, HardwareItem>;
  @useResult
  $Res call({
    String? status,
    @JsonKey(
      name: 'allocation_status',
      includeFromJson: true,
      includeToJson: false,
    )
    String? allocationStatus,
    @JsonKey(name: 'current_zone', includeFromJson: true, includeToJson: false)
    String? currentZone,
    String? slNO,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'box_count') int? boxCount,
    @JsonKey(name: 'mes_qr__barcode_value') String? mesBarCode,
    @JsonKey(name: 'uom') String? uom,
    @JsonKey(name: 'description') String? productName,
    @JsonKey(name: 'qty_on_sticker') int? qtySticker,
    @JsonKey(name: 'sap_code') String? materialCode,
    @JsonKey(name: 'mes_number') String? mesNumber,
    @JsonKey(name: 'mes_sticker_image') String? mesStcikerImage,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? mesStickerImage,
    @JsonKey(name: 'box') String? box,
    @JsonKey(name: 'page') String? page,
    @JsonKey(name: 'box_type') String? boxType,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<String> deletedLines,
  });
}

/// @nodoc
class _$HardwareItemCopyWithImpl<$Res, $Val extends HardwareItem>
    implements $HardwareItemCopyWith<$Res> {
  _$HardwareItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HardwareItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? allocationStatus = freezed,
    Object? currentZone = freezed,
    Object? slNO = freezed,
    Object? name = freezed,
    Object? owner = freezed,
    Object? creation = freezed,
    Object? modified = freezed,
    Object? modifiedBy = freezed,
    Object? boxCount = freezed,
    Object? mesBarCode = freezed,
    Object? uom = freezed,
    Object? productName = freezed,
    Object? qtySticker = freezed,
    Object? materialCode = freezed,
    Object? mesNumber = freezed,
    Object? mesStcikerImage = freezed,
    Object? mesStickerImage = freezed,
    Object? box = freezed,
    Object? page = freezed,
    Object? boxType = freezed,
    Object? deletedLines = null,
  }) {
    return _then(
      _value.copyWith(
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String?,
            allocationStatus:
                freezed == allocationStatus
                    ? _value.allocationStatus
                    : allocationStatus // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentZone:
                freezed == currentZone
                    ? _value.currentZone
                    : currentZone // ignore: cast_nullable_to_non_nullable
                        as String?,
            slNO:
                freezed == slNO
                    ? _value.slNO
                    : slNO // ignore: cast_nullable_to_non_nullable
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
            boxCount:
                freezed == boxCount
                    ? _value.boxCount
                    : boxCount // ignore: cast_nullable_to_non_nullable
                        as int?,
            mesBarCode:
                freezed == mesBarCode
                    ? _value.mesBarCode
                    : mesBarCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            uom:
                freezed == uom
                    ? _value.uom
                    : uom // ignore: cast_nullable_to_non_nullable
                        as String?,
            productName:
                freezed == productName
                    ? _value.productName
                    : productName // ignore: cast_nullable_to_non_nullable
                        as String?,
            qtySticker:
                freezed == qtySticker
                    ? _value.qtySticker
                    : qtySticker // ignore: cast_nullable_to_non_nullable
                        as int?,
            materialCode:
                freezed == materialCode
                    ? _value.materialCode
                    : materialCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            mesNumber:
                freezed == mesNumber
                    ? _value.mesNumber
                    : mesNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            mesStcikerImage:
                freezed == mesStcikerImage
                    ? _value.mesStcikerImage
                    : mesStcikerImage // ignore: cast_nullable_to_non_nullable
                        as String?,
            mesStickerImage:
                freezed == mesStickerImage
                    ? _value.mesStickerImage
                    : mesStickerImage // ignore: cast_nullable_to_non_nullable
                        as File?,
            box:
                freezed == box
                    ? _value.box
                    : box // ignore: cast_nullable_to_non_nullable
                        as String?,
            page:
                freezed == page
                    ? _value.page
                    : page // ignore: cast_nullable_to_non_nullable
                        as String?,
            boxType:
                freezed == boxType
                    ? _value.boxType
                    : boxType // ignore: cast_nullable_to_non_nullable
                        as String?,
            deletedLines:
                null == deletedLines
                    ? _value.deletedLines
                    : deletedLines // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HardwareItemImplCopyWith<$Res>
    implements $HardwareItemCopyWith<$Res> {
  factory _$$HardwareItemImplCopyWith(
    _$HardwareItemImpl value,
    $Res Function(_$HardwareItemImpl) then,
  ) = __$$HardwareItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    @JsonKey(
      name: 'allocation_status',
      includeFromJson: true,
      includeToJson: false,
    )
    String? allocationStatus,
    @JsonKey(name: 'current_zone', includeFromJson: true, includeToJson: false)
    String? currentZone,
    String? slNO,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'box_count') int? boxCount,
    @JsonKey(name: 'mes_qr__barcode_value') String? mesBarCode,
    @JsonKey(name: 'uom') String? uom,
    @JsonKey(name: 'description') String? productName,
    @JsonKey(name: 'qty_on_sticker') int? qtySticker,
    @JsonKey(name: 'sap_code') String? materialCode,
    @JsonKey(name: 'mes_number') String? mesNumber,
    @JsonKey(name: 'mes_sticker_image') String? mesStcikerImage,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? mesStickerImage,
    @JsonKey(name: 'box') String? box,
    @JsonKey(name: 'page') String? page,
    @JsonKey(name: 'box_type') String? boxType,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<String> deletedLines,
  });
}

/// @nodoc
class __$$HardwareItemImplCopyWithImpl<$Res>
    extends _$HardwareItemCopyWithImpl<$Res, _$HardwareItemImpl>
    implements _$$HardwareItemImplCopyWith<$Res> {
  __$$HardwareItemImplCopyWithImpl(
    _$HardwareItemImpl _value,
    $Res Function(_$HardwareItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HardwareItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? allocationStatus = freezed,
    Object? currentZone = freezed,
    Object? slNO = freezed,
    Object? name = freezed,
    Object? owner = freezed,
    Object? creation = freezed,
    Object? modified = freezed,
    Object? modifiedBy = freezed,
    Object? boxCount = freezed,
    Object? mesBarCode = freezed,
    Object? uom = freezed,
    Object? productName = freezed,
    Object? qtySticker = freezed,
    Object? materialCode = freezed,
    Object? mesNumber = freezed,
    Object? mesStcikerImage = freezed,
    Object? mesStickerImage = freezed,
    Object? box = freezed,
    Object? page = freezed,
    Object? boxType = freezed,
    Object? deletedLines = null,
  }) {
    return _then(
      _$HardwareItemImpl(
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String?,
        allocationStatus:
            freezed == allocationStatus
                ? _value.allocationStatus
                : allocationStatus // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentZone:
            freezed == currentZone
                ? _value.currentZone
                : currentZone // ignore: cast_nullable_to_non_nullable
                    as String?,
        slNO:
            freezed == slNO
                ? _value.slNO
                : slNO // ignore: cast_nullable_to_non_nullable
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
        boxCount:
            freezed == boxCount
                ? _value.boxCount
                : boxCount // ignore: cast_nullable_to_non_nullable
                    as int?,
        mesBarCode:
            freezed == mesBarCode
                ? _value.mesBarCode
                : mesBarCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        uom:
            freezed == uom
                ? _value.uom
                : uom // ignore: cast_nullable_to_non_nullable
                    as String?,
        productName:
            freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                    as String?,
        qtySticker:
            freezed == qtySticker
                ? _value.qtySticker
                : qtySticker // ignore: cast_nullable_to_non_nullable
                    as int?,
        materialCode:
            freezed == materialCode
                ? _value.materialCode
                : materialCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        mesNumber:
            freezed == mesNumber
                ? _value.mesNumber
                : mesNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        mesStcikerImage:
            freezed == mesStcikerImage
                ? _value.mesStcikerImage
                : mesStcikerImage // ignore: cast_nullable_to_non_nullable
                    as String?,
        mesStickerImage:
            freezed == mesStickerImage
                ? _value.mesStickerImage
                : mesStickerImage // ignore: cast_nullable_to_non_nullable
                    as File?,
        box:
            freezed == box
                ? _value.box
                : box // ignore: cast_nullable_to_non_nullable
                    as String?,
        page:
            freezed == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                    as String?,
        boxType:
            freezed == boxType
                ? _value.boxType
                : boxType // ignore: cast_nullable_to_non_nullable
                    as String?,
        deletedLines:
            null == deletedLines
                ? _value._deletedLines
                : deletedLines // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HardwareItemImpl implements _HardwareItem {
  const _$HardwareItemImpl({
    this.status,
    @JsonKey(
      name: 'allocation_status',
      includeFromJson: true,
      includeToJson: false,
    )
    this.allocationStatus,
    @JsonKey(name: 'current_zone', includeFromJson: true, includeToJson: false)
    this.currentZone,
    this.slNO,
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'owner') this.owner,
    @JsonKey(name: 'creation') this.creation,
    @JsonKey(name: 'modified') this.modified,
    @JsonKey(name: 'modified_by') this.modifiedBy,
    @JsonKey(name: 'box_count') this.boxCount,
    @JsonKey(name: 'mes_qr__barcode_value') this.mesBarCode,
    @JsonKey(name: 'uom') this.uom,
    @JsonKey(name: 'description') this.productName,
    @JsonKey(name: 'qty_on_sticker') this.qtySticker,
    @JsonKey(name: 'sap_code') this.materialCode,
    @JsonKey(name: 'mes_number') this.mesNumber,
    @JsonKey(name: 'mes_sticker_image') this.mesStcikerImage,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    this.mesStickerImage,
    @JsonKey(name: 'box') this.box,
    @JsonKey(name: 'page') this.page,
    @JsonKey(name: 'box_type') this.boxType,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<String> deletedLines = const <String>[],
  }) : _deletedLines = deletedLines;

  factory _$HardwareItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$HardwareItemImplFromJson(json);

  @override
  final String? status;

  /// Per-MES / box warehouse status (server-only).
  @override
  @JsonKey(
    name: 'allocation_status',
    includeFromJson: true,
    includeToJson: false,
  )
  final String? allocationStatus;
  @override
  @JsonKey(name: 'current_zone', includeFromJson: true, includeToJson: false)
  final String? currentZone;
  @override
  final String? slNO;
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
  @JsonKey(name: 'box_count')
  final int? boxCount;
  @override
  @JsonKey(name: 'mes_qr__barcode_value')
  final String? mesBarCode;
  @override
  @JsonKey(name: 'uom')
  final String? uom;
  @override
  @JsonKey(name: 'description')
  final String? productName;
  @override
  @JsonKey(name: 'qty_on_sticker')
  final int? qtySticker;
  @override
  @JsonKey(name: 'sap_code')
  final String? materialCode;
  @override
  @JsonKey(name: 'mes_number')
  final String? mesNumber;
  @override
  @JsonKey(name: 'mes_sticker_image')
  final String? mesStcikerImage;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  final File? mesStickerImage;
  @override
  @JsonKey(name: 'box')
  final String? box;
  @override
  @JsonKey(name: 'page')
  final String? page;
  @override
  @JsonKey(name: 'box_type')
  final String? boxType;
  final List<String> _deletedLines;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get deletedLines {
    if (_deletedLines is EqualUnmodifiableListView) return _deletedLines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deletedLines);
  }

  @override
  String toString() {
    return 'HardwareItem(status: $status, allocationStatus: $allocationStatus, currentZone: $currentZone, slNO: $slNO, name: $name, owner: $owner, creation: $creation, modified: $modified, modifiedBy: $modifiedBy, boxCount: $boxCount, mesBarCode: $mesBarCode, uom: $uom, productName: $productName, qtySticker: $qtySticker, materialCode: $materialCode, mesNumber: $mesNumber, mesStcikerImage: $mesStcikerImage, mesStickerImage: $mesStickerImage, box: $box, page: $page, boxType: $boxType, deletedLines: $deletedLines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HardwareItemImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.allocationStatus, allocationStatus) ||
                other.allocationStatus == allocationStatus) &&
            (identical(other.currentZone, currentZone) ||
                other.currentZone == currentZone) &&
            (identical(other.slNO, slNO) || other.slNO == slNO) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.creation, creation) ||
                other.creation == creation) &&
            (identical(other.modified, modified) ||
                other.modified == modified) &&
            (identical(other.modifiedBy, modifiedBy) ||
                other.modifiedBy == modifiedBy) &&
            (identical(other.boxCount, boxCount) ||
                other.boxCount == boxCount) &&
            (identical(other.mesBarCode, mesBarCode) ||
                other.mesBarCode == mesBarCode) &&
            (identical(other.uom, uom) || other.uom == uom) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.qtySticker, qtySticker) ||
                other.qtySticker == qtySticker) &&
            (identical(other.materialCode, materialCode) ||
                other.materialCode == materialCode) &&
            (identical(other.mesNumber, mesNumber) ||
                other.mesNumber == mesNumber) &&
            (identical(other.mesStcikerImage, mesStcikerImage) ||
                other.mesStcikerImage == mesStcikerImage) &&
            (identical(other.mesStickerImage, mesStickerImage) ||
                other.mesStickerImage == mesStickerImage) &&
            (identical(other.box, box) || other.box == box) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.boxType, boxType) || other.boxType == boxType) &&
            const DeepCollectionEquality().equals(
              other._deletedLines,
              _deletedLines,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    status,
    allocationStatus,
    currentZone,
    slNO,
    name,
    owner,
    creation,
    modified,
    modifiedBy,
    boxCount,
    mesBarCode,
    uom,
    productName,
    qtySticker,
    materialCode,
    mesNumber,
    mesStcikerImage,
    mesStickerImage,
    box,
    page,
    boxType,
    const DeepCollectionEquality().hash(_deletedLines),
  ]);

  /// Create a copy of HardwareItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HardwareItemImplCopyWith<_$HardwareItemImpl> get copyWith =>
      __$$HardwareItemImplCopyWithImpl<_$HardwareItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HardwareItemImplToJson(this);
  }
}

abstract class _HardwareItem implements HardwareItem {
  const factory _HardwareItem({
    final String? status,
    @JsonKey(
      name: 'allocation_status',
      includeFromJson: true,
      includeToJson: false,
    )
    final String? allocationStatus,
    @JsonKey(name: 'current_zone', includeFromJson: true, includeToJson: false)
    final String? currentZone,
    final String? slNO,
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'owner') final String? owner,
    @JsonKey(name: 'creation') final String? creation,
    @JsonKey(name: 'modified') final String? modified,
    @JsonKey(name: 'modified_by') final String? modifiedBy,
    @JsonKey(name: 'box_count') final int? boxCount,
    @JsonKey(name: 'mes_qr__barcode_value') final String? mesBarCode,
    @JsonKey(name: 'uom') final String? uom,
    @JsonKey(name: 'description') final String? productName,
    @JsonKey(name: 'qty_on_sticker') final int? qtySticker,
    @JsonKey(name: 'sap_code') final String? materialCode,
    @JsonKey(name: 'mes_number') final String? mesNumber,
    @JsonKey(name: 'mes_sticker_image') final String? mesStcikerImage,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final File? mesStickerImage,
    @JsonKey(name: 'box') final String? box,
    @JsonKey(name: 'page') final String? page,
    @JsonKey(name: 'box_type') final String? boxType,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<String> deletedLines,
  }) = _$HardwareItemImpl;

  factory _HardwareItem.fromJson(Map<String, dynamic> json) =
      _$HardwareItemImpl.fromJson;

  @override
  String? get status;

  /// Per-MES / box warehouse status (server-only).
  @override
  @JsonKey(
    name: 'allocation_status',
    includeFromJson: true,
    includeToJson: false,
  )
  String? get allocationStatus;
  @override
  @JsonKey(name: 'current_zone', includeFromJson: true, includeToJson: false)
  String? get currentZone;
  @override
  String? get slNO;
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
  @JsonKey(name: 'box_count')
  int? get boxCount;
  @override
  @JsonKey(name: 'mes_qr__barcode_value')
  String? get mesBarCode;
  @override
  @JsonKey(name: 'uom')
  String? get uom;
  @override
  @JsonKey(name: 'description')
  String? get productName;
  @override
  @JsonKey(name: 'qty_on_sticker')
  int? get qtySticker;
  @override
  @JsonKey(name: 'sap_code')
  String? get materialCode;
  @override
  @JsonKey(name: 'mes_number')
  String? get mesNumber;
  @override
  @JsonKey(name: 'mes_sticker_image')
  String? get mesStcikerImage;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get mesStickerImage;
  @override
  @JsonKey(name: 'box')
  String? get box;
  @override
  @JsonKey(name: 'page')
  String? get page;
  @override
  @JsonKey(name: 'box_type')
  String? get boxType;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get deletedLines;

  /// Create a copy of HardwareItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HardwareItemImplCopyWith<_$HardwareItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
