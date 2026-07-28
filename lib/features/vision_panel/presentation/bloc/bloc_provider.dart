
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/vision_panel/data/vision_panel_repo.dart';
import 'package:shakti_hormann/features/vision_panel/model/product_type.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_panel_entry_lines.dart';




typedef VisionPanelCubit = InfiniteListCubit<VisionModel, Pair<int?, String?>, Pair<int?, String?>>;
typedef VisionPanelState = InfiniteListState<VisionModel>;
typedef VisionLinesCubit = NetworkRequestCubit<List<VisionItems>, String>;
typedef VisionLinesState = NetworkRequestState<List<VisionItems>>;
typedef ProductCubit = NetworkRequestCubit<List<ProductType>, Pair<String,String>>;
typedef ProductState = NetworkRequestState<List<ProductType>>;
typedef VisionEntryLines = NetworkRequestCubit<List<VisionPanelEntryLines>, String>;
typedef VisionItemEntryState = NetworkRequestState<List<VisionPanelEntryLines>>;


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
   ProductCubit getProduct() => ProductCubit(
    onRequest: (params, state) => repo.fetchProduct(),
  );
  VisionEntryLines getentryLines() => VisionEntryLines(
    onRequest: (params, state) => repo.fetchVisionEntryLines(params!),
  );

}