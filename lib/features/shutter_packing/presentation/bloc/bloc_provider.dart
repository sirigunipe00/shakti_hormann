
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';
import 'package:shakti_hormann/features/shutter_packing/data/shutter_packaging_repo.dart';
import 'package:shakti_hormann/features/shutter_packing/model/items.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_size.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_lines.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_packing.dart';


typedef ShutterCubit = InfiniteListCubit<ShutterPacking, Pair<String?, String?>, Pair<String?, String?>>;
typedef ShutterCubitState = InfiniteListState<ShutterPacking>;
typedef ShutterLinesCubit = NetworkRequestCubit<List<ShutterLines>, String>;
typedef ShutterLinesCubitState = NetworkRequestState<List<ShutterLines>>;
typedef ItemsCubit = NetworkRequestCubit<List<Items>, Pair<String,String>>;
typedef ItemsCubitState = NetworkRequestState<List<Items>>;
typedef PalletSizeCubit = NetworkRequestCubit<List<PalletSize>,String>;
typedef PalletSizeState = NetworkRequestState<List<PalletSize>>;
typedef SalesOrdersCubit = NetworkRequestCubit<List<PalletModel>,String>;
typedef SalesOrderCubitState = NetworkRequestState<List<PalletModel>>;



@lazySingleton
class ShutterBlocProvider {

  const ShutterBlocProvider(this.repo);

  final ShutterPackingRepo repo;

  static ShutterBlocProvider get() => $sl.get<ShutterBlocProvider>();

  ShutterCubit fetchShutter() => ShutterCubit(
  
    requestInitial:
        (params, state) => repo.fetchShutterPacking(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchShutterPacking(state.curLength, params!.first, params.second),
  );
  ShutterLinesCubit getShutterLines() => ShutterLinesCubit(
    onRequest: (params, state) => repo.fetchShutterLines(params!),
  );
   ItemsCubit getItemsLines() => ItemsCubit(
    onRequest: (params, state) => repo.fetchItems(params!.first,params.second),
  );
   PalletSizeCubit getPalletSize() => PalletSizeCubit(
    onRequest: (params, state) => repo.getPalletSize(),
  );
   SalesOrdersCubit getSales() => SalesOrdersCubit(
    onRequest: (params, state) => repo.getSales(q: params ?? ''),
  );

}