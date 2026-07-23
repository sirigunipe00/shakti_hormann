import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/data/pallet_repo.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_items.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';

typedef PalletCubit = InfiniteListCubit<PalletModel, Pair<int?, String?>, Pair<int?, String?>>;
typedef PalletState = InfiniteListState<PalletModel>;

typedef PalletItemCubit
    = NetworkRequestCubit<List<PalletItems>, String>;
typedef PalletItemState
    = NetworkRequestState<List<PalletItems>>;
typedef PalletSales
    = NetworkRequestCubit<List<SalesOrderForm>, String>;
typedef PalletSalesState
    = NetworkRequestState<List<SalesOrderForm>>;

@lazySingleton
class PalletBlocProvider {

  const PalletBlocProvider(this.repo);

  final PalletRepo repo;

  static PalletBlocProvider get() => $sl.get<PalletBlocProvider>();

  PalletCubit getPallet() => PalletCubit(
  
    requestInitial:
        (params, state) => repo.fetchPallet(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchPallet(state.curLength, params!.first, params.second),
  );
   PalletItemCubit getPalletItems() => PalletItemCubit(
    onRequest: (params, state) => repo.fetchPalletItems(params ?? ''),
  );
  PalletSales saleOrder() => PalletSales(
    onRequest: (params, state) => repo.salesOrder(),
  );

}