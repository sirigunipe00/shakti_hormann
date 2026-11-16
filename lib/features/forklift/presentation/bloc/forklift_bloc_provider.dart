import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/forklift/data/forklift_repo.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';

typedef ForkliftOperatorCubit
    = InfiniteListCubit<ForkliftSession, Pair<String?, String?>,
        Pair<String?, String?>>;
typedef ForkliftOperatorState = InfiniteListState<ForkliftSession>;

typedef ForkliftStatusCubit
    = InfiniteListCubit<ForkliftInfo, Pair<String?, String?>,
        Pair<String?, String?>>;
typedef ForkliftStatusState = InfiniteListState<ForkliftInfo>;

@lazySingleton
class ForkliftBlocProvider {
  const ForkliftBlocProvider(this.repo);

  final ForkliftRepo repo;

  static ForkliftBlocProvider get() => $sl.get<ForkliftBlocProvider>();

  static const _pageSize = 20;

  /// params: Pair(statusFilter, searchQuery)
  ForkliftOperatorCubit operatorLogs() => ForkliftOperatorCubit(
        requestInitial: (params, state) async {
          final status = _mapOperatorStatus(params?.first);
          final search = params?.second?.trim();
          final result = await repo.fetchOperatorLogs(
            status: status,
            search: search,
            page: 1,
            pageSize: _pageSize,
          );
          return result.fold(left, (logs) {
            final q = (search ?? '').toLowerCase();
            if (q.isEmpty) return right(logs);
            // Light client filter on this page only (no second full fetch).
            return right(
              logs.where((s) => _matchesOperatorSearch(s, q)).toList(),
            );
          });
        },
        requestMore: (params, state) async {
          final status = _mapOperatorStatus(params?.first);
          final search = params?.second?.trim();
          final nextPage = (state.curLength ~/ _pageSize) + 1;
          final result = await repo.fetchOperatorLogs(
            status: status,
            search: search,
            page: nextPage,
            pageSize: _pageSize,
          );
          return result.fold(left, (logs) {
            final q = (search ?? '').toLowerCase();
            if (q.isEmpty) return right(logs);
            return right(
              logs.where((s) => _matchesOperatorSearch(s, q)).toList(),
            );
          });
        },
      );

  bool _matchesOperatorSearch(ForkliftSession s, String q) {
    bool has(String? v) => (v ?? '').toLowerCase().contains(q);
    return has(s.name) ||
        has(s.forkliftNo) ||
        has(s.forklift) ||
        has(s.user) ||
        has(s.fullName) ||
        has(s.operatorLabel);
  }

  /// params: Pair(statusFilter, searchQuery)
  ForkliftStatusCubit statusList() => ForkliftStatusCubit(
        requestInitial: (params, state) async {
          final plant = $sl.isRegistered<LoggedInUser>()
              ? $sl.get<LoggedInUser>().plantName
              : null;
          final result = await repo.getStatusList(
            status: _mapFleetStatus(params?.first),
            search: params?.second,
            plantName: plant,
          );
          return result.fold(
            left,
            (r) => right(r.forklifts),
          );
        },
        requestMore: (params, state) async =>
            const Right<Failure, List<ForkliftInfo>>([]),
      );

  String? _mapOperatorStatus(String? filter) {
    if (filter == null) return null;
    switch (filter.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'logged out':
        return 'Logged Out';
      case 'all':
        return null;
      default:
        return filter;
    }
  }

  String? _mapFleetStatus(String? filter) {
    if (filter == null) return null;
    switch (filter.toLowerCase()) {
      case 'available':
      case 'free':
        return 'Available';
      case 'occupied':
      case 'in use':
        return 'Occupied';
      case 'out of service':
        return 'Out of Service';
      case 'all':
        return null;
      default:
        return filter;
    }
  }
}
