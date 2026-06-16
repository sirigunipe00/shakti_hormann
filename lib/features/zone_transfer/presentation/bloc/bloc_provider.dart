
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/zone_transfer/data/zone_repo.dart';

typedef ZoneCubit = InfiniteListCubit<GateEntryForm, Pair<int?, String?>, Pair<int?, String?>>;
typedef ZoneCubitState = InfiniteListState<GateEntryForm>;

@lazySingleton
class ZoneBlocProvider {

  const ZoneBlocProvider(this.repo);

  final ZoneRepo repo;

  static ZoneBlocProvider get() => $sl.get<ZoneBlocProvider>();

  ZoneCubit fetchZone() => ZoneCubit(
  
    requestInitial:
        (params, state) => repo.fetchZone(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchZone(state.curLength, params!.first, params.second),
  );

}