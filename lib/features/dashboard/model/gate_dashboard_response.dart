import 'package:freezed_annotation/freezed_annotation.dart';

part 'gate_dashboard_response.freezed.dart';
part 'gate_dashboard_response.g.dart';

@freezed
class GateDashboardResponse with _$GateDashboardResponse {
  const factory GateDashboardResponse({
    required Message message,
  }) = _GateDashboardResponse;

  factory GateDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$GateDashboardResponseFromJson(json);
}

@freezed
class Message with _$Message {
  const factory Message({
    required int status,
    required Map<String, PlantDashboard> data,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

@freezed
class PlantDashboard with _$PlantDashboard {
  const factory PlantDashboard({
    @JsonKey(name: 'gate_entries') required int gateEntries,
    @JsonKey(name: 'gate_exits') required int gateExits,
    required List<Daywise> daywise,
  }) = _PlantDashboard;

  factory PlantDashboard.fromJson(Map<String, dynamic> json) =>
      _$PlantDashboardFromJson(json);
}

@freezed
class Daywise with _$Daywise {
  const factory Daywise({
    required String day,
    required int entries,
    required int exits,
  }) = _Daywise;

  factory Daywise.fromJson(Map<String, dynamic> json) =>
      _$DaywiseFromJson(json);
}
