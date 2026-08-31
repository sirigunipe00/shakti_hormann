// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pallet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PalletModel _$PalletModelFromJson(Map<String, dynamic> json) {
  return _PalletModel.fromJson(json);
}

/// @nodoc
mixin _$PalletModel {
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner')
  String? get owner => throw _privateConstructorUsedError;
  @JsonKey(name: 'creation', defaultValue: '')
  String? get creationDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'docstatus')
  int? get docStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'modified')
  String? get modifiedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'modified_by')
  String? get modifiedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'idx')
  int? get idx => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order')
  String? get salesOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_date')
  String? get orderDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'no_of_pallets')
  int? get noofPallets => throw _privateConstructorUsedError;

  /// Serializes this PalletModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PalletModelCopyWith<PalletModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PalletModelCopyWith<$Res> {
  factory $PalletModelCopyWith(
    PalletModel value,
    $Res Function(PalletModel) then,
  ) = _$PalletModelCopyWithImpl<$Res, PalletModel>;
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation', defaultValue: '') String? creationDate,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'modified') String? modifiedDate,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'sales_order') String? salesOrder,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'order_date') String? orderDate,
    @JsonKey(name: 'no_of_pallets') int? noofPallets,
  });
}

/// @nodoc
class _$PalletModelCopyWithImpl<$Res, $Val extends PalletModel>
    implements $PalletModelCopyWith<$Res> {
  _$PalletModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? owner = freezed,
    Object? creationDate = freezed,
    Object? docStatus = freezed,
    Object? modifiedDate = freezed,
    Object? modifiedBy = freezed,
    Object? idx = freezed,
    Object? salesOrder = freezed,
    Object? customerName = freezed,
    Object? orderDate = freezed,
    Object? noofPallets = freezed,
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
            creationDate:
                freezed == creationDate
                    ? _value.creationDate
                    : creationDate // ignore: cast_nullable_to_non_nullable
                        as String?,
            docStatus:
                freezed == docStatus
                    ? _value.docStatus
                    : docStatus // ignore: cast_nullable_to_non_nullable
                        as int?,
            modifiedDate:
                freezed == modifiedDate
                    ? _value.modifiedDate
                    : modifiedDate // ignore: cast_nullable_to_non_nullable
                        as String?,
            modifiedBy:
                freezed == modifiedBy
                    ? _value.modifiedBy
                    : modifiedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            idx:
                freezed == idx
                    ? _value.idx
                    : idx // ignore: cast_nullable_to_non_nullable
                        as int?,
            salesOrder:
                freezed == salesOrder
                    ? _value.salesOrder
                    : salesOrder // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerName:
                freezed == customerName
                    ? _value.customerName
                    : customerName // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderDate:
                freezed == orderDate
                    ? _value.orderDate
                    : orderDate // ignore: cast_nullable_to_non_nullable
                        as String?,
            noofPallets:
                freezed == noofPallets
                    ? _value.noofPallets
                    : noofPallets // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PalletModelImplCopyWith<$Res>
    implements $PalletModelCopyWith<$Res> {
  factory _$$PalletModelImplCopyWith(
    _$PalletModelImpl value,
    $Res Function(_$PalletModelImpl) then,
  ) = __$$PalletModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'creation', defaultValue: '') String? creationDate,
    @JsonKey(name: 'docstatus') int? docStatus,
    @JsonKey(name: 'modified') String? modifiedDate,
    @JsonKey(name: 'modified_by') String? modifiedBy,
    @JsonKey(name: 'idx') int? idx,
    @JsonKey(name: 'sales_order') String? salesOrder,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'order_date') String? orderDate,
    @JsonKey(name: 'no_of_pallets') int? noofPallets,
  });
}

