
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/storage_allocation/data/storage_repo.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';

typedef StorageCubit = InfiniteListCubit<Storage, Pair<int?, String?>, Pair<int?, String?>>;
typedef StorageCubitState = InfiniteListState<Storage>;

@lazySingleton
class StorageBlocProvider {

  const StorageBlocProvider(this.repo);

  final StorageRepo repo;

  static StorageBlocProvider get() => $sl.get<StorageBlocProvider>();

  StorageCubit fetchStorage() => StorageCubit(
  
    requestInitial:
        (params, state) => repo.fetchStorage(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchStorage(state.curLength, params!.first, params.second),
  );

}