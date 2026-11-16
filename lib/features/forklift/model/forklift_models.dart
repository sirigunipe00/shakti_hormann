// Shared Forklift Operator / Status models (API envelope data objects).

class ForkliftPerson {
  const ForkliftPerson({this.user, this.fullName});

  factory ForkliftPerson.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ForkliftPerson();
    return ForkliftPerson(
      user: json['user'] as String?,
      fullName: json['full_name'] as String?,
    );
  }

  final String? user;
  final String? fullName;

  String get displayName =>
      (fullName != null && fullName!.trim().isNotEmpty)
          ? fullName!
          : (user ?? '');
}

class ForkliftCounts {
  const ForkliftCounts({
    this.available = 0,
    this.occupied = 0,
    this.outOfService = 0,
    this.total = 0,
  });

  factory ForkliftCounts.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ForkliftCounts();
    return ForkliftCounts(
      available: (json['available'] as num?)?.toInt() ?? 0,
      occupied: (json['occupied'] as num?)?.toInt() ?? 0,
      outOfService: (json['out_of_service'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  final int available;
  final int occupied;
  final int outOfService;
  final int total;
}

class ForkliftInfo {
  const ForkliftInfo({
    this.forklift,
    this.forkliftNo,
    this.forkliftType,
    this.capacity,
    this.plantName,
    this.status,
    this.currentLog,
    this.occupiedBy,
    this.since,
    this.runningSeconds,
    this.runningMinutes,
    this.runningDuration,
    this.outOfServiceReason,
    this.outOfServiceSince,
  });

  factory ForkliftInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ForkliftInfo();
    return ForkliftInfo(
      forklift: json['forklift'] as String?,
      forkliftNo: json['forklift_no'] as String?,
      forkliftType: json['forklift_type'] as String?,
      capacity: json['capacity'] as String?,
      plantName: json['plant_name'] as String?,
      status: json['status'] as String?,
      currentLog: json['current_log'] as String?,
      occupiedBy: ForkliftPerson.fromJson(
        json['occupied_by'] as Map<String, dynamic>?,
      ),
      since: json['since'] as String?,
      runningSeconds: (json['running_seconds'] as num?)?.toInt(),
      runningMinutes: (json['running_minutes'] as num?)?.toInt(),
      runningDuration: json['running_duration'] as String?,
      outOfServiceReason: json['out_of_service_reason'] as String?,
      outOfServiceSince: json['out_of_service_since'] as String?,
    );
  }

  final String? forklift;
  final String? forkliftNo;
  final String? forkliftType;
  final String? capacity;
  final String? plantName;
  final String? status;
  final String? currentLog;
  final ForkliftPerson? occupiedBy;
  final String? since;
  final int? runningSeconds;
  final int? runningMinutes;
  final String? runningDuration;
  final String? outOfServiceReason;
  final String? outOfServiceSince;

  String get displayNo => forkliftNo ?? forklift ?? '';

  String get shortNo {
    final raw = displayNo;
    final digits = RegExp(r'\d+').allMatches(raw).map((m) => m.group(0)!);
    if (digits.isEmpty) {
      return raw.length <= 3 ? raw : raw.substring(raw.length - 3);
    }
    final last = digits.last;
    return last.length <= 3 ? last.padLeft(3, '0') : last.substring(last.length - 3);
  }

  bool get isAvailable =>
      (status ?? '').toLowerCase() == 'available';
  bool get isOccupied =>
      (status ?? '').toLowerCase() == 'occupied';
  bool get isOutOfService =>
      (status ?? '').toLowerCase().contains('out of service');
}

class ForkliftSession {
  const ForkliftSession({
    this.name,
    this.forklift,
    this.forkliftNo,
    this.forkliftType,
    this.plantName,
    this.user,
    this.fullName,
    this.status,
    this.isActive,
    this.loginDatetime,
    this.loginDate,
    this.loginTime,
    this.logoutDatetime,
    this.logoutDate,
    this.logoutTime,
    this.durationSeconds,
    this.durationMinutes,
    this.duration,
    this.loginMethod,
    this.logoutMethod,
    this.longRunning,
    this.needsReview,
    this.reviewNote,
    this.releaseReason,
    this.releasedBy,
    this.deviceId,
    this.appVersion,
  });

  factory ForkliftSession.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ForkliftSession();
    return ForkliftSession(
      name: json['name'] as String?,
      forklift: json['forklift'] as String?,
      forkliftNo: json['forklift_no'] as String?,
      forkliftType: json['forklift_type'] as String?,
      plantName: json['plant_name'] as String?,
      user: json['user'] as String?,
      fullName: json['full_name'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as bool? ??
          (json['status'] as String?)?.toLowerCase() == 'active',
      loginDatetime: json['login_datetime'] as String?,
      loginDate: json['login_date'] as String?,
      loginTime: json['login_time'] as String?,
      logoutDatetime: json['logout_datetime'] as String?,
      logoutDate: json['logout_date'] as String?,
      logoutTime: json['logout_time'] as String?,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      duration: json['duration'] as String?,
      loginMethod: json['login_method'] as String?,
      logoutMethod: json['logout_method'] as String?,
      longRunning: (json['long_running'] as num?)?.toInt(),
      needsReview: (json['needs_review'] as num?)?.toInt(),
      reviewNote: json['review_note'] as String?,
      releaseReason: json['release_reason'] as String?,
      releasedBy: json['released_by'] as String?,
      deviceId: json['device_id'] as String?,
      appVersion: json['app_version'] as String?,
    );
  }

  final String? name;
  final String? forklift;
  final String? forkliftNo;
  final String? forkliftType;
  final String? plantName;
  final String? user;
  final String? fullName;
  final String? status;
  final bool? isActive;
  final String? loginDatetime;
  final String? loginDate;
  final String? loginTime;
  final String? logoutDatetime;
  final String? logoutDate;
  final String? logoutTime;
  final int? durationSeconds;
  final int? durationMinutes;
  final String? duration;
  final String? loginMethod;
  final String? logoutMethod;
  final int? longRunning;
  final int? needsReview;
  final String? reviewNote;
  final String? releaseReason;
  final String? releasedBy;
  final String? deviceId;
  final String? appVersion;

  String get displayForklift => forkliftNo ?? forklift ?? '';
  String get operatorLabel =>
      (fullName != null && fullName!.trim().isNotEmpty)
          ? fullName!
          : (user ?? '');
  bool get active => isActive == true;

  String get shortNo {
    final raw = displayForklift;
    final digits = RegExp(r'\d+').allMatches(raw).map((m) => m.group(0)!);
    if (digits.isEmpty) {
      return raw.length <= 3 ? raw : raw.substring(raw.length - 3);
    }
    final last = digits.last;
    return last.length <= 3 ? last.padLeft(3, '0') : last.substring(last.length - 3);
  }
}

class ForkliftHomeSummary {
  const ForkliftHomeSummary({
    this.showForkliftOperator = 0,
    this.showForkliftStatus = 0,
    this.isSupervisor = 0,
    this.counts = const ForkliftCounts(),
    this.totalForklifts = 0,
    this.activeSessions = 0,
    this.myActiveSession,
    this.operator,
  });

  factory ForkliftHomeSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ForkliftHomeSummary();
    return ForkliftHomeSummary(
      showForkliftOperator:
          (json['show_forklift_operator'] as num?)?.toInt() ?? 0,
      showForkliftStatus:
          (json['show_forklift_status'] as num?)?.toInt() ?? 0,
      isSupervisor: (json['is_supervisor'] as num?)?.toInt() ?? 0,
      counts: ForkliftCounts.fromJson(
        json['counts'] as Map<String, dynamic>?,
      ),
      totalForklifts: (json['total_forklifts'] as num?)?.toInt() ?? 0,
      activeSessions: (json['active_sessions'] as num?)?.toInt() ?? 0,
      myActiveSession: json['my_active_session'] is Map<String, dynamic>
          ? ForkliftSession.fromJson(
              json['my_active_session'] as Map<String, dynamic>,
            )
          : null,
      operator: ForkliftPerson.fromJson(
        json['operator'] as Map<String, dynamic>?,
      ),
    );
  }

  final int showForkliftOperator;
  final int showForkliftStatus;
  final int isSupervisor;
  final ForkliftCounts counts;
  final int totalForklifts;
  final int activeSessions;
  final ForkliftSession? myActiveSession;
  final ForkliftPerson? operator;
}

class ForkliftStatusListResult {
  const ForkliftStatusListResult({
    this.forklifts = const [],
    this.counts = const ForkliftCounts(),
    this.total = 0,
  });

