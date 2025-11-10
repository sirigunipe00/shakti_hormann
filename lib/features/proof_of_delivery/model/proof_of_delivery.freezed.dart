// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proof_of_delivery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProofOfDelivery _$ProofOfDeliveryFromJson(Map<String, dynamic> json) {
  return _ProofOfDelivery.fromJson(json);
}

/// @nodoc
mixin _$ProofOfDelivery {
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'docstatus')
  int? get docStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'pod_date', defaultValue: '')
  String? get podDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_invoice_no')
  String? get salesInvoice => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_invoice_date')
  String? get salesInvoiceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_name')
  String? get plantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'geo_longitude')
  String? get geoLongitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'pod_photo')
  String? get podPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'unloading_photo_1')
  String? get unloadingPhoto1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'unloading_photo_2')
  String? get unloadingPhoto2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'geo_latitude')
  String? get geoLatitude => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get podPhotoImg => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get unloadingPhotoImg1 => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get unloadingPhotoImg2 => throw _privateConstructorUsedError;

  /// Serializes this ProofOfDelivery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProofOfDelivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProofOfDeliveryCopyWith<ProofOfDelivery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProofOfDeliveryCopyWith<$Res> {
  factory $ProofOfDeliveryCopyWith(
    ProofOfDelivery value,
    $Res Function(ProofOfDelivery) then,
  ) = _$ProofOfDeliveryCopyWithImpl<$Res, ProofOfDelivery>;
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'pod_date', defaultValue: '') String? podDate,
    @JsonKey(name: 'sales_invoice_no') String? salesInvoice,
    @JsonKey(name: 'sales_invoice_date') String? salesInvoiceDate,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'geo_longitude') String? geoLongitude,
    @JsonKey(name: 'pod_photo') String? podPhoto,
    @JsonKey(name: 'unloading_photo_1') String? unloadingPhoto1,
    @JsonKey(name: 'unloading_photo_2') String? unloadingPhoto2,
    @JsonKey(name: 'geo_latitude') String? geoLatitude,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? podPhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? unloadingPhotoImg1,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? unloadingPhotoImg2,
  });
}

/// @nodoc
class _$ProofOfDeliveryCopyWithImpl<$Res, $Val extends ProofOfDelivery>
    implements $ProofOfDeliveryCopyWith<$Res> {
  _$ProofOfDeliveryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProofOfDelivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? docStatus = freezed,
    Object? podDate = freezed,
    Object? salesInvoice = freezed,
    Object? salesInvoiceDate = freezed,
    Object? customerName = freezed,
    Object? plantName = freezed,
    Object? geoLongitude = freezed,
    Object? podPhoto = freezed,
    Object? unloadingPhoto1 = freezed,
    Object? unloadingPhoto2 = freezed,
    Object? geoLatitude = freezed,
    Object? podPhotoImg = freezed,
    Object? unloadingPhotoImg1 = freezed,
    Object? unloadingPhotoImg2 = freezed,
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
            docStatus:
                freezed == docStatus
                    ? _value.docStatus
                    : docStatus // ignore: cast_nullable_to_non_nullable
                        as int?,
            podDate:
                freezed == podDate
                    ? _value.podDate
                    : podDate // ignore: cast_nullable_to_non_nullable
                        as String?,
            salesInvoice:
                freezed == salesInvoice
                    ? _value.salesInvoice
                    : salesInvoice // ignore: cast_nullable_to_non_nullable
                        as String?,
            salesInvoiceDate:
                freezed == salesInvoiceDate
                    ? _value.salesInvoiceDate
                    : salesInvoiceDate // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerName:
                freezed == customerName
                    ? _value.customerName
                    : customerName // ignore: cast_nullable_to_non_nullable
                        as String?,
            plantName:
                freezed == plantName
                    ? _value.plantName
                    : plantName // ignore: cast_nullable_to_non_nullable
                        as String?,
            geoLongitude:
                freezed == geoLongitude
                    ? _value.geoLongitude
                    : geoLongitude // ignore: cast_nullable_to_non_nullable
                        as String?,
            podPhoto:
                freezed == podPhoto
                    ? _value.podPhoto
                    : podPhoto // ignore: cast_nullable_to_non_nullable
                        as String?,
            unloadingPhoto1:
                freezed == unloadingPhoto1
                    ? _value.unloadingPhoto1
                    : unloadingPhoto1 // ignore: cast_nullable_to_non_nullable
                        as String?,
            unloadingPhoto2:
                freezed == unloadingPhoto2
                    ? _value.unloadingPhoto2
                    : unloadingPhoto2 // ignore: cast_nullable_to_non_nullable
                        as String?,
            geoLatitude:
                freezed == geoLatitude
                    ? _value.geoLatitude
                    : geoLatitude // ignore: cast_nullable_to_non_nullable
                        as String?,
            podPhotoImg:
                freezed == podPhotoImg
                    ? _value.podPhotoImg
                    : podPhotoImg // ignore: cast_nullable_to_non_nullable
                        as File?,
            unloadingPhotoImg1:
                freezed == unloadingPhotoImg1
                    ? _value.unloadingPhotoImg1
                    : unloadingPhotoImg1 // ignore: cast_nullable_to_non_nullable
                        as File?,
            unloadingPhotoImg2:
                freezed == unloadingPhotoImg2
                    ? _value.unloadingPhotoImg2
                    : unloadingPhotoImg2 // ignore: cast_nullable_to_non_nullable
                        as File?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProofOfDeliveryImplCopyWith<$Res>
    implements $ProofOfDeliveryCopyWith<$Res> {
  factory _$$ProofOfDeliveryImplCopyWith(
    _$ProofOfDeliveryImpl value,
    $Res Function(_$ProofOfDeliveryImpl) then,
  ) = __$$ProofOfDeliveryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'pod_date', defaultValue: '') String? podDate,
    @JsonKey(name: 'sales_invoice_no') String? salesInvoice,
    @JsonKey(name: 'sales_invoice_date') String? salesInvoiceDate,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'geo_longitude') String? geoLongitude,
    @JsonKey(name: 'pod_photo') String? podPhoto,
    @JsonKey(name: 'unloading_photo_1') String? unloadingPhoto1,
    @JsonKey(name: 'unloading_photo_2') String? unloadingPhoto2,
    @JsonKey(name: 'geo_latitude') String? geoLatitude,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? podPhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? unloadingPhotoImg1,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? unloadingPhotoImg2,
  });
}

