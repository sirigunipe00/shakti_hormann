// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gate_management_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GateManagementForm _$GateManagementFormFromJson(Map<String, dynamic> json) {
  return _GateManagementForm.fromJson(json);
}

/// @nodoc
mixin _$GateManagementForm {
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'docstatus')
  int? get docStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner')
  String? get owner => throw _privateConstructorUsedError;
  @JsonKey(name: 'creation')
  String? get modifiedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_name')
  String? get plantName => throw _privateConstructorUsedError; // @JsonKey(name: 'request_type') List<String>? requestType,
  @JsonKey(name: 'gate_entry_date')
  String? get gateeEntrydate => throw _privateConstructorUsedError;
  @JsonKey(name: 'gate_entry_time')
  String? get gateEntryTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'purpose__remarks')
  String? get remarks => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_no')
  String? get vehicleNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_type')
  String? get vehicleType => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_invoice_no')
  String? get vendorInvoiceNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_name')
  String? get driverName => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_mobile')
  String? get driverMobileNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'company__vendor_name')
  String? get vendorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'security_remarks')
  String? get securityRemarks => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_photo')
  String? get vehiclePhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_back_photo')
  String? get backPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'gate_exit_date')
  String? get gateExitdate => throw _privateConstructorUsedError;
  @JsonKey(name: 'gate_exit_time')
  String? get gateExitTime => throw _privateConstructorUsedError; // @JsonKey(name: 'document_photos') String? documentPhoto,
  @JsonKey(name: 'document_photos', fromJson: _stringOrListToStringList)
  List<String>? get invoicePhotos => throw _privateConstructorUsedError;
  @JsonKey(readValue: _extractRequestTypes)
  List<String>? get requestType => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get vehiclePhotoImg => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get backPhotoImg => throw _privateConstructorUsedError;
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  List<File>? get documentPhotoImg => throw _privateConstructorUsedError;

  /// Serializes this GateManagementForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GateManagementForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GateManagementFormCopyWith<GateManagementForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GateManagementFormCopyWith<$Res> {
  factory $GateManagementFormCopyWith(
    GateManagementForm value,
    $Res Function(GateManagementForm) then,
  ) = _$GateManagementFormCopyWithImpl<$Res, GateManagementForm>;
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? modifiedBy,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'gate_entry_date') String? gateeEntrydate,
    @JsonKey(name: 'gate_entry_time') String? gateEntryTime,
    @JsonKey(name: 'purpose__remarks') String? remarks,
    @JsonKey(name: 'vehicle_no') String? vehicleNo,
    @JsonKey(name: 'vehicle_type') String? vehicleType,
    @JsonKey(name: 'vendor_invoice_no') String? vendorInvoiceNo,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'driver_mobile') String? driverMobileNo,
    @JsonKey(name: 'company__vendor_name') String? vendorName,
    @JsonKey(name: 'security_remarks') String? securityRemarks,
    @JsonKey(name: 'vehicle_photo') String? vehiclePhoto,
    @JsonKey(name: 'vehicle_back_photo') String? backPhoto,
    @JsonKey(name: 'gate_exit_date') String? gateExitdate,
    @JsonKey(name: 'gate_exit_time') String? gateExitTime,
    @JsonKey(name: 'document_photos', fromJson: _stringOrListToStringList)
    List<String>? invoicePhotos,
    @JsonKey(readValue: _extractRequestTypes) List<String>? requestType,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? vehiclePhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? backPhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    List<File>? documentPhotoImg,
  });
}

