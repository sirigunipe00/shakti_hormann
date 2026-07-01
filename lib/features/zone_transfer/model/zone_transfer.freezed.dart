// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone_transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ZoneTransfer _$ZoneTransferFromJson(Map<String, dynamic> json) {
  return _ZoneTransfer.fromJson(json);
}

/// @nodoc
mixin _$ZoneTransfer {
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'stored_by')
  String? get storedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'old_zone_qr')
  String? get oldZone => throw _privateConstructorUsedError;
  @JsonKey(name: 'remarks')
  String? get remarks => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_photo')
  String? get locationPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'docstatus')
  int? get docStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order')
  String? get salesOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_zone_name')
  String? get newzoneName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_qty')
  int? get totalQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'creation')
  String? get creation => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get locationPhotoImg => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_zone_qr')
  String? get newzoneQr => throw _privateConstructorUsedError;
  @JsonKey(name: 'pallet__box_qr_scan')
  String? get palletBoxQr => throw _privateConstructorUsedError;

  /// Serializes this ZoneTransfer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ZoneTransfer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZoneTransferCopyWith<ZoneTransfer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZoneTransferCopyWith<$Res> {
  factory $ZoneTransferCopyWith(
    ZoneTransfer value,
    $Res Function(ZoneTransfer) then,
  ) = _$ZoneTransferCopyWithImpl<$Res, ZoneTransfer>;
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'stored_by') String? storedBy,
    @JsonKey(name: 'old_zone_qr') String? oldZone,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'location_photo') String? locationPhoto,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'sales_order') String? salesOrders,
    @JsonKey(name: 'new_zone_name') String? newzoneName,
    @JsonKey(name: 'total_qty') int? totalQty,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? locationPhotoImg,
    @JsonKey(name: 'new_zone_qr') String? newzoneQr,
    @JsonKey(name: 'pallet__box_qr_scan') String? palletBoxQr,
  });
}

/// @nodoc
class _$ZoneTransferCopyWithImpl<$Res, $Val extends ZoneTransfer>
    implements $ZoneTransferCopyWith<$Res> {
  _$ZoneTransferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ZoneTransfer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? storedBy = freezed,
    Object? oldZone = freezed,
    Object? remarks = freezed,
    Object? locationPhoto = freezed,
    Object? docStatus = freezed,
    Object? salesOrders = freezed,
    Object? newzoneName = freezed,
    Object? totalQty = freezed,
    Object? creation = freezed,
    Object? locationPhotoImg = freezed,
    Object? newzoneQr = freezed,
    Object? palletBoxQr = freezed,
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
            storedBy:
                freezed == storedBy
                    ? _value.storedBy
                    : storedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            oldZone:
                freezed == oldZone
                    ? _value.oldZone
                    : oldZone // ignore: cast_nullable_to_non_nullable
                        as String?,
            remarks:
                freezed == remarks
                    ? _value.remarks
                    : remarks // ignore: cast_nullable_to_non_nullable
                        as String?,
            locationPhoto:
                freezed == locationPhoto
                    ? _value.locationPhoto
                    : locationPhoto // ignore: cast_nullable_to_non_nullable
                        as String?,
            docStatus:
                freezed == docStatus
                    ? _value.docStatus
                    : docStatus // ignore: cast_nullable_to_non_nullable
                        as int?,
            salesOrders:
                freezed == salesOrders
                    ? _value.salesOrders
                    : salesOrders // ignore: cast_nullable_to_non_nullable
                        as String?,
            newzoneName:
                freezed == newzoneName
                    ? _value.newzoneName
                    : newzoneName // ignore: cast_nullable_to_non_nullable
                        as String?,
            totalQty:
                freezed == totalQty
                    ? _value.totalQty
                    : totalQty // ignore: cast_nullable_to_non_nullable
                        as int?,
            creation:
                freezed == creation
                    ? _value.creation
                    : creation // ignore: cast_nullable_to_non_nullable
                        as String?,
            locationPhotoImg:
                freezed == locationPhotoImg
                    ? _value.locationPhotoImg
                    : locationPhotoImg // ignore: cast_nullable_to_non_nullable
                        as File?,
            newzoneQr:
                freezed == newzoneQr
                    ? _value.newzoneQr
                    : newzoneQr // ignore: cast_nullable_to_non_nullable
                        as String?,
            palletBoxQr:
                freezed == palletBoxQr
                    ? _value.palletBoxQr
                    : palletBoxQr // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ZoneTransferImplCopyWith<$Res>
    implements $ZoneTransferCopyWith<$Res> {
  factory _$$ZoneTransferImplCopyWith(
    _$ZoneTransferImpl value,
    $Res Function(_$ZoneTransferImpl) then,
  ) = __$$ZoneTransferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'stored_by') String? storedBy,
    @JsonKey(name: 'old_zone_qr') String? oldZone,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'location_photo') String? locationPhoto,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'sales_order') String? salesOrders,
    @JsonKey(name: 'new_zone_name') String? newzoneName,
    @JsonKey(name: 'total_qty') int? totalQty,
    @JsonKey(name: 'creation') String? creation,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? locationPhotoImg,
    @JsonKey(name: 'new_zone_qr') String? newzoneQr,
    @JsonKey(name: 'pallet__box_qr_scan') String? palletBoxQr,
  });
}

