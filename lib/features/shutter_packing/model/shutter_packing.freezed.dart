// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shutter_packing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShutterPacking _$ShutterPackingFromJson(Map<String, dynamic> json) {
  return _ShutterPacking.fromJson(json);
}

/// @nodoc
mixin _$ShutterPacking {
  String? get status => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'packing_date')
  String? get packingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift')
  String? get shift => throw _privateConstructorUsedError;
  @JsonKey(name: 'operator')
  String? get operator => throw _privateConstructorUsedError;
  @JsonKey(name: 'pallet_no')
  String? get palletNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'pallet_photo')
  String? get palletPhoto => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get palletPhotoImg => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_shutters_on_pallet')
  int? get totalShuttersOnPallet => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_boxes_on_pallet')
  int? get totalBoxesOnPallet => throw _privateConstructorUsedError;
  @JsonKey(name: 'pallet_qr_printed')
  int? get palletQrPrinted => throw _privateConstructorUsedError;
  @JsonKey(name: 'remarks')
  String? get remarks => throw _privateConstructorUsedError;
  @JsonKey(name: 'amended_from')
  String? get amendedFrom => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get deletedLines => throw _privateConstructorUsedError;

  /// Serializes this ShutterPacking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShutterPacking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShutterPackingCopyWith<ShutterPacking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShutterPackingCopyWith<$Res> {
  factory $ShutterPackingCopyWith(
    ShutterPacking value,
    $Res Function(ShutterPacking) then,
  ) = _$ShutterPackingCopyWithImpl<$Res, ShutterPacking>;
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'packing_date') String? packingDate,
    @JsonKey(name: 'shift') String? shift,
    @JsonKey(name: 'operator') String? operator,
    @JsonKey(name: 'pallet_no') String? palletNo,
    @JsonKey(name: 'pallet_photo') String? palletPhoto,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? palletPhotoImg,
    @JsonKey(name: 'total_shutters_on_pallet') int? totalShuttersOnPallet,
    @JsonKey(name: 'total_boxes_on_pallet') int? totalBoxesOnPallet,
    @JsonKey(name: 'pallet_qr_printed') int? palletQrPrinted,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'amended_from') String? amendedFrom,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<String> deletedLines,
  });
}

