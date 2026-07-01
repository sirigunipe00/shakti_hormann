// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hardware_packing_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HardwarePackingItem _$HardwarePackingItemFromJson(Map<String, dynamic> json) {
  return _HardwarePackingItem.fromJson(json);
}

/// @nodoc
mixin _$HardwarePackingItem {
  @JsonKey(name: 'document_type')
  String? get documentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number')
  String? get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'print_date')
  String? get printDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'mes_number')
  String? get mesBarCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'box_type')
  String? get boxType => throw _privateConstructorUsedError;
  @JsonKey(name: 'page')
  String? get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'box')
  String? get box => throw _privateConstructorUsedError;
  @JsonKey(name: 'sr_no')
  int? get slNO => throw _privateConstructorUsedError;
  @JsonKey(name: 'sap_code')
  String? get materialCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty')
  int? get qtySticker => throw _privateConstructorUsedError;
  @JsonKey(name: 'uom')
  String? get uom => throw _privateConstructorUsedError;
  @JsonKey(name: 'items')
  List<HardwarePackingItem> get items => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get mesStickerImage => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get deletedLines => throw _privateConstructorUsedError;

  /// Serializes this HardwarePackingItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HardwarePackingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HardwarePackingItemCopyWith<HardwarePackingItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HardwarePackingItemCopyWith<$Res> {
  factory $HardwarePackingItemCopyWith(
    HardwarePackingItem value,
    $Res Function(HardwarePackingItem) then,
  ) = _$HardwarePackingItemCopyWithImpl<$Res, HardwarePackingItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'document_type') String? documentType,
    @JsonKey(name: 'order_number') String? orderNumber,
    @JsonKey(name: 'print_date') String? printDate,
    @JsonKey(name: 'mes_number') String? mesBarCode,
    @JsonKey(name: 'box_type') String? boxType,
    @JsonKey(name: 'page') String? page,
    @JsonKey(name: 'box') String? box,
    @JsonKey(name: 'sr_no') int? slNO,
    @JsonKey(name: 'sap_code') String? materialCode,
    @JsonKey(name: 'description') String? productName,
    @JsonKey(name: 'qty') int? qtySticker,
    @JsonKey(name: 'uom') String? uom,
    @JsonKey(name: 'items') List<HardwarePackingItem> items,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? mesStickerImage,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<String> deletedLines,
  });
}

/// @nodoc
class _$HardwarePackingItemCopyWithImpl<$Res, $Val extends HardwarePackingItem>
    implements $HardwarePackingItemCopyWith<$Res> {
  _$HardwarePackingItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HardwarePackingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = freezed,
    Object? orderNumber = freezed,
    Object? printDate = freezed,
    Object? mesBarCode = freezed,
    Object? boxType = freezed,
    Object? page = freezed,
    Object? box = freezed,
    Object? slNO = freezed,
    Object? materialCode = freezed,
    Object? productName = freezed,
    Object? qtySticker = freezed,
    Object? uom = freezed,
    Object? items = null,
    Object? mesStickerImage = freezed,
    Object? deletedLines = null,
  }) {
    return _then(
      _value.copyWith(
            documentType:
                freezed == documentType
                    ? _value.documentType
                    : documentType // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderNumber:
                freezed == orderNumber
                    ? _value.orderNumber
                    : orderNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            printDate:
                freezed == printDate
                    ? _value.printDate
                    : printDate // ignore: cast_nullable_to_non_nullable
                        as String?,
            mesBarCode:
                freezed == mesBarCode
                    ? _value.mesBarCode
                    : mesBarCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            boxType:
                freezed == boxType
                    ? _value.boxType
                    : boxType // ignore: cast_nullable_to_non_nullable
                        as String?,
            page:
                freezed == page
                    ? _value.page
                    : page // ignore: cast_nullable_to_non_nullable
                        as String?,
            box:
                freezed == box
                    ? _value.box
                    : box // ignore: cast_nullable_to_non_nullable
                        as String?,
            slNO:
                freezed == slNO
                    ? _value.slNO
                    : slNO // ignore: cast_nullable_to_non_nullable
                        as int?,
            materialCode:
                freezed == materialCode
                    ? _value.materialCode
                    : materialCode // ignore: cast_nullable_to_non_nullable
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
            uom:
                freezed == uom
                    ? _value.uom
                    : uom // ignore: cast_nullable_to_non_nullable
                        as String?,
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<HardwarePackingItem>,
            mesStickerImage:
                freezed == mesStickerImage
                    ? _value.mesStickerImage
                    : mesStickerImage // ignore: cast_nullable_to_non_nullable
                        as File?,
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
abstract class _$$HardwarePackingItemImplCopyWith<$Res>
    implements $HardwarePackingItemCopyWith<$Res> {
  factory _$$HardwarePackingItemImplCopyWith(
    _$HardwarePackingItemImpl value,
    $Res Function(_$HardwarePackingItemImpl) then,
  ) = __$$HardwarePackingItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'document_type') String? documentType,
    @JsonKey(name: 'order_number') String? orderNumber,
    @JsonKey(name: 'print_date') String? printDate,
    @JsonKey(name: 'mes_number') String? mesBarCode,
    @JsonKey(name: 'box_type') String? boxType,
    @JsonKey(name: 'page') String? page,
    @JsonKey(name: 'box') String? box,
    @JsonKey(name: 'sr_no') int? slNO,
    @JsonKey(name: 'sap_code') String? materialCode,
    @JsonKey(name: 'description') String? productName,
    @JsonKey(name: 'qty') int? qtySticker,
    @JsonKey(name: 'uom') String? uom,
    @JsonKey(name: 'items') List<HardwarePackingItem> items,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? mesStickerImage,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<String> deletedLines,
  });
}