/// @nodoc
class __$$ProofOfDeliveryImplCopyWithImpl<$Res>
    extends _$ProofOfDeliveryCopyWithImpl<$Res, _$ProofOfDeliveryImpl>
    implements _$$ProofOfDeliveryImplCopyWith<$Res> {
  __$$ProofOfDeliveryImplCopyWithImpl(
    _$ProofOfDeliveryImpl _value,
    $Res Function(_$ProofOfDeliveryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProofOfDelivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? docStatus = freezed,
    Object? podDate = freezed,
    Object? salesInvoice = freezed,
    Object? salesInvoiceDate = freezed,
    Object? customerName = freezed,
    Object? plantName = freezed,
    Object? geoLongitude = freezed,
    Object? podPhoto = freezed,
    Object? unloadingPhoto1 = freezed,
    Object? unloadingPhoto2 = freezed,
    Object? geoLatitude = freezed,
    Object? podPhotoImg = freezed,
    Object? unloadingPhotoImg1 = freezed,
    Object? unloadingPhotoImg2 = freezed,
  }) {
    return _then(
      _$ProofOfDeliveryImpl(
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
        docStatus:
            freezed == docStatus
                ? _value.docStatus
                : docStatus // ignore: cast_nullable_to_non_nullable
                    as int?,
        podDate:
            freezed == podDate
                ? _value.podDate
                : podDate // ignore: cast_nullable_to_non_nullable
                    as String?,
        salesInvoice:
            freezed == salesInvoice
                ? _value.salesInvoice
                : salesInvoice // ignore: cast_nullable_to_non_nullable
                    as String?,
        salesInvoiceDate:
            freezed == salesInvoiceDate
                ? _value.salesInvoiceDate
                : salesInvoiceDate // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerName:
            freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                    as String?,
        plantName:
            freezed == plantName
                ? _value.plantName
                : plantName // ignore: cast_nullable_to_non_nullable
                    as String?,
        geoLongitude:
            freezed == geoLongitude
                ? _value.geoLongitude
                : geoLongitude // ignore: cast_nullable_to_non_nullable
                    as String?,
        podPhoto:
            freezed == podPhoto
                ? _value.podPhoto
                : podPhoto // ignore: cast_nullable_to_non_nullable
                    as String?,
        unloadingPhoto1:
            freezed == unloadingPhoto1
                ? _value.unloadingPhoto1
                : unloadingPhoto1 // ignore: cast_nullable_to_non_nullable
                    as String?,
        unloadingPhoto2:
            freezed == unloadingPhoto2
                ? _value.unloadingPhoto2
                : unloadingPhoto2 // ignore: cast_nullable_to_non_nullable
                    as String?,
        geoLatitude:
            freezed == geoLatitude
                ? _value.geoLatitude
                : geoLatitude // ignore: cast_nullable_to_non_nullable
                    as String?,
        podPhotoImg:
            freezed == podPhotoImg
                ? _value.podPhotoImg
                : podPhotoImg // ignore: cast_nullable_to_non_nullable
                    as File?,
        unloadingPhotoImg1:
            freezed == unloadingPhotoImg1
                ? _value.unloadingPhotoImg1
                : unloadingPhotoImg1 // ignore: cast_nullable_to_non_nullable
                    as File?,
        unloadingPhotoImg2:
            freezed == unloadingPhotoImg2
                ? _value.unloadingPhotoImg2
                : unloadingPhotoImg2 // ignore: cast_nullable_to_non_nullable
                    as File?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProofOfDeliveryImpl implements _ProofOfDelivery {
  const _$ProofOfDeliveryImpl({
    this.status,
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'docstatus') this.docStatus,
    @JsonKey(name: 'pod_date', defaultValue: '') this.podDate,
    @JsonKey(name: 'sales_invoice_no') this.salesInvoice,
    @JsonKey(name: 'sales_invoice_date') this.salesInvoiceDate,
    @JsonKey(name: 'customer_name') this.customerName,
    @JsonKey(name: 'plant_name') this.plantName,
    @JsonKey(name: 'geo_longitude') this.geoLongitude,
    @JsonKey(name: 'pod_photo') this.podPhoto,
    @JsonKey(name: 'unloading_photo_1') this.unloadingPhoto1,
    @JsonKey(name: 'unloading_photo_2') this.unloadingPhoto2,
    @JsonKey(name: 'geo_latitude') this.geoLatitude,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    this.podPhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    this.unloadingPhotoImg1,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    this.unloadingPhotoImg2,
  });

  factory _$ProofOfDeliveryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProofOfDeliveryImplFromJson(json);

  @override
  final String? status;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'docstatus')
  final int? docStatus;
  @override
  @JsonKey(name: 'pod_date', defaultValue: '')
  final String? podDate;
  @override
  @JsonKey(name: 'sales_invoice_no')
  final String? salesInvoice;
  @override
  @JsonKey(name: 'sales_invoice_date')
  final String? salesInvoiceDate;
  @override
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @override
  @JsonKey(name: 'plant_name')
  final String? plantName;
  @override
  @JsonKey(name: 'geo_longitude')
  final String? geoLongitude;
  @override
  @JsonKey(name: 'pod_photo')
  final String? podPhoto;
  @override
  @JsonKey(name: 'unloading_photo_1')
  final String? unloadingPhoto1;
  @override
  @JsonKey(name: 'unloading_photo_2')
  final String? unloadingPhoto2;
  @override
  @JsonKey(name: 'geo_latitude')
  final String? geoLatitude;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  final File? podPhotoImg;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  final File? unloadingPhotoImg1;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  final File? unloadingPhotoImg2;

  @override
  String toString() {
    return 'ProofOfDelivery(status: $status, name: $name, docStatus: $docStatus, podDate: $podDate, salesInvoice: $salesInvoice, salesInvoiceDate: $salesInvoiceDate, customerName: $customerName, plantName: $plantName, geoLongitude: $geoLongitude, podPhoto: $podPhoto, unloadingPhoto1: $unloadingPhoto1, unloadingPhoto2: $unloadingPhoto2, geoLatitude: $geoLatitude, podPhotoImg: $podPhotoImg, unloadingPhotoImg1: $unloadingPhotoImg1, unloadingPhotoImg2: $unloadingPhotoImg2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProofOfDeliveryImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.docStatus, docStatus) ||
                other.docStatus == docStatus) &&
            (identical(other.podDate, podDate) || other.podDate == podDate) &&
            (identical(other.salesInvoice, salesInvoice) ||
                other.salesInvoice == salesInvoice) &&
            (identical(other.salesInvoiceDate, salesInvoiceDate) ||
                other.salesInvoiceDate == salesInvoiceDate) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.plantName, plantName) ||
                other.plantName == plantName) &&
            (identical(other.geoLongitude, geoLongitude) ||
                other.geoLongitude == geoLongitude) &&
            (identical(other.podPhoto, podPhoto) ||
                other.podPhoto == podPhoto) &&
            (identical(other.unloadingPhoto1, unloadingPhoto1) ||
                other.unloadingPhoto1 == unloadingPhoto1) &&
            (identical(other.unloadingPhoto2, unloadingPhoto2) ||
                other.unloadingPhoto2 == unloadingPhoto2) &&
            (identical(other.geoLatitude, geoLatitude) ||
                other.geoLatitude == geoLatitude) &&
            (identical(other.podPhotoImg, podPhotoImg) ||
                other.podPhotoImg == podPhotoImg) &&
            (identical(other.unloadingPhotoImg1, unloadingPhotoImg1) ||
                other.unloadingPhotoImg1 == unloadingPhotoImg1) &&
            (identical(other.unloadingPhotoImg2, unloadingPhotoImg2) ||
                other.unloadingPhotoImg2 == unloadingPhotoImg2));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    name,
    docStatus,
    podDate,
    salesInvoice,
    salesInvoiceDate,
    customerName,
    plantName,
    geoLongitude,
    podPhoto,
    unloadingPhoto1,
    unloadingPhoto2,
    geoLatitude,
    podPhotoImg,
    unloadingPhotoImg1,
    unloadingPhotoImg2,
  );

  /// Create a copy of ProofOfDelivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProofOfDeliveryImplCopyWith<_$ProofOfDeliveryImpl> get copyWith =>
      __$$ProofOfDeliveryImplCopyWithImpl<_$ProofOfDeliveryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProofOfDeliveryImplToJson(this);
  }
}