/// @nodoc
class _$GateManagementFormCopyWithImpl<$Res, $Val extends GateManagementForm>
    implements $GateManagementFormCopyWith<$Res> {
  _$GateManagementFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GateManagementForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? docStatus = freezed,
    Object? owner = freezed,
    Object? modifiedBy = freezed,
    Object? plantName = freezed,
    Object? gateeEntrydate = freezed,
    Object? gateEntryTime = freezed,
    Object? remarks = freezed,
    Object? vehicleNo = freezed,
    Object? vehicleType = freezed,
    Object? vendorInvoiceNo = freezed,
    Object? driverName = freezed,
    Object? driverMobileNo = freezed,
    Object? vendorName = freezed,
    Object? securityRemarks = freezed,
    Object? vehiclePhoto = freezed,
    Object? backPhoto = freezed,
    Object? gateExitdate = freezed,
    Object? gateExitTime = freezed,
    Object? invoicePhotos = freezed,
    Object? requestType = freezed,
    Object? vehiclePhotoImg = freezed,
    Object? backPhotoImg = freezed,
    Object? documentPhotoImg = freezed,
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
            owner:
                freezed == owner
                    ? _value.owner
                    : owner // ignore: cast_nullable_to_non_nullable
                        as String?,
            modifiedBy:
                freezed == modifiedBy
                    ? _value.modifiedBy
                    : modifiedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            plantName:
                freezed == plantName
                    ? _value.plantName
                    : plantName // ignore: cast_nullable_to_non_nullable
                        as String?,
            gateeEntrydate:
                freezed == gateeEntrydate
                    ? _value.gateeEntrydate
                    : gateeEntrydate // ignore: cast_nullable_to_non_nullable
                        as String?,
            gateEntryTime:
                freezed == gateEntryTime
                    ? _value.gateEntryTime
                    : gateEntryTime // ignore: cast_nullable_to_non_nullable
                        as String?,
            remarks:
                freezed == remarks
                    ? _value.remarks
                    : remarks // ignore: cast_nullable_to_non_nullable
                        as String?,
            vehicleNo:
                freezed == vehicleNo
                    ? _value.vehicleNo
                    : vehicleNo // ignore: cast_nullable_to_non_nullable
                        as String?,
            vehicleType:
                freezed == vehicleType
                    ? _value.vehicleType
                    : vehicleType // ignore: cast_nullable_to_non_nullable
                        as String?,
            vendorInvoiceNo:
                freezed == vendorInvoiceNo
                    ? _value.vendorInvoiceNo
                    : vendorInvoiceNo // ignore: cast_nullable_to_non_nullable
                        as String?,
            driverName:
                freezed == driverName
                    ? _value.driverName
                    : driverName // ignore: cast_nullable_to_non_nullable
                        as String?,
            driverMobileNo:
                freezed == driverMobileNo
                    ? _value.driverMobileNo
                    : driverMobileNo // ignore: cast_nullable_to_non_nullable
                        as String?,
            vendorName:
                freezed == vendorName
                    ? _value.vendorName
                    : vendorName // ignore: cast_nullable_to_non_nullable
                        as String?,
            securityRemarks:
                freezed == securityRemarks
                    ? _value.securityRemarks
                    : securityRemarks // ignore: cast_nullable_to_non_nullable
                        as String?,
            vehiclePhoto:
                freezed == vehiclePhoto
                    ? _value.vehiclePhoto
                    : vehiclePhoto // ignore: cast_nullable_to_non_nullable
                        as String?,
            backPhoto:
                freezed == backPhoto
                    ? _value.backPhoto
                    : backPhoto // ignore: cast_nullable_to_non_nullable
                        as String?,
            gateExitdate:
                freezed == gateExitdate
                    ? _value.gateExitdate
                    : gateExitdate // ignore: cast_nullable_to_non_nullable
                        as String?,
            gateExitTime:
                freezed == gateExitTime
                    ? _value.gateExitTime
                    : gateExitTime // ignore: cast_nullable_to_non_nullable
                        as String?,
            invoicePhotos:
                freezed == invoicePhotos
                    ? _value.invoicePhotos
                    : invoicePhotos // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            requestType:
                freezed == requestType
                    ? _value.requestType
                    : requestType // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            vehiclePhotoImg:
                freezed == vehiclePhotoImg
                    ? _value.vehiclePhotoImg
                    : vehiclePhotoImg // ignore: cast_nullable_to_non_nullable
                        as File?,
            backPhotoImg:
                freezed == backPhotoImg
                    ? _value.backPhotoImg
                    : backPhotoImg // ignore: cast_nullable_to_non_nullable
                        as File?,
            documentPhotoImg:
                freezed == documentPhotoImg
                    ? _value.documentPhotoImg
                    : documentPhotoImg // ignore: cast_nullable_to_non_nullable
                        as List<File>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GateManagementFormImplCopyWith<$Res>
    implements $GateManagementFormCopyWith<$Res> {
  factory _$$GateManagementFormImplCopyWith(
    _$GateManagementFormImpl value,
    $Res Function(_$GateManagementFormImpl) then,
  ) = __$$GateManagementFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation') String? modifiedBy,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'gate_entry_date') String? gateeEntrydate,
    @JsonKey(name: 'gate_entry_time') String? gateEntryTime,
    @JsonKey(name: 'purpose__remarks') String? remarks,
    @JsonKey(name: 'vehicle_no') String? vehicleNo,
    @JsonKey(name: 'vehicle_type') String? vehicleType,
    @JsonKey(name: 'vendor_invoice_no') String? vendorInvoiceNo,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'driver_mobile') String? driverMobileNo,
    @JsonKey(name: 'company__vendor_name') String? vendorName,
    @JsonKey(name: 'security_remarks') String? securityRemarks,
    @JsonKey(name: 'vehicle_photo') String? vehiclePhoto,
    @JsonKey(name: 'vehicle_back_photo') String? backPhoto,
    @JsonKey(name: 'gate_exit_date') String? gateExitdate,
    @JsonKey(name: 'gate_exit_time') String? gateExitTime,
    @JsonKey(name: 'document_photos', fromJson: _stringOrListToStringList)
    List<String>? invoicePhotos,
    @JsonKey(readValue: _extractRequestTypes) List<String>? requestType,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? vehiclePhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    File? backPhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    List<File>? documentPhotoImg,
  });
}

