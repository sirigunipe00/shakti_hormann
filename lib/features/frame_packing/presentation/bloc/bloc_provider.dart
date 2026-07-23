
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/frame_packing/data/frame_packing_repo.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_items.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_lines.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_size.dart';



typedef FrameCubit = InfiniteListCubit<FramePacking, Pair<int?, String?>, Pair<int?, String?>>;
typedef FrameCubitState = InfiniteListState<FramePacking>;
typedef FrameLinesCubit = NetworkRequestCubit<List<FrameLines>, String>;
typedef FrameLinesCubitState = NetworkRequestState<List<FrameLines>>;
typedef FrameItemsCubit = NetworkRequestCubit<List<FrameItems>, Pair<String,String>>;
typedef FrameItemsCubitState = NetworkRequestState<List<FrameItems>>;
typedef PalletSizeCubit = NetworkRequestCubit<List<PalletSize>, String>;
typedef PalletSizeCubitState = NetworkRequestState<List<PalletSize>>;


@lazySingleton
class FrameBlocProvider {

  const FrameBlocProvider(this.repo);

  final FramePackingRepo repo;

  static FrameBlocProvider get() => $sl.get<FrameBlocProvider>();

  FrameCubit fetchFrames() => FrameCubit(
  
    requestInitial:
        (params, state) => repo.fetchFramePacking(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchFramePacking(state.curLength, params!.first, params.second),
  );
  FrameLinesCubit getFrameLines() => FrameLinesCubit(
    onRequest: (params, state) => repo.fetchFrameLines(params!),
  );
   FrameItemsCubit getFrameItems() => FrameItemsCubit(
    onRequest: (params, state) => repo.fetchItems(params!.first,params.second),
  );
  PalletSizeCubit fetchPalletSize() => PalletSizeCubit(
    onRequest: (params, state) => repo.fetchPalletSize(),
  );

}