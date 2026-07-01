import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';
import 'package:shakti_hormann/features/pallet_creation/data/pallet_repo.dart';

typedef PalletCubit = InfiniteListCubit<FramePacking, Pair<int?, String?>, Pair<int?, String?>>;
typedef PalletState = InfiniteListState<FramePacking>;



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
}