/// @nodoc
class __$$GateManagementFormImplCopyWithImpl<$Res>
    extends _$GateManagementFormCopyWithImpl<$Res, _$GateManagementFormImpl>
    implements _$$GateManagementFormImplCopyWith<$Res> {
  __$$GateManagementFormImplCopyWithImpl(
    _$GateManagementFormImpl _value,
    $Res Function(_$GateManagementFormImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GateManagementForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? docStatus = freezed,
    Object? owner = freezed,
    Object? modifiedBy = freezed,
    Object? plantName = freezed,
    Object? gateeEntrydate = freezed,
    Object? gateEntryTime = freezed,
    Object? remarks = freezed,
    Object? vehicleNo = freezed,
    Object? vehicleType = freezed,
    Object? vendorInvoiceNo = freezed,
    Object? driverName = freezed,
    Object? driverMobileNo = freezed,
    Object? vendorName = freezed,
    Object? securityRemarks = freezed,
    Object? vehiclePhoto = freezed,
    Object? backPhoto = freezed,
    Object? gateExitdate = freezed,
    Object? gateExitTime = freezed,
    Object? invoicePhotos = freezed,
    Object? requestType = freezed,
    Object? vehiclePhotoImg = freezed,
    Object? backPhotoImg = freezed,
    Object? documentPhotoImg = freezed,
  }) {
    return _then(
      _$GateManagementFormImpl(
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
        owner:
            freezed == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                    as String?,
        modifiedBy:
            freezed == modifiedBy
                ? _value.modifiedBy
                : modifiedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        plantName:
            freezed == plantName
                ? _value.plantName
                : plantName // ignore: cast_nullable_to_non_nullable
                    as String?,
        gateeEntrydate:
            freezed == gateeEntrydate
                ? _value.gateeEntrydate
                : gateeEntrydate // ignore: cast_nullable_to_non_nullable
                    as String?,
        gateEntryTime:
            freezed == gateEntryTime
                ? _value.gateEntryTime
                : gateEntryTime // ignore: cast_nullable_to_non_nullable
                    as String?,
        remarks:
            freezed == remarks
                ? _value.remarks
                : remarks // ignore: cast_nullable_to_non_nullable
                    as String?,
        vehicleNo:
            freezed == vehicleNo
                ? _value.vehicleNo
                : vehicleNo // ignore: cast_nullable_to_non_nullable
                    as String?,
        vehicleType:
            freezed == vehicleType
                ? _value.vehicleType
                : vehicleType // ignore: cast_nullable_to_non_nullable
                    as String?,
        vendorInvoiceNo:
            freezed == vendorInvoiceNo
                ? _value.vendorInvoiceNo
                : vendorInvoiceNo // ignore: cast_nullable_to_non_nullable
                    as String?,
        driverName:
            freezed == driverName
                ? _value.driverName
                : driverName // ignore: cast_nullable_to_non_nullable
                    as String?,
        driverMobileNo:
            freezed == driverMobileNo
                ? _value.driverMobileNo
                : driverMobileNo // ignore: cast_nullable_to_non_nullable
                    as String?,
        vendorName:
            freezed == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
                    as String?,
        securityRemarks:
            freezed == securityRemarks
                ? _value.securityRemarks
                : securityRemarks // ignore: cast_nullable_to_non_nullable
                    as String?,
        vehiclePhoto:
            freezed == vehiclePhoto
                ? _value.vehiclePhoto
                : vehiclePhoto // ignore: cast_nullable_to_non_nullable
                    as String?,
        backPhoto:
            freezed == backPhoto
                ? _value.backPhoto
                : backPhoto // ignore: cast_nullable_to_non_nullable
                    as String?,
        gateExitdate:
            freezed == gateExitdate
                ? _value.gateExitdate
                : gateExitdate // ignore: cast_nullable_to_non_nullable
                    as String?,
        gateExitTime:
            freezed == gateExitTime
                ? _value.gateExitTime
                : gateExitTime // ignore: cast_nullable_to_non_nullable
                    as String?,
        invoicePhotos:
            freezed == invoicePhotos
                ? _value._invoicePhotos
                : invoicePhotos // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        requestType:
            freezed == requestType
                ? _value._requestType
                : requestType // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        vehiclePhotoImg:
            freezed == vehiclePhotoImg
                ? _value.vehiclePhotoImg
                : vehiclePhotoImg // ignore: cast_nullable_to_non_nullable
                    as File?,
        backPhotoImg:
            freezed == backPhotoImg
                ? _value.backPhotoImg
                : backPhotoImg // ignore: cast_nullable_to_non_nullable
                    as File?,
        documentPhotoImg:
            freezed == documentPhotoImg
                ? _value._documentPhotoImg
                : documentPhotoImg // ignore: cast_nullable_to_non_nullable
                    as List<File>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GateManagementFormImpl implements _GateManagementForm {
  const _$GateManagementFormImpl({
    this.status,
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'docstatus') this.docStatus,
    @JsonKey(name: 'owner') this.owner,
    @JsonKey(name: 'creation') this.modifiedBy,
    @JsonKey(name: 'plant_name') this.plantName,
    @JsonKey(name: 'gate_entry_date') this.gateeEntrydate,
    @JsonKey(name: 'gate_entry_time') this.gateEntryTime,
    @JsonKey(name: 'purpose__remarks') this.remarks,
    @JsonKey(name: 'vehicle_no') this.vehicleNo,
    @JsonKey(name: 'vehicle_type') this.vehicleType,
    @JsonKey(name: 'vendor_invoice_no') this.vendorInvoiceNo,
    @JsonKey(name: 'driver_name') this.driverName,
    @JsonKey(name: 'driver_mobile') this.driverMobileNo,
    @JsonKey(name: 'company__vendor_name') this.vendorName,
    @JsonKey(name: 'security_remarks') this.securityRemarks,
    @JsonKey(name: 'vehicle_photo') this.vehiclePhoto,
    @JsonKey(name: 'vehicle_back_photo') this.backPhoto,
    @JsonKey(name: 'gate_exit_date') this.gateExitdate,
    @JsonKey(name: 'gate_exit_time') this.gateExitTime,
    @JsonKey(name: 'document_photos', fromJson: _stringOrListToStringList)
    final List<String>? invoicePhotos,
    @JsonKey(readValue: _extractRequestTypes) final List<String>? requestType,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    this.vehiclePhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    this.backPhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final List<File>? documentPhotoImg,
  }) : _invoicePhotos = invoicePhotos,
       _requestType = requestType,
       _documentPhotoImg = documentPhotoImg;

  factory _$GateManagementFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$GateManagementFormImplFromJson(json);

  @override
  final String? status;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'docstatus')
  final int? docStatus;
  @override
  @JsonKey(name: 'owner')
  final String? owner;
  @override
  @JsonKey(name: 'creation')
  final String? modifiedBy;
  @override
  @JsonKey(name: 'plant_name')
  final String? plantName;
  // @JsonKey(name: 'request_type') List<String>? requestType,
  @override
  @JsonKey(name: 'gate_entry_date')
  final String? gateeEntrydate;
  @override
  @JsonKey(name: 'gate_entry_time')
  final String? gateEntryTime;
  @override
  @JsonKey(name: 'purpose__remarks')
  final String? remarks;
  @override
  @JsonKey(name: 'vehicle_no')
  final String? vehicleNo;
  @override
  @JsonKey(name: 'vehicle_type')
  final String? vehicleType;
  @override
  @JsonKey(name: 'vendor_invoice_no')
  final String? vendorInvoiceNo;
  @override
  @JsonKey(name: 'driver_name')
  final String? driverName;
  @override
  @JsonKey(name: 'driver_mobile')
  final String? driverMobileNo;
  @override
  @JsonKey(name: 'company__vendor_name')
  final String? vendorName;
  @override
  @JsonKey(name: 'security_remarks')
  final String? securityRemarks;
  @override
  @JsonKey(name: 'vehicle_photo')
  final String? vehiclePhoto;
  @override
  @JsonKey(name: 'vehicle_back_photo')
  final String? backPhoto;
  @override
  @JsonKey(name: 'gate_exit_date')
  final String? gateExitdate;
  @override
  @JsonKey(name: 'gate_exit_time')
  final String? gateExitTime;
  // @JsonKey(name: 'document_photos') String? documentPhoto,
  final List<String>? _invoicePhotos;
  // @JsonKey(name: 'document_photos') String? documentPhoto,
  @override
  @JsonKey(name: 'document_photos', fromJson: _stringOrListToStringList)
  List<String>? get invoicePhotos {
    final value = _invoicePhotos;
    if (value == null) return null;
    if (_invoicePhotos is EqualUnmodifiableListView) return _invoicePhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _requestType;
  @override
  @JsonKey(readValue: _extractRequestTypes)
  List<String>? get requestType {
    final value = _requestType;
    if (value == null) return null;
    if (_requestType is EqualUnmodifiableListView) return _requestType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  final File? vehiclePhotoImg;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  final File? backPhotoImg;
  final List<File>? _documentPhotoImg;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  List<File>? get documentPhotoImg {
    final value = _documentPhotoImg;
    if (value == null) return null;
    if (_documentPhotoImg is EqualUnmodifiableListView)
      return _documentPhotoImg;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GateManagementForm(status: $status, name: $name, docStatus: $docStatus, owner: $owner, modifiedBy: $modifiedBy, plantName: $plantName, gateeEntrydate: $gateeEntrydate, gateEntryTime: $gateEntryTime, remarks: $remarks, vehicleNo: $vehicleNo, vehicleType: $vehicleType, vendorInvoiceNo: $vendorInvoiceNo, driverName: $driverName, driverMobileNo: $driverMobileNo, vendorName: $vendorName, securityRemarks: $securityRemarks, vehiclePhoto: $vehiclePhoto, backPhoto: $backPhoto, gateExitdate: $gateExitdate, gateExitTime: $gateExitTime, invoicePhotos: $invoicePhotos, requestType: $requestType, vehiclePhotoImg: $vehiclePhotoImg, backPhotoImg: $backPhotoImg, documentPhotoImg: $documentPhotoImg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GateManagementFormImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.docStatus, docStatus) ||
                other.docStatus == docStatus) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.modifiedBy, modifiedBy) ||
                other.modifiedBy == modifiedBy) &&
            (identical(other.plantName, plantName) ||
                other.plantName == plantName) &&
            (identical(other.gateeEntrydate, gateeEntrydate) ||
                other.gateeEntrydate == gateeEntrydate) &&
            (identical(other.gateEntryTime, gateEntryTime) ||
                other.gateEntryTime == gateEntryTime) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.vehicleNo, vehicleNo) ||
                other.vehicleNo == vehicleNo) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.vendorInvoiceNo, vendorInvoiceNo) ||
                other.vendorInvoiceNo == vendorInvoiceNo) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.driverMobileNo, driverMobileNo) ||
                other.driverMobileNo == driverMobileNo) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.securityRemarks, securityRemarks) ||
                other.securityRemarks == securityRemarks) &&
            (identical(other.vehiclePhoto, vehiclePhoto) ||
                other.vehiclePhoto == vehiclePhoto) &&
            (identical(other.backPhoto, backPhoto) ||
                other.backPhoto == backPhoto) &&
            (identical(other.gateExitdate, gateExitdate) ||
                other.gateExitdate == gateExitdate) &&
            (identical(other.gateExitTime, gateExitTime) ||
                other.gateExitTime == gateExitTime) &&
            const DeepCollectionEquality().equals(
              other._invoicePhotos,
              _invoicePhotos,
            ) &&
            const DeepCollectionEquality().equals(
              other._requestType,
              _requestType,
            ) &&
            (identical(other.vehiclePhotoImg, vehiclePhotoImg) ||
                other.vehiclePhotoImg == vehiclePhotoImg) &&
            (identical(other.backPhotoImg, backPhotoImg) ||
                other.backPhotoImg == backPhotoImg) &&
            const DeepCollectionEquality().equals(
              other._documentPhotoImg,
              _documentPhotoImg,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    status,
    name,
    docStatus,
    owner,
    modifiedBy,
    plantName,
    gateeEntrydate,
    gateEntryTime,
    remarks,
    vehicleNo,
    vehicleType,
    vendorInvoiceNo,
    driverName,
    driverMobileNo,
    vendorName,
    securityRemarks,
    vehiclePhoto,
    backPhoto,
    gateExitdate,
    gateExitTime,
    const DeepCollectionEquality().hash(_invoicePhotos),
    const DeepCollectionEquality().hash(_requestType),
    vehiclePhotoImg,
    backPhotoImg,
    const DeepCollectionEquality().hash(_documentPhotoImg),
  ]);

  /// Create a copy of GateManagementForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GateManagementFormImplCopyWith<_$GateManagementFormImpl> get copyWith =>
      __$$GateManagementFormImplCopyWithImpl<_$GateManagementFormImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GateManagementFormImplToJson(this);
  }
}