/// @nodoc
class __$$ZoneTransferImplCopyWithImpl<$Res>
    extends _$ZoneTransferCopyWithImpl<$Res, _$ZoneTransferImpl>
    implements _$$ZoneTransferImplCopyWith<$Res> {
  __$$ZoneTransferImplCopyWithImpl(
    _$ZoneTransferImpl _value,
    $Res Function(_$ZoneTransferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ZoneTransfer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? storedBy = freezed,
    Object? oldZone = freezed,
    Object? remarks = freezed,
    Object? locationPhoto = freezed,
    Object? docStatus = freezed,
    Object? salesOrders = freezed,
    Object? newzoneName = freezed,
    Object? totalQty = freezed,
    Object? creation = freezed,
    Object? locationPhotoImg = freezed,
    Object? newzoneQr = freezed,
    Object? palletBoxQr = freezed,
  }) {
    return _then(
      _$ZoneTransferImpl(
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
        storedBy:
            freezed == storedBy
                ? _value.storedBy
                : storedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        oldZone:
            freezed == oldZone
                ? _value.oldZone
                : oldZone // ignore: cast_nullable_to_non_nullable
                    as String?,
        remarks:
            freezed == remarks
                ? _value.remarks
                : remarks // ignore: cast_nullable_to_non_nullable
                    as String?,
        locationPhoto:
            freezed == locationPhoto
                ? _value.locationPhoto
                : locationPhoto // ignore: cast_nullable_to_non_nullable
                    as String?,
        docStatus:
            freezed == docStatus
                ? _value.docStatus
                : docStatus // ignore: cast_nullable_to_non_nullable
                    as int?,
        salesOrders:
            freezed == salesOrders
                ? _value.salesOrders
                : salesOrders // ignore: cast_nullable_to_non_nullable
                    as String?,
        newzoneName:
            freezed == newzoneName
                ? _value.newzoneName
                : newzoneName // ignore: cast_nullable_to_non_nullable
                    as String?,
        totalQty:
            freezed == totalQty
                ? _value.totalQty
                : totalQty // ignore: cast_nullable_to_non_nullable
                    as int?,
        creation:
            freezed == creation
                ? _value.creation
                : creation // ignore: cast_nullable_to_non_nullable
                    as String?,
        locationPhotoImg:
            freezed == locationPhotoImg
                ? _value.locationPhotoImg
                : locationPhotoImg // ignore: cast_nullable_to_non_nullable
                    as File?,
        newzoneQr:
            freezed == newzoneQr
                ? _value.newzoneQr
                : newzoneQr // ignore: cast_nullable_to_non_nullable
                    as String?,
        palletBoxQr:
            freezed == palletBoxQr
                ? _value.palletBoxQr
                : palletBoxQr // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ZoneTransferImpl implements _ZoneTransfer {
  const _$ZoneTransferImpl({
    this.status,
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'stored_by') this.storedBy,
    @JsonKey(name: 'old_zone_qr') this.oldZone,
    @JsonKey(name: 'remarks') this.remarks,
    @JsonKey(name: 'location_photo') this.locationPhoto,
    @JsonKey(name: 'docstatus') this.docStatus,
    @JsonKey(name: 'sales_order') this.salesOrders,
    @JsonKey(name: 'new_zone_name') this.newzoneName,
    @JsonKey(name: 'total_qty') this.totalQty,
    @JsonKey(name: 'creation') this.creation,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    this.locationPhotoImg,
    @JsonKey(name: 'new_zone_qr') this.newzoneQr,
    @JsonKey(name: 'pallet__box_qr_scan') this.palletBoxQr,
  });

  factory _$ZoneTransferImpl.fromJson(Map<String, dynamic> json) =>
      _$$ZoneTransferImplFromJson(json);

  @override
  final String? status;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'stored_by')
  final String? storedBy;
  @override
  @JsonKey(name: 'old_zone_qr')
  final String? oldZone;
  @override
  @JsonKey(name: 'remarks')
  final String? remarks;
  @override
  @JsonKey(name: 'location_photo')
  final String? locationPhoto;
  @override
  @JsonKey(name: 'docstatus')
  final int? docStatus;
  @override
  @JsonKey(name: 'sales_order')
  final String? salesOrders;
  @override
  @JsonKey(name: 'new_zone_name')
  final String? newzoneName;
  @override
  @JsonKey(name: 'total_qty')
  final int? totalQty;
  @override
  @JsonKey(name: 'creation')
  final String? creation;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  final File? locationPhotoImg;
  @override
  @JsonKey(name: 'new_zone_qr')
  final String? newzoneQr;
  @override
  @JsonKey(name: 'pallet__box_qr_scan')
  final String? palletBoxQr;

  @override
  String toString() {
    return 'ZoneTransfer(status: $status, name: $name, storedBy: $storedBy, oldZone: $oldZone, remarks: $remarks, locationPhoto: $locationPhoto, docStatus: $docStatus, salesOrders: $salesOrders, newzoneName: $newzoneName, totalQty: $totalQty, creation: $creation, locationPhotoImg: $locationPhotoImg, newzoneQr: $newzoneQr, palletBoxQr: $palletBoxQr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZoneTransferImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.storedBy, storedBy) ||
                other.storedBy == storedBy) &&
            (identical(other.oldZone, oldZone) || other.oldZone == oldZone) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.locationPhoto, locationPhoto) ||
                other.locationPhoto == locationPhoto) &&
            (identical(other.docStatus, docStatus) ||
                other.docStatus == docStatus) &&
            (identical(other.salesOrders, salesOrders) ||
                other.salesOrders == salesOrders) &&
            (identical(other.newzoneName, newzoneName) ||
                other.newzoneName == newzoneName) &&
            (identical(other.totalQty, totalQty) ||
                other.totalQty == totalQty) &&
            (identical(other.creation, creation) ||
                other.creation == creation) &&
            (identical(other.locationPhotoImg, locationPhotoImg) ||
                other.locationPhotoImg == locationPhotoImg) &&
            (identical(other.newzoneQr, newzoneQr) ||
                other.newzoneQr == newzoneQr) &&
            (identical(other.palletBoxQr, palletBoxQr) ||
                other.palletBoxQr == palletBoxQr));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    name,
    storedBy,
    oldZone,
    remarks,
    locationPhoto,
    docStatus,
    salesOrders,
    newzoneName,
    totalQty,
    creation,
    locationPhotoImg,
    newzoneQr,
    palletBoxQr,
  );

  /// Create a copy of ZoneTransfer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZoneTransferImplCopyWith<_$ZoneTransferImpl> get copyWith =>
      __$$ZoneTransferImplCopyWithImpl<_$ZoneTransferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ZoneTransferImplToJson(this);
  }
}