/// @nodoc
class _$ShutterPackingCopyWithImpl<$Res, $Val extends ShutterPacking>
    implements $ShutterPackingCopyWith<$Res> {
  _$ShutterPackingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShutterPacking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? owner = freezed,
    Object? creation = freezed,
    Object? modified = freezed,
    Object? modifiedBy = freezed,
    Object? docStatus = freezed,
    Object? idx = freezed,
    Object? packingDate = freezed,
    Object? shift = freezed,
    Object? operator = freezed,
    Object? palletNo = freezed,
    Object? palletPhoto = freezed,
    Object? palletPhotoImg = freezed,
    Object? totalShuttersOnPallet = freezed,
    Object? totalBoxesOnPallet = freezed,
    Object? palletQrPrinted = freezed,
    Object? remarks = freezed,
    Object? amendedFrom = freezed,
    Object? deletedLines = null,
  }) {
    return _then(
      _value.copyWith(
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
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
            packingDate:
                freezed == packingDate
                    ? _value.packingDate
                    : packingDate // ignore: cast_nullable_to_non_nullable
                        as String?,
            shift:
                freezed == shift
                    ? _value.shift
                    : shift // ignore: cast_nullable_to_non_nullable
                        as String?,
            operator:
                freezed == operator
                    ? _value.operator
                    : operator // ignore: cast_nullable_to_non_nullable
                        as String?,
            palletNo:
                freezed == palletNo
                    ? _value.palletNo
                    : palletNo // ignore: cast_nullable_to_non_nullable
                        as String?,
            palletPhoto:
                freezed == palletPhoto
                    ? _value.palletPhoto
                    : palletPhoto // ignore: cast_nullable_to_non_nullable
                        as String?,
            palletPhotoImg:
                freezed == palletPhotoImg
                    ? _value.palletPhotoImg
                    : palletPhotoImg // ignore: cast_nullable_to_non_nullable
                        as File?,
            totalShuttersOnPallet:
                freezed == totalShuttersOnPallet
                    ? _value.totalShuttersOnPallet
                    : totalShuttersOnPallet // ignore: cast_nullable_to_non_nullable
                        as int?,
            totalBoxesOnPallet:
                freezed == totalBoxesOnPallet
                    ? _value.totalBoxesOnPallet
                    : totalBoxesOnPallet // ignore: cast_nullable_to_non_nullable
                        as int?,
            palletQrPrinted:
                freezed == palletQrPrinted
                    ? _value.palletQrPrinted
                    : palletQrPrinted // ignore: cast_nullable_to_non_nullable
                        as int?,
            remarks:
                freezed == remarks
                    ? _value.remarks
                    : remarks // ignore: cast_nullable_to_non_nullable
                        as String?,
            amendedFrom:
                freezed == amendedFrom
                    ? _value.amendedFrom
                    : amendedFrom // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ShutterPackingImplCopyWith<$Res>
    implements $ShutterPackingCopyWith<$Res> {
  factory _$$ShutterPackingImplCopyWith(
    _$ShutterPackingImpl value,
    $Res Function(_$ShutterPackingImpl) then,
  ) = __$$ShutterPackingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(name: 'modified') String? modified,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'packing_date') String? packingDate,
    @JsonKey(name: 'shift') String? shift,
    @JsonKey(name: 'operator') String? operator,
    @JsonKey(name: 'pallet_no') String? palletNo,
    @JsonKey(name: 'pallet_photo') String? palletPhoto,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? palletPhotoImg,
    @JsonKey(name: 'total_shutters_on_pallet') int? totalShuttersOnPallet,
    @JsonKey(name: 'total_boxes_on_pallet') int? totalBoxesOnPallet,
    @JsonKey(name: 'pallet_qr_printed') int? palletQrPrinted,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'amended_from') String? amendedFrom,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<String> deletedLines,
  });
}

