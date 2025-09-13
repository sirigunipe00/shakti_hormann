// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gate_dashboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GateDashboardResponseImpl _$$GateDashboardResponseImplFromJson(
  Map<String, dynamic> json,
) => _$GateDashboardResponseImpl(
  message: Message.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$GateDashboardResponseImplToJson(
  _$GateDashboardResponseImpl instance,
) => <String, dynamic>{'message': instance.message};

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      status: (json['status'] as num).toInt(),
      data: (json['data'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, PlantDashboard.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{'status': instance.status, 'data': instance.data};

_$PlantDashboardImpl _$$PlantDashboardImplFromJson(Map<String, dynamic> json) =>
    _$PlantDashboardImpl(
      gateEntries: (json['gate_entries'] as num).toInt(),
      gateExits: (json['gate_exits'] as num).toInt(),
      daywise:
          (json['daywise'] as List<dynamic>)
              .map((e) => Daywise.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$PlantDashboardImplToJson(
  _$PlantDashboardImpl instance,
) => <String, dynamic>{
  'gate_entries': instance.gateEntries,
  'gate_exits': instance.gateExits,
  'daywise': instance.daywise,
};

_$DaywiseImpl _$$DaywiseImplFromJson(Map<String, dynamic> json) =>
    _$DaywiseImpl(
      day: json['day'] as String,
      entries: (json['entries'] as num).toInt(),
      exits: (json['exits'] as num).toInt(),
    );

Map<String, dynamic> _$$DaywiseImplToJson(_$DaywiseImpl instance) =>
    <String, dynamic>{
      'day': instance.day,
      'entries': instance.entries,
      'exits': instance.exits,
    };
