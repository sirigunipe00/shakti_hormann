// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transporter_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransportersForm _$TransportersFormFromJson(Map<String, dynamic> json) {
  return _TransportersForm.fromJson(json);
}

/// @nodoc
mixin _$TransportersForm {
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String? get suppliername => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_type')
  String? get supplierType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_transporter')
  int? get isTransporter => throw _privateConstructorUsedError;

  /// Serializes this TransportersForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransportersForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportersFormCopyWith<TransportersForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportersFormCopyWith<$Res> {
  factory $TransportersFormCopyWith(
    TransportersForm value,
    $Res Function(TransportersForm) then,
  ) = _$TransportersFormCopyWithImpl<$Res, TransportersForm>;
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'supplier_name') String? suppliername,
    @JsonKey(name: 'supplier_type') String? supplierType,
    @JsonKey(name: 'is_transporter') int? isTransporter,
  });
}

/// @nodoc
class _$TransportersFormCopyWithImpl<$Res, $Val extends TransportersForm>
    implements $TransportersFormCopyWith<$Res> {
  _$TransportersFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportersForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? suppliername = freezed,
    Object? supplierType = freezed,
    Object? isTransporter = freezed,
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
            suppliername:
                freezed == suppliername
                    ? _value.suppliername
                    : suppliername // ignore: cast_nullable_to_non_nullable
                        as String?,
            supplierType:
                freezed == supplierType
                    ? _value.supplierType
                    : supplierType // ignore: cast_nullable_to_non_nullable
                        as String?,
            isTransporter:
                freezed == isTransporter
                    ? _value.isTransporter
                    : isTransporter // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransportersFormImplCopyWith<$Res>
    implements $TransportersFormCopyWith<$Res> {
  factory _$$TransportersFormImplCopyWith(
    _$TransportersFormImpl value,
    $Res Function(_$TransportersFormImpl) then,
  ) = __$$TransportersFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'supplier_name') String? suppliername,
    @JsonKey(name: 'supplier_type') String? supplierType,
    @JsonKey(name: 'is_transporter') int? isTransporter,
  });
}

/// @nodoc
class __$$TransportersFormImplCopyWithImpl<$Res>
    extends _$TransportersFormCopyWithImpl<$Res, _$TransportersFormImpl>
    implements _$$TransportersFormImplCopyWith<$Res> {
  __$$TransportersFormImplCopyWithImpl(
    _$TransportersFormImpl _value,
    $Res Function(_$TransportersFormImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransportersForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? name = freezed,
    Object? suppliername = freezed,
    Object? supplierType = freezed,
    Object? isTransporter = freezed,
  }) {
    return _then(
      _$TransportersFormImpl(
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
        suppliername:
            freezed == suppliername
                ? _value.suppliername
                : suppliername // ignore: cast_nullable_to_non_nullable
                    as String?,
        supplierType:
            freezed == supplierType
                ? _value.supplierType
                : supplierType // ignore: cast_nullable_to_non_nullable
                    as String?,
        isTransporter:
            freezed == isTransporter
                ? _value.isTransporter
                : isTransporter // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportersFormImpl implements _TransportersForm {
  const _$TransportersFormImpl({
    this.status,
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'supplier_name') this.suppliername,
    @JsonKey(name: 'supplier_type') this.supplierType,
    @JsonKey(name: 'is_transporter') this.isTransporter,
  });

  factory _$TransportersFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransportersFormImplFromJson(json);

  @override
  final String? status;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'supplier_name')
  final String? suppliername;
  @override
  @JsonKey(name: 'supplier_type')
  final String? supplierType;
  @override
  @JsonKey(name: 'is_transporter')
  final int? isTransporter;

  @override
  String toString() {
    return 'TransportersForm(status: $status, name: $name, suppliername: $suppliername, supplierType: $supplierType, isTransporter: $isTransporter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportersFormImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.suppliername, suppliername) ||
                other.suppliername == suppliername) &&
            (identical(other.supplierType, supplierType) ||
                other.supplierType == supplierType) &&
            (identical(other.isTransporter, isTransporter) ||
                other.isTransporter == isTransporter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    name,
    suppliername,
    supplierType,
    isTransporter,
  );

  /// Create a copy of TransportersForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportersFormImplCopyWith<_$TransportersFormImpl> get copyWith =>
      __$$TransportersFormImplCopyWithImpl<_$TransportersFormImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportersFormImplToJson(this);
  }
}

abstract class _TransportersForm implements TransportersForm {
  const factory _TransportersForm({
    final String? status,
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'supplier_name') final String? suppliername,
    @JsonKey(name: 'supplier_type') final String? supplierType,
    @JsonKey(name: 'is_transporter') final int? isTransporter,
  }) = _$TransportersFormImpl;

  factory _TransportersForm.fromJson(Map<String, dynamic> json) =
      _$TransportersFormImpl.fromJson;

  @override
  String? get status;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'supplier_name')
  String? get suppliername;
  @override
  @JsonKey(name: 'supplier_type')
  String? get supplierType;
  @override
  @JsonKey(name: 'is_transporter')
  int? get isTransporter;

  /// Create a copy of TransportersForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportersFormImplCopyWith<_$TransportersFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