  factory ForkliftStatusListResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ForkliftStatusListResult();
    final list = (json['forklifts'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((e) => ForkliftInfo.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return ForkliftStatusListResult(
      forklifts: list,
      counts: ForkliftCounts.fromJson(
        json['counts'] as Map<String, dynamic>?,
      ),
      total: (json['total'] as num?)?.toInt() ?? list.length,
    );
  }

  final List<ForkliftInfo> forklifts;
  final ForkliftCounts counts;
  final int total;
}

class ForkliftLogsResult {
  const ForkliftLogsResult({
    this.logs = const [],
    this.total = 0,
    this.hasMore = false,
  });

  factory ForkliftLogsResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ForkliftLogsResult();
    final list = (json['logs'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((e) => ForkliftSession.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return ForkliftLogsResult(
      logs: list,
      total: (json['total'] as num?)?.toInt() ?? list.length,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }

  final List<ForkliftSession> logs;
  final int total;
  final bool hasMore;
}

class ForkliftRecordLink {
  const ForkliftRecordLink({this.doctype, this.name, this.route});

  factory ForkliftRecordLink.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ForkliftRecordLink();
    return ForkliftRecordLink(
      doctype: json['doctype'] as String?,
      name: json['name'] as String?,
      route: json['route'] as String?,
    );
  }

  final String? doctype;
  final String? name;
  final String? route;

  bool get hasName => name != null && name!.trim().isNotEmpty;
}

class ForkliftScanResult {
  const ForkliftScanResult({
    required this.ok,
    this.action,
    this.forklift,
    this.operator,
    this.occupiedBy,
    this.since,
    this.log,
    this.currentSession,
    this.scannedForklift,
    this.recordLink,
    this.popupMessage,
    this.code,
  });

  factory ForkliftScanResult.fromMessage(Map<String, dynamic> message) {
    final data = message['data'] as Map<String, dynamic>? ?? {};
    final scanned = data['scanned_forklift'] as Map<String, dynamic>?;
    final forkliftJson =
        (data['forklift'] as Map<String, dynamic>?) ?? scanned;
    return ForkliftScanResult(
      ok: message['ok'] == true,
      action: data['action'] as String?,
      forklift: ForkliftInfo.fromJson(forkliftJson),
      operator: ForkliftPerson.fromJson(
        data['operator'] as Map<String, dynamic>?,
      ),
      occupiedBy: ForkliftPerson.fromJson(
        data['occupied_by'] as Map<String, dynamic>?,
      ),
      since: data['since'] as String?,
      log: data['log'] is Map<String, dynamic>
          ? ForkliftSession.fromJson(data['log'] as Map<String, dynamic>)
          : null,
      currentSession: data['current_session'] is Map<String, dynamic>
          ? ForkliftSession.fromJson(
              data['current_session'] as Map<String, dynamic>,
            )
          : null,
      scannedForklift: ForkliftInfo.fromJson(scanned),
      recordLink: ForkliftRecordLink.fromJson(
        data['record_link'] as Map<String, dynamic>?,
      ),
      popupMessage: (data['popup_message'] as String?) ??
          (message['message'] as String?),
      code: message['code'] as String?,
    );
  }

  final bool ok;
  final String? action;
  final ForkliftInfo? forklift;
  final ForkliftPerson? operator;
  final ForkliftPerson? occupiedBy;
  final String? since;
  final ForkliftSession? log;
  final ForkliftSession? currentSession;
  final ForkliftInfo? scannedForklift;
  final ForkliftRecordLink? recordLink;
  final String? popupMessage;
  final String? code;

  bool get isStart => action == 'start';
  bool get isStop => action == 'stop';
  bool get isMustLogout =>
      action == 'must_logout' || code == 'ACTIVE_ON_OTHER_FORKLIFT';

  /// Active session the operator must close before logging into another forklift.
  ForkliftSession? get activeSessionForLogout {
    final linked = recordLink?.name?.trim();
    if (currentSession != null) {
      if (linked == null || linked.isEmpty) return currentSession;
      if ((currentSession!.name ?? '').isEmpty) {
        return ForkliftSession(
          name: linked,
          forklift: currentSession!.forklift,
          forkliftNo: currentSession!.forkliftNo,
          forkliftType: currentSession!.forkliftType,
          plantName: currentSession!.plantName,
          user: currentSession!.user,
          fullName: currentSession!.fullName,
          status: currentSession!.status,
          isActive: currentSession!.isActive ?? true,
          loginDatetime: currentSession!.loginDatetime,
          loginDate: currentSession!.loginDate,
          loginTime: currentSession!.loginTime,
        );
      }
      return currentSession;
    }
    if (log != null) {
      if (linked == null ||
          linked.isEmpty ||
          (log!.name ?? '').isNotEmpty) {
        return log;
      }
      return ForkliftSession(name: linked, forklift: log!.forklift, forkliftNo: log!.forkliftNo);
    }
    if (linked != null && linked.isNotEmpty) {
      return ForkliftSession(name: linked);
    }
    return null;
  }
}

class ForkliftLoginResult {
  const ForkliftLoginResult({
    this.ok = true,
    this.action,
    this.log,
    this.forklift,
    this.operator,
    this.currentSession,
    this.recordLink,
    this.popupMessage,
    this.code,
  });

  factory ForkliftLoginResult.fromMessage(Map<String, dynamic> message) {
    final data = message['data'] as Map<String, dynamic>? ?? {};
    return ForkliftLoginResult(
      ok: message['ok'] == true,
      action: data['action'] as String?,
      log: ForkliftSession.fromJson(data['log'] as Map<String, dynamic>?),
      forklift: ForkliftInfo.fromJson(
        data['forklift'] as Map<String, dynamic>?,
      ),
      operator: ForkliftPerson.fromJson(
        data['operator'] as Map<String, dynamic>?,
      ),
      currentSession: data['current_session'] is Map<String, dynamic>
          ? ForkliftSession.fromJson(
              data['current_session'] as Map<String, dynamic>,
            )
          : null,
      recordLink: ForkliftRecordLink.fromJson(
        data['record_link'] as Map<String, dynamic>?,
      ),
      popupMessage: (data['popup_message'] as String?) ??
          (message['message'] as String?),
      code: message['code'] as String?,
    );
  }

  factory ForkliftLoginResult.fromData(Map<String, dynamic>? data) {
    if (data == null) return const ForkliftLoginResult();
    return ForkliftLoginResult(
      log: ForkliftSession.fromJson(data['log'] as Map<String, dynamic>?),
      forklift: ForkliftInfo.fromJson(
        data['forklift'] as Map<String, dynamic>?,
      ),
      operator: ForkliftPerson.fromJson(
        data['operator'] as Map<String, dynamic>?,
      ),
      currentSession: data['current_session'] is Map<String, dynamic>
          ? ForkliftSession.fromJson(
              data['current_session'] as Map<String, dynamic>,
            )
          : null,
      recordLink: ForkliftRecordLink.fromJson(
        data['record_link'] as Map<String, dynamic>?,
      ),
      action: data['action'] as String?,
      popupMessage: data['popup_message'] as String?,
      code: data['code'] as String?,
    );
  }

  final bool ok;
  final String? action;
  final ForkliftSession? log;
  final ForkliftInfo? forklift;
  final ForkliftPerson? operator;
  final ForkliftSession? currentSession;
  final ForkliftRecordLink? recordLink;
  final String? popupMessage;
  final String? code;

  bool get isMustLogout =>
      action == 'must_logout' || code == 'ACTIVE_ON_OTHER_FORKLIFT';

  ForkliftSession? get activeSessionForLogout {
    final linked = recordLink?.name?.trim();
    if (currentSession != null) {
      if (linked == null ||
          linked.isEmpty ||
          (currentSession!.name ?? '').isNotEmpty) {
        return currentSession;
      }
      return ForkliftSession(
        name: linked,
        forklift: currentSession!.forklift,
        forkliftNo: currentSession!.forkliftNo,
      );
    }
    if (log != null && (log!.name ?? '').isNotEmpty) return log;
    if (linked != null && linked.isNotEmpty) {
      return ForkliftSession(name: linked);
    }
    return null;
  }
}

class ForkliftLogoutResult {
  const ForkliftLogoutResult({
    this.log,
    this.forklift,
    this.popupMessage,
  });

  factory ForkliftLogoutResult.fromData(Map<String, dynamic>? data) {
    if (data == null) return const ForkliftLogoutResult();
    return ForkliftLogoutResult(
      log: ForkliftSession.fromJson(data['log'] as Map<String, dynamic>?),
      forklift: ForkliftInfo.fromJson(
        data['forklift'] as Map<String, dynamic>?,
      ),
      popupMessage: data['popup_message'] as String?,
    );
  }

  final ForkliftSession? log;
  final ForkliftInfo? forklift;
  final String? popupMessage;
}

class ForkliftDetailResult {
  const ForkliftDetailResult({
    this.forklift,
    this.status,
    this.occupiedBy,
    this.since,
    this.currentLog,
    this.usedLast8Hours,
    this.recentUsers = const [],
    this.popupMessage,
  });

  factory ForkliftDetailResult.fromData(Map<String, dynamic>? data) {
    if (data == null) return const ForkliftDetailResult();
    final recent = (data['recent_users'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((e) => ForkliftSession.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return ForkliftDetailResult(
      forklift: ForkliftInfo.fromJson(
        data['forklift'] as Map<String, dynamic>?,
      ),
      status: data['status'] as String?,
      occupiedBy: ForkliftPerson.fromJson(
        data['occupied_by'] as Map<String, dynamic>?,
      ),
      since: data['since'] as String?,
      currentLog: data['current_log'] is Map<String, dynamic>
          ? ForkliftSession.fromJson(
              data['current_log'] as Map<String, dynamic>,
            )
          : null,
      usedLast8Hours: data['used_last_8_hours'] as Map<String, dynamic>?,
      recentUsers: recent,
      popupMessage: data['popup_message'] as String?,
    );
  }

  final ForkliftInfo? forklift;
  final String? status;
  final ForkliftPerson? occupiedBy;
  final String? since;
  final ForkliftSession? currentLog;
  final Map<String, dynamic>? usedLast8Hours;
  final List<ForkliftSession> recentUsers;
  final String? popupMessage;
}

class ForkliftLogDetailResult {
  const ForkliftLogDetailResult({
    this.log,
    this.forklift,
    this.operator,
    this.popupMessage,
  });

  factory ForkliftLogDetailResult.fromData(Map<String, dynamic>? data) {
    if (data == null) return const ForkliftLogDetailResult();
    return ForkliftLogDetailResult(
      log: ForkliftSession.fromJson(data['log'] as Map<String, dynamic>?),
      forklift: ForkliftInfo.fromJson(
        data['forklift'] as Map<String, dynamic>?,
      ),
      operator: ForkliftPerson.fromJson(
        data['operator'] as Map<String, dynamic>?,
      ),
      popupMessage: data['popup_message'] as String?,
    );
  }

  final ForkliftSession? log;
  final ForkliftInfo? forklift;
  final ForkliftPerson? operator;
  final String? popupMessage;
}
