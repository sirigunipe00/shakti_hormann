import 'package:freezed_annotation/freezed_annotation.dart';

part 'logged_in_user.freezed.dart';
part 'logged_in_user.g.dart';

@freezed
class LoggedInUser with _$LoggedInUser {
  const LoggedInUser._();

  const factory LoggedInUser({
    required String name,
    String? username,
    @JsonKey(name: 'first_name', defaultValue: '') String? firstName,
    @JsonKey(name: 'last_name', defaultValue: '') String? lastName,
    @JsonKey(name: 'api_key', defaultValue: '') required String apiKey,
    @JsonKey(name: 'api_secret', defaultValue: '') required String apiSecret,
    @JsonKey(name: 'email', defaultValue: '') String? email,
    @JsonKey(defaultValue: '') String? password,
    @JsonKey(name: 'role_profile_name', defaultValue: '')
    String? roleProfileName,
    @JsonKey(name: 'user_type') String? userType,
    @JsonKey(name: 'gender') String? gender,
    @JsonKey(name: 'birth_date') String? birthDate,
    @JsonKey(name: 'depo_name') String? depoName,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'transporter') String? transporter,
    @JsonKey(name: 'customer') String? customer,
    String? phone,
    String? location,
    String? bio,
    @JsonKey(name: 'mobile_no') String? mobileNo,
    @JsonKey(name: 'otp_verified') bool? isOtpVerified,
    @JsonKey(name: 'roles') List<UserRole>? roles,
    @JsonKey(name: 'role_status', fromJson: roleStatusFromJson)
    RoleStatus? roleStatus,
  }) = _LoggedInUser;

  factory LoggedInUser.fromJson(Map<String, dynamic> json) =>
      _$LoggedInUserFromJson(json);
}

@freezed
class UserRole with _$UserRole {
  const factory UserRole({
    @JsonKey(name: 'role') String? role,
  }) = _UserRole;

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);
}

@freezed
class RoleStatus with _$RoleStatus {
  const RoleStatus._();

  const factory RoleStatus({
    @JsonKey(name: 'Show Dashboards in Mobile App') int? showDashboards,
    @JsonKey(name: 'Show Gate Entry in Mobile App') int? showGateEntry,
    @JsonKey(name: 'Show Gate Exit in Mobile App') int? showGateExit,
    @JsonKey(name: 'Show Logistic Request in Mobile App')
    int? showLogisticRequest,
    @JsonKey(name: 'Show Transporter Confirmation in Mobile App')
    int? showTransporterConfirmation,
    @JsonKey(name: 'Show Vehicle Reporting in Mobile App')
    int? showVehicleReporting,
    @JsonKey(name: 'Show Loading Confirmation in Mobile App')
    int? showLoadingConfirmation,
    @JsonKey(name: 'Show Proof of Delivery in Mobile App') int? showpod,
    @JsonKey(name: 'Show Gate Management in Mobile App')
    int? showgateManagement,
    // Scanning & Packaging — same "Show … in Mobile App" pattern as logistics.
    @JsonKey(name: 'Show Pallet Creation in Mobile App') int? showPallet,
    @JsonKey(name: 'Show Shutter Packaging in Mobile App') int? showShutter,
    @JsonKey(name: 'Show Frame Packaging in Mobile App') int? showFrame,
    @JsonKey(name: 'Show Storage Allocation in Mobile App') int? showStorage,
    @JsonKey(name: 'Show Installation Packaging in Mobile App')
    int? showInstalltion,
    @JsonKey(name: 'Show Accessories Packaging in Mobile App') int? showVision,
    @JsonKey(name: 'Show Hardware Packaging in Mobile App') int? showHardware,
    @JsonKey(name: 'Show Where Is My Material in Mobile App')
    int? showWhereIsMyMaterial,
    @JsonKey(name: 'Show Forklift Operator in Mobile App')
    int? showForkliftOperator,
    @JsonKey(name: 'Show Forklift Status in Mobile App')
    int? showForkliftStatus,
  }) = _RoleStatus;

  factory RoleStatus.fromJson(Map<String, dynamic> json) =>
      _$RoleStatusFromJson(json);
}

/// Parses role_status and maps legacy `*-SH` keys to the new
/// `Show … in Mobile App` names during backend migration.
RoleStatus? roleStatusFromJson(Object? json) {
  if (json == null) return null;
  if (json is! Map) return null;
  final normalized = Map<String, dynamic>.from(json);

  // Preferred key → legacy / short aliases copied into the preferred key.
  const aliases = <String, String>{
    'Show Pallet Creation in Mobile App': 'Pallet Creation-SH',
    'Show Shutter Packaging in Mobile App': 'Shutter Packing-SH',
    'Show Frame Packaging in Mobile App': 'Frame Packing-SH',
    'Show Storage Allocation in Mobile App': 'Storage-SH',
    'Show Installation Packaging in Mobile App': 'Installation Packing-SH',
    'Show Accessories Packaging in Mobile App': 'Accessories Packing-SH',
    'Show Hardware Packaging in Mobile App': 'Hardware Packing-SH',
    'Show Forklift Operator in Mobile App': 'Forklift Operator',
    'Show Forklift Status in Mobile App': 'Forklift Supervisor',
  };

  // Extra short keys some Role Status docs use.
  void copyIfMissing(String preferred, String alt) {
    if (normalized[preferred] == null && normalized[alt] != null) {
      normalized[preferred] = normalized[alt];
    }
  }

  copyIfMissing(
    'Show Forklift Operator in Mobile App',
    'Forklift Operator-SH',
  );
  copyIfMissing(
    'Show Forklift Status in Mobile App',
    'Forklift Status',
  );
  copyIfMissing(
    'Show Forklift Status in Mobile App',
    'Forklift Status-SH',
  );

  for (final entry in aliases.entries) {
    if (normalized[entry.key] == null && normalized[entry.value] != null) {
      normalized[entry.key] = normalized[entry.value];
    }
  }

  // Legacy: no dedicated Where Is My Material flag — any packing module on.
  if (normalized['Show Where Is My Material in Mobile App'] == null) {
    final anyPacking = aliases.keys.any((k) => normalized[k] == 1);
    if (anyPacking) {
      normalized['Show Where Is My Material in Mobile App'] = 1;
    }
  }

  return RoleStatus.fromJson(normalized);
}
