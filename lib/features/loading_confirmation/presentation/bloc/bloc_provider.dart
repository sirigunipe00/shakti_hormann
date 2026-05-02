import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/model.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/loading_confirmation/data/loading_cnfm_repo.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/logistic.dart';

typedef LoadingCnfmCubit =InfiniteListCubit<LoadingCnfmForm, Triple<String?, String?,String?>, Triple<String?, String?,String?>>;
typedef LoadingCnfmState = InfiniteListState<LoadingCnfmForm>;

typedef ItemList = NetworkRequestCubit<List<ItemModel>, List<LogisticModel>>;
typedef ItemState = NetworkRequestState<List<ItemModel>>;


typedef GetLoadedList = NetworkRequestCubit<List<ItemModel>, String>;
typedef GetLoadedState= NetworkRequestState<List<ItemModel>>;


typedef Logistic
    = NetworkRequestCubit<List<LogisticModel>, String>;
typedef LogisticState
    = NetworkRequestState<List<LogisticModel>>;

@lazySingleton
class LoadingCnfmBlocProvider {
  const LoadingCnfmBlocProvider(this.repo);

  final LoadingCnfmRepo repo;

  static LoadingCnfmBlocProvider get() => $sl.get<LoadingCnfmBlocProvider>();

  LoadingCnfmCubit fetchLoadingCnfmList() => LoadingCnfmCubit(
    requestInitial:
        (params, state) => repo.fetchLoadingList(0, params!.first, params.second,params.third),
    requestMore:
        (params, state) =>
            repo.fetchLoadingList(state.curLength, params!.first, params.second,params.third),
  );

 ItemList itemList() => ItemList(
  onRequest: (params, state) => repo.fetchItemList(params ?? []),
  // {
  //   // final name = params?['name'] as String? ?? '';
  //   final logistic = params?['logistic'] as List<LogisticModel>? ?? [];
  //   return repo.fetchItemList(logistic);
  // },
);


  GetLoadedList  getItems() => GetLoadedList(
    onRequest: (params, state) => repo.getItems(params ?? ''),
  );

   Logistic getLogisticList() => Logistic(
    onRequest: (params, state) => repo.fetchLogisticList(params ?? ''),
  );
  
}
