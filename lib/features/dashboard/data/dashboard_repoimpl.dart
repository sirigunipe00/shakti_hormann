import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/consts/urls.dart';
import 'package:shakti_hormann/core/logger/app_logger.dart';
import 'package:shakti_hormann/core/network/network.dart';
import 'package:shakti_hormann/core/utils/utils.dart';
import 'package:shakti_hormann/features/dashboard/data/dashboardrepo.dart';
import 'package:shakti_hormann/features/dashboard/model/gate_dashboard_response.dart';
import 'package:shakti_hormann/features/dashboard/model/packing_dashboard_stats.dart';

@LazySingleton(as: Dashboardrepo)
class DashboardRepoimpl extends BaseApiRepository implements Dashboardrepo {
  const DashboardRepoimpl(super.client);

  static const _modules = <({
    String key,
    String label,
    String doctype,
    int color,
  })>[
    (key: 'pallet', label: 'Pallet', doctype: 'Pallet', color: 0xFF163A6B),
    (
      key: 'shutter',
      label: 'Shutter',
      doctype: 'Shutter Packing',
      color: 0xFF2F6FED,
    ),
    (
      key: 'frame',
      label: 'Frame',
      doctype: 'Frame Packing',
      color: 0xFF1A7A5C,
    ),
    (
      key: 'hardware',
      label: 'Hardware',
      doctype: 'Hardware Packing',
      color: 0xFFC45C3E,
    ),
    (
      key: 'accessories',
      label: 'Accessories',
      doctype: 'Vision Panel',
      color: 0xFFF2A93E,
    ),
    (
      key: 'installation',
      label: 'Installation',
      doctype: 'Installation Entry',
      color: 0xFF7B5EA7,
    ),
    (
      key: 'storage',
      label: 'Storage',
      doctype: 'Storage Zone',
      color: 0xFF0E8A8A,
    ),
  ];

  @override
  AsyncValueOf<GateDashboardResponse> getDashboard() async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.dashBoard,
        parser: (json) => GateDashboardResponse.fromJson(json),
      );

      final response = await get(config);
      $logger.devLog('dashboard.........$response');

      return response.processAsync((r) async {
        return right(r.data!);
      });
    });
  }

  @override
  AsyncValueOf<PackingDashboardStats> getPackingStats() async {
    return await executeSafely(() async {
      final results = await Future.wait(
        _modules.map(_loadModule),
      );

      final modules = <PackingModuleStat>[];
      final dayMap = <String, ({int created, int submitted})>{};

      for (final result in results) {
        modules.add(result.stat);
        result.daywise.forEach((day, counts) {
          final prev = dayMap[day] ?? (created: 0, submitted: 0);
          dayMap[day] = (
            created: prev.created + counts.created,
            submitted: prev.submitted + counts.submitted,
          );
        });
      }

      final today = DateTime.now();
      final daywise = <PackingDayPoint>[];
      // 30-day window so quieter weeks still show shop-floor trends.
      for (var i = 29; i >= 0; i--) {
        final d = today.subtract(Duration(days: i));
        final key =
            '${d.year.toString().padLeft(4, '0')}-'
            '${d.month.toString().padLeft(2, '0')}-'
            '${d.day.toString().padLeft(2, '0')}';
        final counts = dayMap[key] ?? (created: 0, submitted: 0);
        daywise.add(
          PackingDayPoint(
            day: key,
            created: counts.created,
            submitted: counts.submitted,
          ),
        );
      }

      return right(
        PackingDashboardStats(modules: modules, daywise: daywise),
      );
    });
  }

  Future<({PackingModuleStat stat, Map<String, ({int created, int submitted})> daywise})>
      _loadModule(
    ({String key, String label, String doctype, int color}) module,
  ) async {
    final draft = await _count(module.doctype, [
      ['docstatus', '=', 0],
    ]);
    final submitted = await _count(module.doctype, [
      ['docstatus', '=', 1],
    ]);
    final cancelled = await _count(module.doctype, [
      ['docstatus', '=', 2],
    ]);
    final daywise = await _recentDaywise(module.doctype);

    return (
      stat: PackingModuleStat(
        key: module.key,
        label: module.label,
        doctype: module.doctype,
        draft: draft,
        submitted: submitted,
        cancelled: cancelled,
        color: module.color,
      ),
      daywise: daywise,
    );
  }

  Future<int> _count(String doctype, List<List<dynamic>> filters) async {
    try {
      final config = RequestConfig<int>(
        url: Urls.getCount,
        parser: (json) {
          final msg = json['message'];
          if (msg is num) return msg.toInt();
          if (msg is String) return int.tryParse(msg) ?? 0;
          return 0;
        },
        reqParams: {
          'doctype': doctype,
          'filters': jsonEncode(filters),
        },
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      final response = await get(config);
      final count = response.fold((_) => 0, (r) => r.data ?? 0);
      return count;
    } on Exception catch (e, st) {
      $logger.error('[packing count] $doctype', e, st);
      return 0;
    }
  }

  Future<Map<String, ({int created, int submitted})>> _recentDaywise(
    String doctype,
  ) async {
    final map = <String, ({int created, int submitted})>{};
    try {
      final config = RequestConfig<List<Map<String, dynamic>>>(
        url: Urls.getList,
        parser: (json) {
          final raw = json['message'];
          if (raw is! List) return <Map<String, dynamic>>[];
          return raw
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        },
        reqParams: {
          'doctype': doctype,
          'fields': jsonEncode(['name', 'docstatus', 'creation']),
          'limit_start': 0,
          'limit_page_length': 500,
          'order_by': 'creation desc',
        },
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      final response = await get(config);
      final rows = await response.fold(
        (_) async => <Map<String, dynamic>>[],
        (r) async => r.data ?? <Map<String, dynamic>>[],
      );

      final cutoff = DateTime.now().subtract(const Duration(days: 30));
      for (final row in rows) {
        final creationRaw = row['creation']?.toString() ?? '';
        if (creationRaw.length < 10) continue;
        final day = creationRaw.substring(0, 10);
        final createdAt = DateTime.tryParse(creationRaw);
        if (createdAt == null || createdAt.isBefore(cutoff)) continue;

        final docstatus = row['docstatus'];
        final status = docstatus is num
            ? docstatus.toInt()
            : int.tryParse('$docstatus') ?? 0;
        final prev = map[day] ?? (created: 0, submitted: 0);
        map[day] = (
          created: prev.created + 1,
          submitted: prev.submitted + (status == 1 ? 1 : 0),
        );
      }
    } on Exception catch (e, st) {
      $logger.error('[packing daywise] $doctype', e, st);
    }
    return map;
  }
}
