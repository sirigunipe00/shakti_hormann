// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pallet_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PalletDetails _$PalletDetailsFromJson(Map<String, dynamic> json) {
  return _PalletDetails.fromJson(json);
}

/// @nodoc
mixin _$PalletDetails {
  @JsonKey(name: 'status')
  int? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'data')
  PalletData? get data => throw _privateConstructorUsedError;

  /// Serializes this PalletDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PalletDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PalletDetailsCopyWith<PalletDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PalletDetailsCopyWith<$Res> {
  factory $PalletDetailsCopyWith(
    PalletDetails value,
    $Res Function(PalletDetails) then,
  ) = _$PalletDetailsCopyWithImpl<$Res, PalletDetails>;
  @useResult
  $Res call({
    @JsonKey(name: 'status') int? status,
    @JsonKey(name: 'data') PalletData? data,
  });

  $PalletDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$PalletDetailsCopyWithImpl<$Res, $Val extends PalletDetails>
    implements $PalletDetailsCopyWith<$Res> {
  _$PalletDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PalletDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = freezed, Object? data = freezed}) {
    return _then(
      _value.copyWith(
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as int?,
            data:
                freezed == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as PalletData?,
          )
          as $Val,
    );
  }

  /// Create a copy of PalletDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PalletDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $PalletDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PalletDetailsImplCopyWith<$Res>
    implements $PalletDetailsCopyWith<$Res> {
  factory _$$PalletDetailsImplCopyWith(
    _$PalletDetailsImpl value,
    $Res Function(_$PalletDetailsImpl) then,
  ) = __$$PalletDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'status') int? status,
    @JsonKey(name: 'data') PalletData? data,
  });

  @override
  $PalletDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$PalletDetailsImplCopyWithImpl<$Res>
    extends _$PalletDetailsCopyWithImpl<$Res, _$PalletDetailsImpl>
    implements _$$PalletDetailsImplCopyWith<$Res> {
  __$$PalletDetailsImplCopyWithImpl(
    _$PalletDetailsImpl _value,
    $Res Function(_$PalletDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PalletDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = freezed, Object? data = freezed}) {
    return _then(
      _$PalletDetailsImpl(
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as int?,
        data:
            freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                    as PalletData?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PalletDetailsImpl implements _PalletDetails {
  const _$PalletDetailsImpl({
    @JsonKey(name: 'status') this.status,
    @JsonKey(name: 'data') this.data,
  });

  factory _$PalletDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PalletDetailsImplFromJson(json);

  @override
  @JsonKey(name: 'status')
  final int? status;
  @override
  @JsonKey(name: 'data')
  final PalletData? data;

  @override
  String toString() {
    return 'PalletDetails(status: $status, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PalletDetailsImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, data);

  /// Create a copy of PalletDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PalletDetailsImplCopyWith<_$PalletDetailsImpl> get copyWith =>
      __$$PalletDetailsImplCopyWithImpl<_$PalletDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PalletDetailsImplToJson(this);
  }
}

abstract class _PalletDetails implements PalletDetails {
  const factory _PalletDetails({
    @JsonKey(name: 'status') final int? status,
    @JsonKey(name: 'data') final PalletData? data,
  }) = _$PalletDetailsImpl;

  factory _PalletDetails.fromJson(Map<String, dynamic> json) =
      _$PalletDetailsImpl.fromJson;

  @override
  @JsonKey(name: 'status')
  int? get status;
  @override
  @JsonKey(name: 'data')
  PalletData? get data;

  /// Create a copy of PalletDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PalletDetailsImplCopyWith<_$PalletDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PalletData _$PalletDataFromJson(Map<String, dynamic> json) {
  return _PalletData.fromJson(json);
}

/// @nodoc
mixin _$PalletData {
  @JsonKey(name: 'doctype')
  String? get doctype => throw _privateConstructorUsedError;
  @JsonKey(name: 'pallet_no')
  String? get palletNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_qty')
  int? get totalQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_orders')
  List<String>? get salesOrders => throw _privateConstructorUsedError;

  /// Serializes this PalletData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PalletData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PalletDataCopyWith<PalletData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PalletDataCopyWith<$Res> {
  factory $PalletDataCopyWith(
    PalletData value,
    $Res Function(PalletData) then,
  ) = _$PalletDataCopyWithImpl<$Res, PalletData>;
  @useResult
  $Res call({
    @JsonKey(name: 'doctype') String? doctype,
    @JsonKey(name: 'pallet_no') String? palletNo,
    @JsonKey(name: 'total_qty') int? totalQty,
    @JsonKey(name: 'sales_orders') List<String>? salesOrders,
  });
}

/// @nodoc
class _$PalletDataCopyWithImpl<$Res, $Val extends PalletData>
    implements $PalletDataCopyWith<$Res> {
  _$PalletDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PalletData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? doctype = freezed,
    Object? palletNo = freezed,
    Object? totalQty = freezed,
    Object? salesOrders = freezed,
  }) {
    return _then(
      _value.copyWith(
            doctype:
                freezed == doctype
                    ? _value.doctype
                    : doctype // ignore: cast_nullable_to_non_nullable
                        as String?,
            palletNo:
                freezed == palletNo
                    ? _value.palletNo
                    : palletNo // ignore: cast_nullable_to_non_nullable
                        as String?,
            totalQty:
                freezed == totalQty
                    ? _value.totalQty
                    : totalQty // ignore: cast_nullable_to_non_nullable
                        as int?,
            salesOrders:
                freezed == salesOrders
                    ? _value.salesOrders
                    : salesOrders // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PalletDataImplCopyWith<$Res>
    implements $PalletDataCopyWith<$Res> {
  factory _$$PalletDataImplCopyWith(
    _$PalletDataImpl value,
    $Res Function(_$PalletDataImpl) then,
  ) = __$$PalletDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'doctype') String? doctype,
    @JsonKey(name: 'pallet_no') String? palletNo,
    @JsonKey(name: 'total_qty') int? totalQty,
    @JsonKey(name: 'sales_orders') List<String>? salesOrders,
  });
}

/// @nodoc
class __$$PalletDataImplCopyWithImpl<$Res>
    extends _$PalletDataCopyWithImpl<$Res, _$PalletDataImpl>
    implements _$$PalletDataImplCopyWith<$Res> {
  __$$PalletDataImplCopyWithImpl(
    _$PalletDataImpl _value,
    $Res Function(_$PalletDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PalletData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? doctype = freezed,
    Object? palletNo = freezed,
    Object? totalQty = freezed,
    Object? salesOrders = freezed,
  }) {
    return _then(
      _$PalletDataImpl(
        doctype:
            freezed == doctype
                ? _value.doctype
                : doctype // ignore: cast_nullable_to_non_nullable
                    as String?,
        palletNo:
            freezed == palletNo
                ? _value.palletNo
                : palletNo // ignore: cast_nullable_to_non_nullable
                    as String?,
        totalQty:
            freezed == totalQty
                ? _value.totalQty
                : totalQty // ignore: cast_nullable_to_non_nullable
                    as int?,
        salesOrders:
            freezed == salesOrders
                ? _value._salesOrders
                : salesOrders // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PalletDataImpl implements _PalletData {
  const _$PalletDataImpl({
    @JsonKey(name: 'doctype') this.doctype,
    @JsonKey(name: 'pallet_no') this.palletNo,
    @JsonKey(name: 'total_qty') this.totalQty,
    @JsonKey(name: 'sales_orders') final List<String>? salesOrders,
  }) : _salesOrders = salesOrders;

  factory _$PalletDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PalletDataImplFromJson(json);

  @override
  @JsonKey(name: 'doctype')
  final String? doctype;
  @override
  @JsonKey(name: 'pallet_no')
  final String? palletNo;
  @override
  @JsonKey(name: 'total_qty')
  final int? totalQty;
  final List<String>? _salesOrders;
  @override
  @JsonKey(name: 'sales_orders')
  List<String>? get salesOrders {
    final value = _salesOrders;
    if (value == null) return null;
    if (_salesOrders is EqualUnmodifiableListView) return _salesOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PalletData(doctype: $doctype, palletNo: $palletNo, totalQty: $totalQty, salesOrders: $salesOrders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PalletDataImpl &&
            (identical(other.doctype, doctype) || other.doctype == doctype) &&
            (identical(other.palletNo, palletNo) ||
                other.palletNo == palletNo) &&
            (identical(other.totalQty, totalQty) ||
                other.totalQty == totalQty) &&
            const DeepCollectionEquality().equals(
              other._salesOrders,
              _salesOrders,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    doctype,
    palletNo,
    totalQty,
    const DeepCollectionEquality().hash(_salesOrders),
  );

  /// Create a copy of PalletData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PalletDataImplCopyWith<_$PalletDataImpl> get copyWith =>
      __$$PalletDataImplCopyWithImpl<_$PalletDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PalletDataImplToJson(this);
  }
}

abstract class _PalletData implements PalletData {
  const factory _PalletData({
    @JsonKey(name: 'doctype') final String? doctype,
    @JsonKey(name: 'pallet_no') final String? palletNo,
    @JsonKey(name: 'total_qty') final int? totalQty,
    @JsonKey(name: 'sales_orders') final List<String>? salesOrders,
  }) = _$PalletDataImpl;

  factory _PalletData.fromJson(Map<String, dynamic> json) =
      _$PalletDataImpl.fromJson;

  @override
  @JsonKey(name: 'doctype')
  String? get doctype;
  @override
  @JsonKey(name: 'pallet_no')
  String? get palletNo;
  @override
  @JsonKey(name: 'total_qty')
  int? get totalQty;
  @override
  @JsonKey(name: 'sales_orders')
  List<String>? get salesOrders;

  /// Create a copy of PalletData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PalletDataImplCopyWith<_$PalletDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
