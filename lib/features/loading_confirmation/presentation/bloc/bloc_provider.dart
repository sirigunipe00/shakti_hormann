import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/loading_confirmation/data/loading_cnfm_repo.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';

typedef LoadingCnfmCubit =
    InfiniteListCubit<LoadingCnfmForm, Pair<String?, String?>, Pair<String?, String?>>;
typedef LoadingCnfmState = InfiniteListState<LoadingCnfmForm>;

typedef ItemList
    = NetworkRequestCubit<List<ItemModel>, String>;
typedef ItemState
    = NetworkRequestState<List<ItemModel>>;

@lazySingleton
class LoadingCnfmBlocProvider {
  const LoadingCnfmBlocProvider(this.repo);

  final LoadingCnfmRepo repo;

  static LoadingCnfmBlocProvider get() => $sl.get<LoadingCnfmBlocProvider>();

  LoadingCnfmCubit fetchLoadingCnfmList() => LoadingCnfmCubit(
    requestInitial:
        (params, state) => repo.fetchLoadingList(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchLoadingList(state.curLength, params!.first, params.second),
  );

  ItemList itemList() => ItemList(
    onRequest: (params, state) => repo.fetchItemList(params ?? ''),
  );
}
