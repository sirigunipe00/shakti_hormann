// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Storage _$StorageFromJson(Map<String, dynamic> json) {
  return _Storage.fromJson(json);
}

/// @nodoc
mixin _$Storage {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'stored_by')
  String? get storedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'storage_timestamp')
  String? get storageTimeStamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'remarks')
  String? get remarks => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_photo')
  String? get locationPhoto => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get locationPhotoImg => throw _privateConstructorUsedError;
  @JsonKey(name: 'zone_qr')
  String? get zoneQr => throw _privateConstructorUsedError;
  @JsonKey(name: 'pallet__box_qr_scan')
  String? get palletBoxQr => throw _privateConstructorUsedError;

  /// Serializes this Storage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Storage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StorageCopyWith<Storage> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StorageCopyWith<$Res> {
  factory $StorageCopyWith(Storage value, $Res Function(Storage) then) =
      _$StorageCopyWithImpl<$Res, Storage>;
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'stored_by') String? storedBy,
    @JsonKey(name: 'storage_timestamp') String? storageTimeStamp,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'location_photo') String? locationPhoto,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? locationPhotoImg,
    @JsonKey(name: 'zone_qr') String? zoneQr,
    @JsonKey(name: 'pallet__box_qr_scan') String? palletBoxQr,
  });
}

/// @nodoc
class _$StorageCopyWithImpl<$Res, $Val extends Storage>
    implements $StorageCopyWith<$Res> {
  _$StorageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Storage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? storedBy = freezed,
    Object? storageTimeStamp = freezed,
    Object? remarks = freezed,
    Object? locationPhoto = freezed,
    Object? locationPhotoImg = freezed,
    Object? zoneQr = freezed,
    Object? palletBoxQr = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            storageTimeStamp:
                freezed == storageTimeStamp
                    ? _value.storageTimeStamp
                    : storageTimeStamp // ignore: cast_nullable_to_non_nullable
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
            locationPhotoImg:
                freezed == locationPhotoImg
                    ? _value.locationPhotoImg
                    : locationPhotoImg // ignore: cast_nullable_to_non_nullable
                        as File?,
            zoneQr:
                freezed == zoneQr
                    ? _value.zoneQr
                    : zoneQr // ignore: cast_nullable_to_non_nullable
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
abstract class _$$StorageImplCopyWith<$Res> implements $StorageCopyWith<$Res> {
  factory _$$StorageImplCopyWith(
    _$StorageImpl value,
    $Res Function(_$StorageImpl) then,
  ) = __$$StorageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'stored_by') String? storedBy,
    @JsonKey(name: 'storage_timestamp') String? storageTimeStamp,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'location_photo') String? locationPhoto,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? locationPhotoImg,
    @JsonKey(name: 'zone_qr') String? zoneQr,
    @JsonKey(name: 'pallet__box_qr_scan') String? palletBoxQr,
  });
}

