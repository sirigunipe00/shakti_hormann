
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/hardware_packing/data/hardware_repo.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_item.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_packing.dart';



typedef HardwareCubit = InfiniteListCubit<HardwarePacking, Pair<String?, String?>, Pair<String?, String?>>;
typedef HardwareCubitState = InfiniteListState<HardwarePacking>;
typedef HardwareItemsCubit = NetworkRequestCubit<List<HardwareItem>, String>;
typedef HardwareItemsState = NetworkRequestState<List<HardwareItem>>;

@lazySingleton
class HardwareBlocProvider {

  const HardwareBlocProvider(this.repo);

  final HardWareRepo repo;

  static HardwareBlocProvider get() => $sl.get<HardwareBlocProvider>();

  HardwareCubit fetchHardware() => HardwareCubit(
  
    requestInitial:
        (params, state) => repo.fetchHardware(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchHardware(state.curLength, params!.first, params.second),
  );
  HardwareItemsCubit getItemsLines() => HardwareItemsCubit(
    onRequest: (params, state) => repo.fetchItems(params?? ''),
  );

}