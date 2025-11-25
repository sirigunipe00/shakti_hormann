// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner')
  String? get owner => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_type')
  String? get notificationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_id')
  String? get notificationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  String? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_message')
  String? get notificationMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_at')
  String? get sentAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
    NotificationModel value,
    $Res Function(NotificationModel) then,
  ) = _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'notification_type') String? notificationType,
    @JsonKey(name: 'notification_id') String? notificationId,
    @JsonKey(name: 'user') String? user,
    @JsonKey(name: 'notification_message') String? notificationMessage,
    @JsonKey(name: 'sent_at') String? sentAt,
  });
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? owner = freezed,
    Object? notificationType = freezed,
    Object? notificationId = freezed,
    Object? user = freezed,
    Object? notificationMessage = freezed,
    Object? sentAt = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            notificationType:
                freezed == notificationType
                    ? _value.notificationType
                    : notificationType // ignore: cast_nullable_to_non_nullable
                        as String?,
            notificationId:
                freezed == notificationId
                    ? _value.notificationId
                    : notificationId // ignore: cast_nullable_to_non_nullable
                        as String?,
            user:
                freezed == user
                    ? _value.user
                    : user // ignore: cast_nullable_to_non_nullable
                        as String?,
            notificationMessage:
                freezed == notificationMessage
                    ? _value.notificationMessage
                    : notificationMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            sentAt:
                freezed == sentAt
                    ? _value.sentAt
                    : sentAt // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(
    _$NotificationModelImpl value,
    $Res Function(_$NotificationModelImpl) then,
  ) = __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'notification_type') String? notificationType,
    @JsonKey(name: 'notification_id') String? notificationId,
    @JsonKey(name: 'user') String? user,
    @JsonKey(name: 'notification_message') String? notificationMessage,
    @JsonKey(name: 'sent_at') String? sentAt,
  });
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(
    _$NotificationModelImpl _value,
    $Res Function(_$NotificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? owner = freezed,
    Object? notificationType = freezed,
    Object? notificationId = freezed,
    Object? user = freezed,
    Object? notificationMessage = freezed,
    Object? sentAt = freezed,
  }) {
    return _then(
      _$NotificationModelImpl(
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
        notificationType:
            freezed == notificationType
                ? _value.notificationType
                : notificationType // ignore: cast_nullable_to_non_nullable
                    as String?,
        notificationId:
            freezed == notificationId
                ? _value.notificationId
                : notificationId // ignore: cast_nullable_to_non_nullable
                    as String?,
        user:
            freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                    as String?,
        notificationMessage:
            freezed == notificationMessage
                ? _value.notificationMessage
                : notificationMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        sentAt:
            freezed == sentAt
                ? _value.sentAt
                : sentAt // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl implements _NotificationModel {
  const _$NotificationModelImpl({
    @JsonKey(name: 'name') this.name,
    @JsonKey(name: 'owner') this.owner,
    @JsonKey(name: 'notification_type') this.notificationType,
    @JsonKey(name: 'notification_id') this.notificationId,
    @JsonKey(name: 'user') this.user,
    @JsonKey(name: 'notification_message') this.notificationMessage,
    @JsonKey(name: 'sent_at') this.sentAt,
  });

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'owner')
  final String? owner;
  @override
  @JsonKey(name: 'notification_type')
  final String? notificationType;
  @override
  @JsonKey(name: 'notification_id')
  final String? notificationId;
  @override
  @JsonKey(name: 'user')
  final String? user;
  @override
  @JsonKey(name: 'notification_message')
  final String? notificationMessage;
  @override
  @JsonKey(name: 'sent_at')
  final String? sentAt;

  @override
  String toString() {
    return 'NotificationModel(name: $name, owner: $owner, notificationType: $notificationType, notificationId: $notificationId, user: $user, notificationMessage: $notificationMessage, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.notificationMessage, notificationMessage) ||
                other.notificationMessage == notificationMessage) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    owner,
    notificationType,
    notificationId,
    user,
    notificationMessage,
    sentAt,
  );

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(this);
  }
}

abstract class _NotificationModel implements NotificationModel {
  const factory _NotificationModel({
    @JsonKey(name: 'name') final String? name,
    @JsonKey(name: 'owner') final String? owner,
    @JsonKey(name: 'notification_type') final String? notificationType,
    @JsonKey(name: 'notification_id') final String? notificationId,
    @JsonKey(name: 'user') final String? user,
    @JsonKey(name: 'notification_message') final String? notificationMessage,
    @JsonKey(name: 'sent_at') final String? sentAt,
  }) = _$NotificationModelImpl;

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'owner')
  String? get owner;
  @override
  @JsonKey(name: 'notification_type')
  String? get notificationType;
  @override
  @JsonKey(name: 'notification_id')
  String? get notificationId;
  @override
  @JsonKey(name: 'user')
  String? get user;
  @override
  @JsonKey(name: 'notification_message')
  String? get notificationMessage;
  @override
  @JsonKey(name: 'sent_at')
  String? get sentAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