/// @nodoc
class __$$StorageImplCopyWithImpl<$Res>
    extends _$StorageCopyWithImpl<$Res, _$StorageImpl>
    implements _$$StorageImplCopyWith<$Res> {
  __$$StorageImplCopyWithImpl(
    _$StorageImpl _value,
    $Res Function(_$StorageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Storage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? storedBy = freezed,
    Object? storageTimeStamp = freezed,
    Object? remarks = freezed,
    Object? locationPhoto = freezed,
    Object? locationPhotoImg = freezed,
    Object? zoneQr = freezed,
    Object? palletBoxQr = freezed,
  }) {
    return _then(
      _$StorageImpl(
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
        storageTimeStamp:
            freezed == storageTimeStamp
                ? _value.storageTimeStamp
                : storageTimeStamp // ignore: cast_nullable_to_non_nullable
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
        locationPhotoImg:
            freezed == locationPhotoImg
                ? _value.locationPhotoImg
                : locationPhotoImg // ignore: cast_nullable_to_non_nullable
                    as File?,
        zoneQr:
            freezed == zoneQr
                ? _value.zoneQr
                : zoneQr // ignore: cast_nullable_to_non_nullable
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
class _$StorageImpl implements _Storage {
  const _$StorageImpl({
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'stored_by') this.storedBy,
    @JsonKey(name: 'storage_timestamp') this.storageTimeStamp,
    @JsonKey(name: 'remarks') this.remarks,
    @JsonKey(name: 'location_photo') this.locationPhoto,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    this.locationPhotoImg,
    @JsonKey(name: 'zone_qr') this.zoneQr,
    @JsonKey(name: 'pallet__box_qr_scan') this.palletBoxQr,
  });

  factory _$StorageImpl.fromJson(Map<String, dynamic> json) =>
      _$$StorageImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'stored_by')
  final String? storedBy;
  @override
  @JsonKey(name: 'storage_timestamp')
  final String? storageTimeStamp;
  @override
  @JsonKey(name: 'remarks')
  final String? remarks;
  @override
  @JsonKey(name: 'location_photo')
  final String? locationPhoto;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  final File? locationPhotoImg;
  @override
  @JsonKey(name: 'zone_qr')
  final String? zoneQr;
  @override
  @JsonKey(name: 'pallet__box_qr_scan')
  final String? palletBoxQr;

  @override
  String toString() {
    return 'Storage(name: $name, storedBy: $storedBy, storageTimeStamp: $storageTimeStamp, remarks: $remarks, locationPhoto: $locationPhoto, locationPhotoImg: $locationPhotoImg, zoneQr: $zoneQr, palletBoxQr: $palletBoxQr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.storedBy, storedBy) ||
                other.storedBy == storedBy) &&
            (identical(other.storageTimeStamp, storageTimeStamp) ||
                other.storageTimeStamp == storageTimeStamp) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.locationPhoto, locationPhoto) ||
                other.locationPhoto == locationPhoto) &&
            (identical(other.locationPhotoImg, locationPhotoImg) ||
                other.locationPhotoImg == locationPhotoImg) &&
            (identical(other.zoneQr, zoneQr) || other.zoneQr == zoneQr) &&
            (identical(other.palletBoxQr, palletBoxQr) ||
                other.palletBoxQr == palletBoxQr));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    storedBy,
    storageTimeStamp,
    remarks,
    locationPhoto,
    locationPhotoImg,
    zoneQr,
    palletBoxQr,
  );

  /// Create a copy of Storage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageImplCopyWith<_$StorageImpl> get copyWith =>
      __$$StorageImplCopyWithImpl<_$StorageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StorageImplToJson(this);
  }
}

abstract class _Storage implements Storage {
  const factory _Storage({
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'stored_by') final String? storedBy,
    @JsonKey(name: 'storage_timestamp') final String? storageTimeStamp,
    @JsonKey(name: 'remarks') final String? remarks,
    @JsonKey(name: 'location_photo') final String? locationPhoto,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final File? locationPhotoImg,
    @JsonKey(name: 'zone_qr') final String? zoneQr,
    @JsonKey(name: 'pallet__box_qr_scan') final String? palletBoxQr,
  }) = _$StorageImpl;

  factory _Storage.fromJson(Map<String, dynamic> json) = _$StorageImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'stored_by')
  String? get storedBy;
  @override
  @JsonKey(name: 'storage_timestamp')
  String? get storageTimeStamp;
  @override
  @JsonKey(name: 'remarks')
  String? get remarks;
  @override
  @JsonKey(name: 'location_photo')
  String? get locationPhoto;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get locationPhotoImg;
  @override
  @JsonKey(name: 'zone_qr')
  String? get zoneQr;
  @override
  @JsonKey(name: 'pallet__box_qr_scan')
  String? get palletBoxQr;

  /// Create a copy of Storage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageImplCopyWith<_$StorageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
