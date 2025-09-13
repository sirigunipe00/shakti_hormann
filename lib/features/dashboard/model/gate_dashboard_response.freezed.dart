// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gate_dashboard_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GateDashboardResponse _$GateDashboardResponseFromJson(
  Map<String, dynamic> json,
) {
  return _GateDashboardResponse.fromJson(json);
}

/// @nodoc
mixin _$GateDashboardResponse {
  Message get message => throw _privateConstructorUsedError;

  /// Serializes this GateDashboardResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GateDashboardResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GateDashboardResponseCopyWith<GateDashboardResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GateDashboardResponseCopyWith<$Res> {
  factory $GateDashboardResponseCopyWith(
    GateDashboardResponse value,
    $Res Function(GateDashboardResponse) then,
  ) = _$GateDashboardResponseCopyWithImpl<$Res, GateDashboardResponse>;
  @useResult
  $Res call({Message message});

  $MessageCopyWith<$Res> get message;
}

/// @nodoc
class _$GateDashboardResponseCopyWithImpl<
  $Res,
  $Val extends GateDashboardResponse
>
    implements $GateDashboardResponseCopyWith<$Res> {
  _$GateDashboardResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GateDashboardResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as Message,
          )
          as $Val,
    );
  }

  /// Create a copy of GateDashboardResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageCopyWith<$Res> get message {
    return $MessageCopyWith<$Res>(_value.message, (value) {
      return _then(_value.copyWith(message: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GateDashboardResponseImplCopyWith<$Res>
    implements $GateDashboardResponseCopyWith<$Res> {
  factory _$$GateDashboardResponseImplCopyWith(
    _$GateDashboardResponseImpl value,
    $Res Function(_$GateDashboardResponseImpl) then,
  ) = __$$GateDashboardResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Message message});

  @override
  $MessageCopyWith<$Res> get message;
}

/// @nodoc
class __$$GateDashboardResponseImplCopyWithImpl<$Res>
    extends
        _$GateDashboardResponseCopyWithImpl<$Res, _$GateDashboardResponseImpl>
    implements _$$GateDashboardResponseImplCopyWith<$Res> {
  __$$GateDashboardResponseImplCopyWithImpl(
    _$GateDashboardResponseImpl _value,
    $Res Function(_$GateDashboardResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GateDashboardResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$GateDashboardResponseImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as Message,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GateDashboardResponseImpl implements _GateDashboardResponse {
  const _$GateDashboardResponseImpl({required this.message});

  factory _$GateDashboardResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GateDashboardResponseImplFromJson(json);

  @override
  final Message message;

  @override
  String toString() {
    return 'GateDashboardResponse(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GateDashboardResponseImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of GateDashboardResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GateDashboardResponseImplCopyWith<_$GateDashboardResponseImpl>
  get copyWith =>
      __$$GateDashboardResponseImplCopyWithImpl<_$GateDashboardResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GateDashboardResponseImplToJson(this);
  }
}

abstract class _GateDashboardResponse implements GateDashboardResponse {
  const factory _GateDashboardResponse({required final Message message}) =
      _$GateDashboardResponseImpl;

  factory _GateDashboardResponse.fromJson(Map<String, dynamic> json) =
      _$GateDashboardResponseImpl.fromJson;

  @override
  Message get message;

  /// Create a copy of GateDashboardResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GateDashboardResponseImplCopyWith<_$GateDashboardResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  int get status => throw _privateConstructorUsedError;
  Map<String, PlantDashboard> get data => throw _privateConstructorUsedError;

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call({int status, Map<String, PlantDashboard> data});
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? data = null}) {
    return _then(
      _value.copyWith(
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as int,
            data:
                null == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as Map<String, PlantDashboard>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
    _$MessageImpl value,
    $Res Function(_$MessageImpl) then,
  ) = __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int status, Map<String, PlantDashboard> data});
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
    _$MessageImpl _value,
    $Res Function(_$MessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? data = null}) {
    return _then(
      _$MessageImpl(
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as int,
        data:
            null == data
                ? _value._data
                : data // ignore: cast_nullable_to_non_nullable
                    as Map<String, PlantDashboard>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl implements _Message {
  const _$MessageImpl({
    required this.status,
    required final Map<String, PlantDashboard> data,
  }) : _data = data;

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final int status;
  final Map<String, PlantDashboard> _data;
  @override
  Map<String, PlantDashboard> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'Message(status: $status, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(this);
  }
}

abstract class _Message implements Message {
  const factory _Message({
    required final int status,
    required final Map<String, PlantDashboard> data,
  }) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  int get status;
  @override
  Map<String, PlantDashboard> get data;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlantDashboard _$PlantDashboardFromJson(Map<String, dynamic> json) {
  return _PlantDashboard.fromJson(json);
}

/// @nodoc
mixin _$PlantDashboard {
  @JsonKey(name: 'gate_entries')
  int get gateEntries => throw _privateConstructorUsedError;
  @JsonKey(name: 'gate_exits')
  int get gateExits => throw _privateConstructorUsedError;
  List<Daywise> get daywise => throw _privateConstructorUsedError;

  /// Serializes this PlantDashboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlantDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlantDashboardCopyWith<PlantDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantDashboardCopyWith<$Res> {
  factory $PlantDashboardCopyWith(
    PlantDashboard value,
    $Res Function(PlantDashboard) then,
  ) = _$PlantDashboardCopyWithImpl<$Res, PlantDashboard>;
  @useResult
  $Res call({
    @JsonKey(name: 'gate_entries') int gateEntries,
    @JsonKey(name: 'gate_exits') int gateExits,
    List<Daywise> daywise,
  });
}

/// @nodoc
class _$PlantDashboardCopyWithImpl<$Res, $Val extends PlantDashboard>
    implements $PlantDashboardCopyWith<$Res> {
  _$PlantDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlantDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gateEntries = null,
    Object? gateExits = null,
    Object? daywise = null,
  }) {
    return _then(
      _value.copyWith(
            gateEntries:
                null == gateEntries
                    ? _value.gateEntries
                    : gateEntries // ignore: cast_nullable_to_non_nullable
                        as int,
            gateExits:
                null == gateExits
                    ? _value.gateExits
                    : gateExits // ignore: cast_nullable_to_non_nullable
                        as int,
            daywise:
                null == daywise
                    ? _value.daywise
                    : daywise // ignore: cast_nullable_to_non_nullable
                        as List<Daywise>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlantDashboardImplCopyWith<$Res>
    implements $PlantDashboardCopyWith<$Res> {
  factory _$$PlantDashboardImplCopyWith(
    _$PlantDashboardImpl value,
    $Res Function(_$PlantDashboardImpl) then,
  ) = __$$PlantDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'gate_entries') int gateEntries,
    @JsonKey(name: 'gate_exits') int gateExits,
    List<Daywise> daywise,
  });
}

/// @nodoc
class __$$PlantDashboardImplCopyWithImpl<$Res>
    extends _$PlantDashboardCopyWithImpl<$Res, _$PlantDashboardImpl>
    implements _$$PlantDashboardImplCopyWith<$Res> {
  __$$PlantDashboardImplCopyWithImpl(
    _$PlantDashboardImpl _value,
    $Res Function(_$PlantDashboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlantDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gateEntries = null,
    Object? gateExits = null,
    Object? daywise = null,
  }) {
    return _then(
      _$PlantDashboardImpl(
        gateEntries:
            null == gateEntries
                ? _value.gateEntries
                : gateEntries // ignore: cast_nullable_to_non_nullable
                    as int,
        gateExits:
            null == gateExits
                ? _value.gateExits
                : gateExits // ignore: cast_nullable_to_non_nullable
                    as int,
        daywise:
            null == daywise
                ? _value._daywise
                : daywise // ignore: cast_nullable_to_non_nullable
                    as List<Daywise>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantDashboardImpl implements _PlantDashboard {
  const _$PlantDashboardImpl({
    @JsonKey(name: 'gate_entries') required this.gateEntries,
    @JsonKey(name: 'gate_exits') required this.gateExits,
    required final List<Daywise> daywise,
  }) : _daywise = daywise;

  factory _$PlantDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantDashboardImplFromJson(json);

  @override
  @JsonKey(name: 'gate_entries')
  final int gateEntries;
  @override
  @JsonKey(name: 'gate_exits')
  final int gateExits;
  final List<Daywise> _daywise;
  @override
  List<Daywise> get daywise {
    if (_daywise is EqualUnmodifiableListView) return _daywise;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daywise);
  }

  @override
  String toString() {
    return 'PlantDashboard(gateEntries: $gateEntries, gateExits: $gateExits, daywise: $daywise)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantDashboardImpl &&
            (identical(other.gateEntries, gateEntries) ||
                other.gateEntries == gateEntries) &&
            (identical(other.gateExits, gateExits) ||
                other.gateExits == gateExits) &&
            const DeepCollectionEquality().equals(other._daywise, _daywise));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    gateEntries,
    gateExits,
    const DeepCollectionEquality().hash(_daywise),
  );

  /// Create a copy of PlantDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantDashboardImplCopyWith<_$PlantDashboardImpl> get copyWith =>
      __$$PlantDashboardImplCopyWithImpl<_$PlantDashboardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantDashboardImplToJson(this);
  }
}

abstract class _PlantDashboard implements PlantDashboard {
  const factory _PlantDashboard({
    @JsonKey(name: 'gate_entries') required final int gateEntries,
    @JsonKey(name: 'gate_exits') required final int gateExits,
    required final List<Daywise> daywise,
  }) = _$PlantDashboardImpl;

  factory _PlantDashboard.fromJson(Map<String, dynamic> json) =
      _$PlantDashboardImpl.fromJson;

  @override
  @JsonKey(name: 'gate_entries')
  int get gateEntries;
  @override
  @JsonKey(name: 'gate_exits')
  int get gateExits;
  @override
  List<Daywise> get daywise;

  /// Create a copy of PlantDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlantDashboardImplCopyWith<_$PlantDashboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Daywise _$DaywiseFromJson(Map<String, dynamic> json) {
  return _Daywise.fromJson(json);
}

/// @nodoc
mixin _$Daywise {
  String get day => throw _privateConstructorUsedError;
  int get entries => throw _privateConstructorUsedError;
  int get exits => throw _privateConstructorUsedError;

  /// Serializes this Daywise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Daywise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DaywiseCopyWith<Daywise> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DaywiseCopyWith<$Res> {
  factory $DaywiseCopyWith(Daywise value, $Res Function(Daywise) then) =
      _$DaywiseCopyWithImpl<$Res, Daywise>;
  @useResult
  $Res call({String day, int entries, int exits});
}

/// @nodoc
class _$DaywiseCopyWithImpl<$Res, $Val extends Daywise>
    implements $DaywiseCopyWith<$Res> {
  _$DaywiseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Daywise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? entries = null,
    Object? exits = null,
  }) {
    return _then(
      _value.copyWith(
            day:
                null == day
                    ? _value.day
                    : day // ignore: cast_nullable_to_non_nullable
                        as String,
            entries:
                null == entries
                    ? _value.entries
                    : entries // ignore: cast_nullable_to_non_nullable
                        as int,
            exits:
                null == exits
                    ? _value.exits
                    : exits // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DaywiseImplCopyWith<$Res> implements $DaywiseCopyWith<$Res> {
  factory _$$DaywiseImplCopyWith(
    _$DaywiseImpl value,
    $Res Function(_$DaywiseImpl) then,
  ) = __$$DaywiseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String day, int entries, int exits});
}

/// @nodoc
class __$$DaywiseImplCopyWithImpl<$Res>
    extends _$DaywiseCopyWithImpl<$Res, _$DaywiseImpl>
    implements _$$DaywiseImplCopyWith<$Res> {
  __$$DaywiseImplCopyWithImpl(
    _$DaywiseImpl _value,
    $Res Function(_$DaywiseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Daywise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? entries = null,
    Object? exits = null,
  }) {
    return _then(
      _$DaywiseImpl(
        day:
            null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                    as String,
        entries:
            null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                    as int,
        exits:
            null == exits
                ? _value.exits
                : exits // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DaywiseImpl implements _Daywise {
  const _$DaywiseImpl({
    required this.day,
    required this.entries,
    required this.exits,
  });

  factory _$DaywiseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DaywiseImplFromJson(json);

  @override
  final String day;
  @override
  final int entries;
  @override
  final int exits;

  @override
  String toString() {
    return 'Daywise(day: $day, entries: $entries, exits: $exits)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DaywiseImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.entries, entries) || other.entries == entries) &&
            (identical(other.exits, exits) || other.exits == exits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, day, entries, exits);

  /// Create a copy of Daywise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DaywiseImplCopyWith<_$DaywiseImpl> get copyWith =>
      __$$DaywiseImplCopyWithImpl<_$DaywiseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DaywiseImplToJson(this);
  }
}

abstract class _Daywise implements Daywise {
  const factory _Daywise({
    required final String day,
    required final int entries,
    required final int exits,
  }) = _$DaywiseImpl;

  factory _Daywise.fromJson(Map<String, dynamic> json) = _$DaywiseImpl.fromJson;

  @override
  String get day;
  @override
  int get entries;
  @override
  int get exits;

  /// Create a copy of Daywise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DaywiseImplCopyWith<_$DaywiseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
