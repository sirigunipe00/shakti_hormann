import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/gate_exit/data/gate_exit_repo.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate_exit_form.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';

typedef GateExitCubit =
    InfiniteListCubit<GateExitForm, Pair<int?, String?>, Pair<int?, String?>>;
typedef GateExitCubitState = InfiniteListState<GateExitForm>;

typedef SalesInvoiceList
    = NetworkRequestCubit<List<SalesInvoiceForm>, String>;
typedef SalesInvoiceState
    = NetworkRequestState<List<SalesInvoiceForm>>;

@lazySingleton
class GateExitBlocProvider {
  const GateExitBlocProvider(this.repo);

  final GateExitRepo repo;

  static GateExitBlocProvider get() => $sl.get<GateExitBlocProvider>();

  GateExitCubit fetchGateExit() => GateExitCubit(
    requestInitial:
        (params, state) => repo.fetchEntries(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchEntries(state.curLength, params!.first, params.second),
  );

  SalesInvoiceList salesInvoiceList() => SalesInvoiceList(
    onRequest: (params, state) => repo.fetchSalesInvoice(params ?? ''),
  );
}