/// @nodoc
class __$$HardwarePackingItemImplCopyWithImpl<$Res>
    extends _$HardwarePackingItemCopyWithImpl<$Res, _$HardwarePackingItemImpl>
    implements _$$HardwarePackingItemImplCopyWith<$Res> {
  __$$HardwarePackingItemImplCopyWithImpl(
    _$HardwarePackingItemImpl _value,
    $Res Function(_$HardwarePackingItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HardwarePackingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = freezed,
    Object? orderNumber = freezed,
    Object? printDate = freezed,
    Object? mesBarCode = freezed,
    Object? boxType = freezed,
    Object? page = freezed,
    Object? box = freezed,
    Object? slNO = freezed,
    Object? materialCode = freezed,
    Object? productName = freezed,
    Object? qtySticker = freezed,
    Object? uom = freezed,
    Object? items = null,
    Object? mesStickerImage = freezed,
    Object? deletedLines = null,
  }) {
    return _then(
      _$HardwarePackingItemImpl(
        documentType:
            freezed == documentType
                ? _value.documentType
                : documentType // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderNumber:
            freezed == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        printDate:
            freezed == printDate
                ? _value.printDate
                : printDate // ignore: cast_nullable_to_non_nullable
                    as String?,
        mesBarCode:
            freezed == mesBarCode
                ? _value.mesBarCode
                : mesBarCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        boxType:
            freezed == boxType
                ? _value.boxType
                : boxType // ignore: cast_nullable_to_non_nullable
                    as String?,
        page:
            freezed == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                    as String?,
        box:
            freezed == box
                ? _value.box
                : box // ignore: cast_nullable_to_non_nullable
                    as String?,
        slNO:
            freezed == slNO
                ? _value.slNO
                : slNO // ignore: cast_nullable_to_non_nullable
                    as int?,
        materialCode:
            freezed == materialCode
                ? _value.materialCode
                : materialCode // ignore: cast_nullable_to_non_nullable
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
        uom:
            freezed == uom
                ? _value.uom
                : uom // ignore: cast_nullable_to_non_nullable
                    as String?,
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<HardwarePackingItem>,
        mesStickerImage:
            freezed == mesStickerImage
                ? _value.mesStickerImage
                : mesStickerImage // ignore: cast_nullable_to_non_nullable
                    as File?,
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
class _$HardwarePackingItemImpl implements _HardwarePackingItem {
  const _$HardwarePackingItemImpl({
    @JsonKey(name: 'document_type') this.documentType,
    @JsonKey(name: 'order_number') this.orderNumber,
    @JsonKey(name: 'print_date') this.printDate,
    @JsonKey(name: 'mes_number') this.mesBarCode,
    @JsonKey(name: 'box_type') this.boxType,
    @JsonKey(name: 'page') this.page,
    @JsonKey(name: 'box') this.box,
    @JsonKey(name: 'sr_no') this.slNO,
    @JsonKey(name: 'sap_code') this.materialCode,
    @JsonKey(name: 'description') this.productName,
    @JsonKey(name: 'qty') this.qtySticker,
    @JsonKey(name: 'uom') this.uom,
    @JsonKey(name: 'items') final List<HardwarePackingItem> items = const [],
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    this.mesStickerImage,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<String> deletedLines = const [],
  }) : _items = items,
       _deletedLines = deletedLines;

  factory _$HardwarePackingItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$HardwarePackingItemImplFromJson(json);

  @override
  @JsonKey(name: 'document_type')
  final String? documentType;
  @override
  @JsonKey(name: 'order_number')
  final String? orderNumber;
  @override
  @JsonKey(name: 'print_date')
  final String? printDate;
  @override
  @JsonKey(name: 'mes_number')
  final String? mesBarCode;
  @override
  @JsonKey(name: 'box_type')
  final String? boxType;
  @override
  @JsonKey(name: 'page')
  final String? page;
  @override
  @JsonKey(name: 'box')
  final String? box;
  @override
  @JsonKey(name: 'sr_no')
  final int? slNO;
  @override
  @JsonKey(name: 'sap_code')
  final String? materialCode;
  @override
  @JsonKey(name: 'description')
  final String? productName;
  @override
  @JsonKey(name: 'qty')
  final int? qtySticker;
  @override
  @JsonKey(name: 'uom')
  final String? uom;
  final List<HardwarePackingItem> _items;
  @override
  @JsonKey(name: 'items')
  List<HardwarePackingItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  final File? mesStickerImage;
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
    return 'HardwarePackingItem(documentType: $documentType, orderNumber: $orderNumber, printDate: $printDate, mesBarCode: $mesBarCode, boxType: $boxType, page: $page, box: $box, slNO: $slNO, materialCode: $materialCode, productName: $productName, qtySticker: $qtySticker, uom: $uom, items: $items, mesStickerImage: $mesStickerImage, deletedLines: $deletedLines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HardwarePackingItemImpl &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.printDate, printDate) ||
                other.printDate == printDate) &&
            (identical(other.mesBarCode, mesBarCode) ||
                other.mesBarCode == mesBarCode) &&
            (identical(other.boxType, boxType) || other.boxType == boxType) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.box, box) || other.box == box) &&
            (identical(other.slNO, slNO) || other.slNO == slNO) &&
            (identical(other.materialCode, materialCode) ||
                other.materialCode == materialCode) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.qtySticker, qtySticker) ||
                other.qtySticker == qtySticker) &&
            (identical(other.uom, uom) || other.uom == uom) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.mesStickerImage, mesStickerImage) ||
                other.mesStickerImage == mesStickerImage) &&
            const DeepCollectionEquality().equals(
              other._deletedLines,
              _deletedLines,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    documentType,
    orderNumber,
    printDate,
    mesBarCode,
    boxType,
    page,
    box,
    slNO,
    materialCode,
    productName,
    qtySticker,
    uom,
    const DeepCollectionEquality().hash(_items),
    mesStickerImage,
    const DeepCollectionEquality().hash(_deletedLines),
  );

  /// Create a copy of HardwarePackingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HardwarePackingItemImplCopyWith<_$HardwarePackingItemImpl> get copyWith =>
      __$$HardwarePackingItemImplCopyWithImpl<_$HardwarePackingItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HardwarePackingItemImplToJson(this);
  }
}

