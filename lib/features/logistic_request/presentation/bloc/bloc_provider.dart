import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/logistic_request/data/logistic_planning_repo.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';

typedef LogisticPlanningCubit =
    InfiniteListCubit<
      LogisticPlanningForm,
      Pair<String?, String?>,
      Pair<String?, String?>
    >;
typedef LogisticPlanningState = InfiniteListState<LogisticPlanningForm>;

typedef SalesOrderList = NetworkRequestCubit<List<SalesOrderForm>, String>;
typedef SalesOrderState = NetworkRequestState<List<SalesOrderForm>>;
typedef TransportersList = NetworkRequestCubit<List<TransportersForm>, String>;
typedef TransportersState = NetworkRequestState<List<TransportersForm>>;

@lazySingleton
class LogisticPlanningBlocProvider {
  const LogisticPlanningBlocProvider(this.repo);

  final LogisticPlanningRepo repo;

  static LogisticPlanningBlocProvider get() =>
      $sl.get<LogisticPlanningBlocProvider>();

  LogisticPlanningCubit fetchLogistics() => LogisticPlanningCubit(
    requestInitial:
        (params, state) =>
            repo.fetchLogistics(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchLogistics(state.curLength, params!.first, params.second),
  );

  SalesOrderList salesOrderList() => SalesOrderList(
    onRequest: (params, state) => repo.fetchSalesOrder(params ?? ''),
  );

  TransportersList transportersList() =>
      TransportersList(onRequest: (params, state) => repo.fetchTransporters());
}