abstract class _ZoneTransfer implements ZoneTransfer {
  const factory _ZoneTransfer({
    final String? status,
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'stored_by') final String? storedBy,
    @JsonKey(name: 'old_zone_qr') final String? oldZone,
    @JsonKey(name: 'remarks') final String? remarks,
    @JsonKey(name: 'location_photo') final String? locationPhoto,
    @JsonKey(name: 'docstatus') final int? docStatus,
    @JsonKey(name: 'sales_order') final String? salesOrders,
    @JsonKey(name: 'new_zone_name') final String? newzoneName,
    @JsonKey(name: 'total_qty') final int? totalQty,
    @JsonKey(name: 'creation') final String? creation,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final File? locationPhotoImg,
    @JsonKey(name: 'new_zone_qr') final String? newzoneQr,
    @JsonKey(name: 'pallet__box_qr_scan') final String? palletBoxQr,
  }) = _$ZoneTransferImpl;

  factory _ZoneTransfer.fromJson(Map<String, dynamic> json) =
      _$ZoneTransferImpl.fromJson;

  @override
  String? get status;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'stored_by')
  String? get storedBy;
  @override
  @JsonKey(name: 'old_zone_qr')
  String? get oldZone;
  @override
  @JsonKey(name: 'remarks')
  String? get remarks;
  @override
  @JsonKey(name: 'location_photo')
  String? get locationPhoto;
  @override
  @JsonKey(name: 'docstatus')
  int? get docStatus;
  @override
  @JsonKey(name: 'sales_order')
  String? get salesOrders;
  @override
  @JsonKey(name: 'new_zone_name')
  String? get newzoneName;
  @override
  @JsonKey(name: 'total_qty')
  int? get totalQty;
  @override
  @JsonKey(name: 'creation')
  String? get creation;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get locationPhotoImg;
  @override
  @JsonKey(name: 'new_zone_qr')
  String? get newzoneQr;
  @override
  @JsonKey(name: 'pallet__box_qr_scan')
  String? get palletBoxQr;

  /// Create a copy of ZoneTransfer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZoneTransferImplCopyWith<_$ZoneTransferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
