
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/features/dashboard/data/dashboardrepo.dart';
import 'package:shakti_hormann/features/dashboard/model/gate_dashboard_response.dart';

typedef DashBoardList
    = NetworkRequestCubit<GateDashboardResponse, String>;
typedef DashBoardState
    = NetworkRequestState<GateDashboardResponse>;

@lazySingleton
class DashBoardBlocProvider {
  const DashBoardBlocProvider(this.repo);

  final Dashboardrepo repo;

  static DashBoardBlocProvider get() => $sl.get<DashBoardBlocProvider>();
DashBoardList getDash() => DashBoardList(
    onRequest: (params, state) => repo.getDashboard(),
  );

}