/// @nodoc
class __$$ShutterPackingImplCopyWithImpl<$Res>
    extends _$ShutterPackingCopyWithImpl<$Res, _$ShutterPackingImpl>
    implements _$$ShutterPackingImplCopyWith<$Res> {
  __$$ShutterPackingImplCopyWithImpl(
    _$ShutterPackingImpl _value,
    $Res Function(_$ShutterPackingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShutterPacking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? owner = freezed,
    Object? creation = freezed,
    Object? modified = freezed,
    Object? modifiedBy = freezed,
    Object? docStatus = freezed,
    Object? idx = freezed,
    Object? packingDate = freezed,
    Object? shift = freezed,
    Object? operator = freezed,
    Object? palletNo = freezed,
    Object? palletPhoto = freezed,
    Object? palletPhotoImg = freezed,
    Object? totalShuttersOnPallet = freezed,
    Object? totalBoxesOnPallet = freezed,
    Object? palletQrPrinted = freezed,
    Object? remarks = freezed,
    Object? amendedFrom = freezed,
    Object? deletedLines = null,
  }) {
    return _then(
      _$ShutterPackingImpl(
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
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
        packingDate:
            freezed == packingDate
                ? _value.packingDate
                : packingDate // ignore: cast_nullable_to_non_nullable
                    as String?,
        shift:
            freezed == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                    as String?,
        operator:
            freezed == operator
                ? _value.operator
                : operator // ignore: cast_nullable_to_non_nullable
                    as String?,
        palletNo:
            freezed == palletNo
                ? _value.palletNo
                : palletNo // ignore: cast_nullable_to_non_nullable
                    as String?,
        palletPhoto:
            freezed == palletPhoto
                ? _value.palletPhoto
                : palletPhoto // ignore: cast_nullable_to_non_nullable
                    as String?,
        palletPhotoImg:
            freezed == palletPhotoImg
                ? _value.palletPhotoImg
                : palletPhotoImg // ignore: cast_nullable_to_non_nullable
                    as File?,
        totalShuttersOnPallet:
            freezed == totalShuttersOnPallet
                ? _value.totalShuttersOnPallet
                : totalShuttersOnPallet // ignore: cast_nullable_to_non_nullable
                    as int?,
        totalBoxesOnPallet:
            freezed == totalBoxesOnPallet
                ? _value.totalBoxesOnPallet
                : totalBoxesOnPallet // ignore: cast_nullable_to_non_nullable
                    as int?,
        palletQrPrinted:
            freezed == palletQrPrinted
                ? _value.palletQrPrinted
                : palletQrPrinted // ignore: cast_nullable_to_non_nullable
                    as int?,
        remarks:
            freezed == remarks
                ? _value.remarks
                : remarks // ignore: cast_nullable_to_non_nullable
                    as String?,
        amendedFrom:
            freezed == amendedFrom
                ? _value.amendedFrom
                : amendedFrom // ignore: cast_nullable_to_non_nullable
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
class _$ShutterPackingImpl implements _ShutterPacking {
  const _$ShutterPackingImpl({
    this.status,
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'owner') this.owner,
    @JsonKey(name: 'creation') this.creation,
    @JsonKey(name: 'modified') this.modified,
    @JsonKey(name: 'modified_by') this.modifiedBy,
    @JsonKey(name: 'docstatus') this.docStatus,
    @JsonKey(name: 'idx') this.idx,
    @JsonKey(name: 'packing_date') this.packingDate,
    @JsonKey(name: 'shift') this.shift,
    @JsonKey(name: 'operator') this.operator,
    @JsonKey(name: 'pallet_no') this.palletNo,
    @JsonKey(name: 'pallet_photo') this.palletPhoto,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    this.palletPhotoImg,
    @JsonKey(name: 'total_shutters_on_pallet') this.totalShuttersOnPallet,
    @JsonKey(name: 'total_boxes_on_pallet') this.totalBoxesOnPallet,
    @JsonKey(name: 'pallet_qr_printed') this.palletQrPrinted,
    @JsonKey(name: 'remarks') this.remarks,
    @JsonKey(name: 'amended_from') this.amendedFrom,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<String> deletedLines = const <String>[],
  }) : _deletedLines = deletedLines;

  factory _$ShutterPackingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShutterPackingImplFromJson(json);

  @override
  final String? status;
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
  @JsonKey(name: 'packing_date')
  final String? packingDate;
  @override
  @JsonKey(name: 'shift')
  final String? shift;
  @override
  @JsonKey(name: 'operator')
  final String? operator;
  @override
  @JsonKey(name: 'pallet_no')
  final String? palletNo;
  @override
  @JsonKey(name: 'pallet_photo')
  final String? palletPhoto;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  final File? palletPhotoImg;
  @override
  @JsonKey(name: 'total_shutters_on_pallet')
  final int? totalShuttersOnPallet;
  @override
  @JsonKey(name: 'total_boxes_on_pallet')
  final int? totalBoxesOnPallet;
  @override
  @JsonKey(name: 'pallet_qr_printed')
  final int? palletQrPrinted;
  @override
  @JsonKey(name: 'remarks')
  final String? remarks;
  @override
  @JsonKey(name: 'amended_from')
  final String? amendedFrom;
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
    return 'ShutterPacking(status: $status, name: $name, owner: $owner, creation: $creation, modified: $modified, modifiedBy: $modifiedBy, docStatus: $docStatus, idx: $idx, packingDate: $packingDate, shift: $shift, operator: $operator, palletNo: $palletNo, palletPhoto: $palletPhoto, palletPhotoImg: $palletPhotoImg, totalShuttersOnPallet: $totalShuttersOnPallet, totalBoxesOnPallet: $totalBoxesOnPallet, palletQrPrinted: $palletQrPrinted, remarks: $remarks, amendedFrom: $amendedFrom, deletedLines: $deletedLines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShutterPackingImpl &&
            (identical(other.status, status) || other.status == status) &&
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
            (identical(other.packingDate, packingDate) ||
                other.packingDate == packingDate) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.palletNo, palletNo) ||
                other.palletNo == palletNo) &&
            (identical(other.palletPhoto, palletPhoto) ||
                other.palletPhoto == palletPhoto) &&
            (identical(other.palletPhotoImg, palletPhotoImg) ||
                other.palletPhotoImg == palletPhotoImg) &&
            (identical(other.totalShuttersOnPallet, totalShuttersOnPallet) ||
                other.totalShuttersOnPallet == totalShuttersOnPallet) &&
            (identical(other.totalBoxesOnPallet, totalBoxesOnPallet) ||
                other.totalBoxesOnPallet == totalBoxesOnPallet) &&
            (identical(other.palletQrPrinted, palletQrPrinted) ||
                other.palletQrPrinted == palletQrPrinted) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.amendedFrom, amendedFrom) ||
                other.amendedFrom == amendedFrom) &&
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
    name,
    owner,
    creation,
    modified,
    modifiedBy,
    docStatus,
    idx,
    packingDate,
    shift,
    operator,
    palletNo,
    palletPhoto,
    palletPhotoImg,
    totalShuttersOnPallet,
    totalBoxesOnPallet,
    palletQrPrinted,
    remarks,
    amendedFrom,
    const DeepCollectionEquality().hash(_deletedLines),
  ]);

  /// Create a copy of ShutterPacking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShutterPackingImplCopyWith<_$ShutterPackingImpl> get copyWith =>
      __$$ShutterPackingImplCopyWithImpl<_$ShutterPackingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShutterPackingImplToJson(this);
  }
}

