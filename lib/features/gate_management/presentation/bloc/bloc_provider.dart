import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/gate_management/data/gate_management_repo.dart';
import 'package:shakti_hormann/features/gate_management/model/gate_management_form.dart';

typedef GateMangementCubit =
    InfiniteListCubit<GateManagementForm, Pair<int?, String?>, Pair<int?, String?>>;
typedef GateMangementState = InfiniteListState<GateManagementForm>;


@lazySingleton
class GateManagementBlocProvider {
  const GateManagementBlocProvider(this.repo);
  final GateManagementRepo repo;

  static GateManagementBlocProvider get() => $sl.get<GateManagementBlocProvider>();

  GateMangementCubit fetchGateManagements()=> GateMangementCubit(
    requestInitial:
        (params, state) => repo.fetchGateManagements(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchGateManagements(state.curLength, params!.first, params.second),
  );




}