import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/data/gate_entry.repo.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_number_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order_form.dart';

typedef GateEntriesCubit =
    InfiniteListCubit<GateEntryForm, Pair<int?, String?>, Pair<int?, String?>>;
typedef GateEntriesCubitState = InfiniteListState<GateEntryForm>;


typedef PurchaseOrderList
    = NetworkRequestCubit<List<PurchaseOrderForm>, String>;
typedef PurchaseOrderState
    = NetworkRequestState<List<PurchaseOrderForm>>;


typedef GateNumberList
    = NetworkRequestCubit<List<GateNumberForm>, String>;
typedef GateNumberState
    = NetworkRequestState<List<GateNumberForm>>;

typedef Purchase
    = NetworkRequestCubit<List<PurchaseOrder>, String>;
typedef PurchaseState
    = NetworkRequestState<List<PurchaseOrder>>;

@lazySingleton
class GateEntryBlocProvider {
  const GateEntryBlocProvider(this.repo);

  final GateEntryRepo repo;

  static GateEntryBlocProvider get() => $sl.get<GateEntryBlocProvider>();

  GateEntriesCubit fetchGateEntries() => GateEntriesCubit(
    requestInitial:
        (params, state) => repo.fetchEntries(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchEntries(state.curLength, params!.first, params.second),
  );
 
      PurchaseOrderList purchaseOrderList() => PurchaseOrderList(
    onRequest: (params, state) => repo.fetchPurchaseOrders(params ?? ''),
  );
      GateNumberList gateNumberList() => GateNumberList(
    onRequest: (params, state) => repo.fetchGateNumber(params ?? ''),
  );
    Purchase getPurchase() => Purchase(
    onRequest: (params, state) => repo.fetchPurchase(params ?? ''),
  );
}
