
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/hardware_packing/data/hardware_repo.dart';


typedef HardwareCubit = InfiniteListCubit<GateEntryForm, Pair<int?, String?>, Pair<int?, String?>>;
typedef HardwareCubitState = InfiniteListState<GateEntryForm>;

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

}