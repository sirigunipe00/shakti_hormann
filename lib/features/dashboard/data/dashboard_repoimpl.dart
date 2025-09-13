import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/consts/urls.dart';
import 'package:shakti_hormann/core/logger/app_logger.dart';
import 'package:shakti_hormann/core/network/network.dart';
import 'package:shakti_hormann/core/utils/utils.dart';
import 'package:shakti_hormann/features/dashboard/data/dashboardrepo.dart';
import 'package:shakti_hormann/features/dashboard/model/gate_dashboard_response.dart';




@LazySingleton(as: Dashboardrepo)
class DashboardRepoimpl extends BaseApiRepository implements Dashboardrepo {
  const DashboardRepoimpl(super.client);

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
}