abstract class _ShutterPacking implements ShutterPacking {
  const factory _ShutterPacking({
    final String? status,
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'owner') final String? owner,
    @JsonKey(name: 'creation') final String? creation,
    @JsonKey(name: 'modified') final String? modified,
    @JsonKey(name: 'modified_by') final String? modifiedBy,
    @JsonKey(name: 'docstatus') final int? docStatus,
    @JsonKey(name: 'idx') final int? idx,
    @JsonKey(name: 'packing_date') final String? packingDate,
    @JsonKey(name: 'shift') final String? shift,
    @JsonKey(name: 'operator') final String? operator,
    @JsonKey(name: 'pallet_no') final String? palletNo,
    @JsonKey(name: 'pallet_photo') final String? palletPhoto,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final File? palletPhotoImg,
    @JsonKey(name: 'total_shutters_on_pallet') final int? totalShuttersOnPallet,
    @JsonKey(name: 'total_boxes_on_pallet') final int? totalBoxesOnPallet,
    @JsonKey(name: 'pallet_qr_printed') final int? palletQrPrinted,
    @JsonKey(name: 'remarks') final String? remarks,
    @JsonKey(name: 'amended_from') final String? amendedFrom,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<String> deletedLines,
  }) = _$ShutterPackingImpl;

  factory _ShutterPacking.fromJson(Map<String, dynamic> json) =
      _$ShutterPackingImpl.fromJson;

  @override
  String? get status;
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
  @JsonKey(name: 'packing_date')
  String? get packingDate;
  @override
  @JsonKey(name: 'shift')
  String? get shift;
  @override
  @JsonKey(name: 'operator')
  String? get operator;
  @override
  @JsonKey(name: 'pallet_no')
  String? get palletNo;
  @override
  @JsonKey(name: 'pallet_photo')
  String? get palletPhoto;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get palletPhotoImg;
  @override
  @JsonKey(name: 'total_shutters_on_pallet')
  int? get totalShuttersOnPallet;
  @override
  @JsonKey(name: 'total_boxes_on_pallet')
  int? get totalBoxesOnPallet;
  @override
  @JsonKey(name: 'pallet_qr_printed')
  int? get palletQrPrinted;
  @override
  @JsonKey(name: 'remarks')
  String? get remarks;
  @override
  @JsonKey(name: 'amended_from')
  String? get amendedFrom;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get deletedLines;

  /// Create a copy of ShutterPacking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShutterPackingImplCopyWith<_$ShutterPackingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