abstract class _ProofOfDelivery implements ProofOfDelivery {
  const factory _ProofOfDelivery({
    final String? status,
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'docstatus') final int? docStatus,
    @JsonKey(name: 'pod_date', defaultValue: '') final String? podDate,
    @JsonKey(name: 'sales_invoice_no') final String? salesInvoice,
    @JsonKey(name: 'sales_invoice_date') final String? salesInvoiceDate,
    @JsonKey(name: 'customer_name') final String? customerName,
    @JsonKey(name: 'plant_name') final String? plantName,
    @JsonKey(name: 'geo_longitude') final String? geoLongitude,
    @JsonKey(name: 'pod_photo') final String? podPhoto,
    @JsonKey(name: 'unloading_photo_1') final String? unloadingPhoto1,
    @JsonKey(name: 'unloading_photo_2') final String? unloadingPhoto2,
    @JsonKey(name: 'geo_latitude') final String? geoLatitude,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final File? podPhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final File? unloadingPhotoImg1,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final File? unloadingPhotoImg2,
  }) = _$ProofOfDeliveryImpl;

  factory _ProofOfDelivery.fromJson(Map<String, dynamic> json) =
      _$ProofOfDeliveryImpl.fromJson;

  @override
  String? get status;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'docstatus')
  int? get docStatus;
  @override
  @JsonKey(name: 'pod_date', defaultValue: '')
  String? get podDate;
  @override
  @JsonKey(name: 'sales_invoice_no')
  String? get salesInvoice;
  @override
  @JsonKey(name: 'sales_invoice_date')
  String? get salesInvoiceDate;
  @override
  @JsonKey(name: 'customer_name')
  String? get customerName;
  @override
  @JsonKey(name: 'plant_name')
  String? get plantName;
  @override
  @JsonKey(name: 'geo_longitude')
  String? get geoLongitude;
  @override
  @JsonKey(name: 'pod_photo')
  String? get podPhoto;
  @override
  @JsonKey(name: 'unloading_photo_1')
  String? get unloadingPhoto1;
  @override
  @JsonKey(name: 'unloading_photo_2')
  String? get unloadingPhoto2;
  @override
  @JsonKey(name: 'geo_latitude')
  String? get geoLatitude;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get podPhotoImg;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get unloadingPhotoImg1;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get unloadingPhotoImg2;

  /// Create a copy of ProofOfDelivery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProofOfDeliveryImplCopyWith<_$ProofOfDeliveryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