abstract class _GateManagementForm implements GateManagementForm {
  const factory _GateManagementForm({
    final String? status,
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'docstatus') final int? docStatus,
    @JsonKey(name: 'owner') final String? owner,
    @JsonKey(name: 'creation') final String? modifiedBy,
    @JsonKey(name: 'plant_name') final String? plantName,
    @JsonKey(name: 'gate_entry_date') final String? gateeEntrydate,
    @JsonKey(name: 'gate_entry_time') final String? gateEntryTime,
    @JsonKey(name: 'purpose__remarks') final String? remarks,
    @JsonKey(name: 'vehicle_no') final String? vehicleNo,
    @JsonKey(name: 'vehicle_type') final String? vehicleType,
    @JsonKey(name: 'vendor_invoice_no') final String? vendorInvoiceNo,
    @JsonKey(name: 'driver_name') final String? driverName,
    @JsonKey(name: 'driver_mobile') final String? driverMobileNo,
    @JsonKey(name: 'company__vendor_name') final String? vendorName,
    @JsonKey(name: 'security_remarks') final String? securityRemarks,
    @JsonKey(name: 'vehicle_photo') final String? vehiclePhoto,
    @JsonKey(name: 'vehicle_back_photo') final String? backPhoto,
    @JsonKey(name: 'gate_exit_date') final String? gateExitdate,
    @JsonKey(name: 'gate_exit_time') final String? gateExitTime,
    @JsonKey(name: 'document_photos', fromJson: _stringOrListToStringList)
    final List<String>? invoicePhotos,
    @JsonKey(readValue: _extractRequestTypes) final List<String>? requestType,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final File? vehiclePhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final File? backPhotoImg,
    @JsonKey(
      includeFromJson: true,
      includeToJson: false,
      toJson: toNull,
      fromJson: toNull,
    )
    final List<File>? documentPhotoImg,
  }) = _$GateManagementFormImpl;

  factory _GateManagementForm.fromJson(Map<String, dynamic> json) =
      _$GateManagementFormImpl.fromJson;

  @override
  String? get status;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'docstatus')
  int? get docStatus;
  @override
  @JsonKey(name: 'owner')
  String? get owner;
  @override
  @JsonKey(name: 'creation')
  String? get modifiedBy;
  @override
  @JsonKey(name: 'plant_name')
  String? get plantName; // @JsonKey(name: 'request_type') List<String>? requestType,
  @override
  @JsonKey(name: 'gate_entry_date')
  String? get gateeEntrydate;
  @override
  @JsonKey(name: 'gate_entry_time')
  String? get gateEntryTime;
  @override
  @JsonKey(name: 'purpose__remarks')
  String? get remarks;
  @override
  @JsonKey(name: 'vehicle_no')
  String? get vehicleNo;
  @override
  @JsonKey(name: 'vehicle_type')
  String? get vehicleType;
  @override
  @JsonKey(name: 'vendor_invoice_no')
  String? get vendorInvoiceNo;
  @override
  @JsonKey(name: 'driver_name')
  String? get driverName;
  @override
  @JsonKey(name: 'driver_mobile')
  String? get driverMobileNo;
  @override
  @JsonKey(name: 'company__vendor_name')
  String? get vendorName;
  @override
  @JsonKey(name: 'security_remarks')
  String? get securityRemarks;
  @override
  @JsonKey(name: 'vehicle_photo')
  String? get vehiclePhoto;
  @override
  @JsonKey(name: 'vehicle_back_photo')
  String? get backPhoto;
  @override
  @JsonKey(name: 'gate_exit_date')
  String? get gateExitdate;
  @override
  @JsonKey(name: 'gate_exit_time')
  String? get gateExitTime; // @JsonKey(name: 'document_photos') String? documentPhoto,
  @override
  @JsonKey(name: 'document_photos', fromJson: _stringOrListToStringList)
  List<String>? get invoicePhotos;
  @override
  @JsonKey(readValue: _extractRequestTypes)
  List<String>? get requestType;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get vehiclePhotoImg;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  File? get backPhotoImg;
  @override
  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
    toJson: toNull,
    fromJson: toNull,
  )
  List<File>? get documentPhotoImg;

  /// Create a copy of GateManagementForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GateManagementFormImplCopyWith<_$GateManagementFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
