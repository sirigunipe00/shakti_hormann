import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';
import 'package:shakti_hormann/features/proof_of_delivery/data/pod_repo.dart';
import 'package:shakti_hormann/features/proof_of_delivery/model/proof_of_delivery.dart';

typedef ProofOfDeliveryCubit =
    InfiniteListCubit<ProofOfDelivery, Pair<int?, String?>, Pair<int?, String?>>;
typedef ProofOfDeliveryState = InfiniteListState<ProofOfDelivery>;

typedef SalesInvoiceList
    = NetworkRequestCubit<List<SalesInvoiceForm>, String>;
typedef SalesInvoiceState
    = NetworkRequestState<List<SalesInvoiceForm>>;



@lazySingleton
class ProofOfDeliveryBlocProvider {
  const ProofOfDeliveryBlocProvider(this.repo);

  final ProofOfDeliveryRepo repo;

  static ProofOfDeliveryBlocProvider get() => $sl.get<ProofOfDeliveryBlocProvider>();

  ProofOfDeliveryCubit fetchProofOfDelivery() => ProofOfDeliveryCubit(
    requestInitial:
        (params, state) => repo.fetchPod(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchPod(state.curLength, params!.first, params.second),
  );

  SalesInvoiceList salesInvoiceList() => SalesInvoiceList(
    onRequest: (params, state) => repo.fetchSalesInvoice(params ?? ''),
  );
}