/// @nodoc
class __$$PalletModelImplCopyWithImpl<$Res>
    extends _$PalletModelCopyWithImpl<$Res, _$PalletModelImpl>
    implements _$$PalletModelImplCopyWith<$Res> {
  __$$PalletModelImplCopyWithImpl(
    _$PalletModelImpl _value,
    $Res Function(_$PalletModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? owner = freezed,
    Object? creationDate = freezed,
    Object? docStatus = freezed,
    Object? modifiedDate = freezed,
    Object? modifiedBy = freezed,
    Object? idx = freezed,
    Object? salesOrder = freezed,
    Object? customerName = freezed,
    Object? orderDate = freezed,
    Object? noofPallets = freezed,
  }) {
    return _then(
      _$PalletModelImpl(
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
        creationDate:
            freezed == creationDate
                ? _value.creationDate
                : creationDate // ignore: cast_nullable_to_non_nullable
                    as String?,
        docStatus:
            freezed == docStatus
                ? _value.docStatus
                : docStatus // ignore: cast_nullable_to_non_nullable
                    as int?,
        modifiedDate:
            freezed == modifiedDate
                ? _value.modifiedDate
                : modifiedDate // ignore: cast_nullable_to_non_nullable
                    as String?,
        modifiedBy:
            freezed == modifiedBy
                ? _value.modifiedBy
                : modifiedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        idx:
            freezed == idx
                ? _value.idx
                : idx // ignore: cast_nullable_to_non_nullable
                    as int?,
        salesOrder:
            freezed == salesOrder
                ? _value.salesOrder
                : salesOrder // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerName:
            freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderDate:
            freezed == orderDate
                ? _value.orderDate
                : orderDate // ignore: cast_nullable_to_non_nullable
                    as String?,
        noofPallets:
            freezed == noofPallets
                ? _value.noofPallets
                : noofPallets // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PalletModelImpl implements _PalletModel {
  const _$PalletModelImpl({
    this.status,
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'owner') this.owner,
    @JsonKey(name: 'creation', defaultValue: '') this.creationDate,
    @JsonKey(name: 'docstatus') this.docStatus,
    @JsonKey(name: 'modified') this.modifiedDate,
    @JsonKey(name: 'modified_by') this.modifiedBy,
    @JsonKey(name: 'idx') this.idx,
    @JsonKey(name: 'sales_order') this.salesOrder,
    @JsonKey(name: 'customer_name') this.customerName,
    @JsonKey(name: 'order_date') this.orderDate,
    @JsonKey(name: 'no_of_pallets') this.noofPallets,
  });

  factory _$PalletModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PalletModelImplFromJson(json);

  @override
  final String? status;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'owner')
  final String? owner;
  @override
  @JsonKey(name: 'creation', defaultValue: '')
  final String? creationDate;
  @override
  @JsonKey(name: 'docstatus')
  final int? docStatus;
  @override
  @JsonKey(name: 'modified')
  final String? modifiedDate;
  @override
  @JsonKey(name: 'modified_by')
  final String? modifiedBy;
  @override
  @JsonKey(name: 'idx')
  final int? idx;
  @override
  @JsonKey(name: 'sales_order')
  final String? salesOrder;
  @override
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @override
  @JsonKey(name: 'order_date')
  final String? orderDate;
  @override
  @JsonKey(name: 'no_of_pallets')
  final int? noofPallets;

  @override
  String toString() {
    return 'PalletModel(status: $status, name: $name, owner: $owner, creationDate: $creationDate, docStatus: $docStatus, modifiedDate: $modifiedDate, modifiedBy: $modifiedBy, idx: $idx, salesOrder: $salesOrder, customerName: $customerName, orderDate: $orderDate, noofPallets: $noofPallets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PalletModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.creationDate, creationDate) ||
                other.creationDate == creationDate) &&
            (identical(other.docStatus, docStatus) ||
                other.docStatus == docStatus) &&
            (identical(other.modifiedDate, modifiedDate) ||
                other.modifiedDate == modifiedDate) &&
            (identical(other.modifiedBy, modifiedBy) ||
                other.modifiedBy == modifiedBy) &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.salesOrder, salesOrder) ||
                other.salesOrder == salesOrder) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.noofPallets, noofPallets) ||
                other.noofPallets == noofPallets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    name,
    owner,
    creationDate,
    docStatus,
    modifiedDate,
    modifiedBy,
    idx,
    salesOrder,
    customerName,
    orderDate,
    noofPallets,
  );

  /// Create a copy of PalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PalletModelImplCopyWith<_$PalletModelImpl> get copyWith =>
      __$$PalletModelImplCopyWithImpl<_$PalletModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PalletModelImplToJson(this);
  }
}

abstract class _PalletModel implements PalletModel {
  const factory _PalletModel({
    final String? status,
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'owner') final String? owner,
    @JsonKey(name: 'creation', defaultValue: '') final String? creationDate,
    @JsonKey(name: 'docstatus') final int? docStatus,
    @JsonKey(name: 'modified') final String? modifiedDate,
    @JsonKey(name: 'modified_by') final String? modifiedBy,
    @JsonKey(name: 'idx') final int? idx,
    @JsonKey(name: 'sales_order') final String? salesOrder,
    @JsonKey(name: 'customer_name') final String? customerName,
    @JsonKey(name: 'order_date') final String? orderDate,
    @JsonKey(name: 'no_of_pallets') final int? noofPallets,
  }) = _$PalletModelImpl;

  factory _PalletModel.fromJson(Map<String, dynamic> json) =
      _$PalletModelImpl.fromJson;

  @override
  String? get status;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'owner')
  String? get owner;
  @override
  @JsonKey(name: 'creation', defaultValue: '')
  String? get creationDate;
  @override
  @JsonKey(name: 'docstatus')
  int? get docStatus;
  @override
  @JsonKey(name: 'modified')
  String? get modifiedDate;
  @override
  @JsonKey(name: 'modified_by')
  String? get modifiedBy;
  @override
  @JsonKey(name: 'idx')
  int? get idx;
  @override
  @JsonKey(name: 'sales_order')
  String? get salesOrder;
  @override
  @JsonKey(name: 'customer_name')
  String? get customerName;
  @override
  @JsonKey(name: 'order_date')
  String? get orderDate;
  @override
  @JsonKey(name: 'no_of_pallets')
  int? get noofPallets;

  /// Create a copy of PalletModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PalletModelImplCopyWith<_$PalletModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
