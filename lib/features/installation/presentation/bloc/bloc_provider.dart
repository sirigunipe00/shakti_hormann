import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/installation/data/installation_repo.dart';
import 'package:shakti_hormann/features/installation/model/installation_line_items.dart';
import 'package:shakti_hormann/features/installation/model/installation_model.dart';

typedef InstallationCubit = InfiniteListCubit<InstallationModel, Pair<int?, String?>, Pair<int?, String?>>;
typedef InstallationState = InfiniteListState<InstallationModel>;
typedef InstallationLinesCubit = NetworkRequestCubit<List<InstallationLineItems>, String>;
typedef InstallationLinesState = NetworkRequestState<List<InstallationLineItems>>;

@lazySingleton
class InstallationBlocProvider {

  const InstallationBlocProvider(this.repo);

  final InstallationRepo repo;

  static InstallationBlocProvider get() => $sl.get<InstallationBlocProvider>();

  InstallationCubit getInstallation() => InstallationCubit(
  
    requestInitial:
        (params, state) => repo.fetchInstallation(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchInstallation(state.curLength, params!.first, params.second),
  );
  InstallationLinesCubit getInstallationLines() => InstallationLinesCubit(
    onRequest: (params, state) => repo.fetchInstallationLines(params ?? ''),
  );
}