abstract class _HardwarePackingItem implements HardwarePackingItem {
  const factory _HardwarePackingItem({
    @JsonKey(name: 'document_type') final String? documentType,
    @JsonKey(name: 'order_number') final String? orderNumber,
    @JsonKey(name: 'print_date') final String? printDate,
    @JsonKey(name: 'mes_number') final String? mesBarCode,
    @JsonKey(name: 'box_type') final String? boxType,
    @JsonKey(name: 'page') final String? page,
    @JsonKey(name: 'box') final String? box,
    @JsonKey(name: 'sr_no') final int? slNO,
    @JsonKey(name: 'sap_code') final String? materialCode,
    @JsonKey(name: 'description') final String? productName,
    @JsonKey(name: 'qty') final int? qtySticker,
    @JsonKey(name: 'uom') final String? uom,
    @JsonKey(name: 'items') final List<HardwarePackingItem> items,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final File? mesStickerImage,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<String> deletedLines,
  }) = _$HardwarePackingItemImpl;

  factory _HardwarePackingItem.fromJson(Map<String, dynamic> json) =
      _$HardwarePackingItemImpl.fromJson;

  @override
  @JsonKey(name: 'document_type')
  String? get documentType;
  @override
  @JsonKey(name: 'order_number')
  String? get orderNumber;
  @override
  @JsonKey(name: 'print_date')
  String? get printDate;
  @override
  @JsonKey(name: 'mes_number')
  String? get mesBarCode;
  @override
  @JsonKey(name: 'box_type')
  String? get boxType;
  @override
  @JsonKey(name: 'page')
  String? get page;
  @override
  @JsonKey(name: 'box')
  String? get box;
  @override
  @JsonKey(name: 'sr_no')
  int? get slNO;
  @override
  @JsonKey(name: 'sap_code')
  String? get materialCode;
  @override
  @JsonKey(name: 'description')
  String? get productName;
  @override
  @JsonKey(name: 'qty')
  int? get qtySticker;
  @override
  @JsonKey(name: 'uom')
  String? get uom;
  @override
  @JsonKey(name: 'items')
  List<HardwarePackingItem> get items;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get mesStickerImage;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get deletedLines;

  /// Create a copy of HardwarePackingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HardwarePackingItemImplCopyWith<_$HardwarePackingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
