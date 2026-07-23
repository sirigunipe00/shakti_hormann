
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/vision_panel/data/vision_panel_repo.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';



typedef VisionPanelCubit = InfiniteListCubit<VisionModel, Pair<int?, String?>, Pair<int?, String?>>;
typedef VisionPanelState = InfiniteListState<VisionModel>;
typedef VisionLinesCubit = NetworkRequestCubit<List<VisionItems>, String>;
typedef VisionLinesState = NetworkRequestState<List<VisionItems>>;
// typedef FrameItemsCubit = NetworkRequestCubit<List<FrameItems>, Pair<String,String>>;
// typedef FrameItemsCubitState = NetworkRequestState<List<FrameItems>>;
// typedef PalletSizeCubit = NetworkRequestCubit<List<PalletSize>, String>;
// typedef PalletSizeCubitState = NetworkRequestState<List<PalletSize>>;


@lazySingleton
class VisionPanelBlocProvider {

  const VisionPanelBlocProvider(this.repo);

  final VisionPanelRepo repo;

  static VisionPanelBlocProvider get() => $sl.get<VisionPanelBlocProvider>();

  VisionPanelCubit fetchVision() => VisionPanelCubit(
  
    requestInitial:
        (params, state) => repo.fetchPanels(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchPanels(state.curLength, params!.first, params.second),
  );
  VisionLinesCubit getVisionLines() => VisionLinesCubit(
    onRequest: (params, state) => repo.fetchVisionLines(params!),
  );
  //  FrameItemsCubit getFrameItems() => FrameItemsCubit(
  //   onRequest: (params, state) => repo.fetchItems(params!.first,params.second),
  // );
  // PalletSizeCubit fetchPalletSize() => PalletSizeCubit(
  //   onRequest: (params, state) => repo.fetchPalletSize(),
  // );

}