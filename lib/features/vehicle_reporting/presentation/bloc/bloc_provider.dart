import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/data/vehicle_reporting_repo.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';

typedef VehicleReportingCubit =
    InfiniteListCubit<VehicleReportingForm, Pair<String?, String?>, Pair<String?, String?>>;
typedef VehicleReportingtState = InfiniteListState<VehicleReportingForm>;

typedef LogisticRequest
    = NetworkRequestCubit<List<TransportConfirmationForm>, String>;
typedef LogisticRequestState
    = NetworkRequestState<List<TransportConfirmationForm>>;


@lazySingleton
class VehicleBlocProvider {
  const VehicleBlocProvider(this.repo);

  final VehicleReportingRepo repo;

  static VehicleBlocProvider get() => $sl.get<VehicleBlocProvider>();

  VehicleReportingCubit fetchVehicle() => VehicleReportingCubit(
    requestInitial:
        (params, state) => repo.fetchVehicles(0, params!.first, params.second),
    requestMore:
        (params, state) =>
            repo.fetchVehicles(state.curLength, params!.first, params.second),
  );
    LogisticRequest logisticList() => LogisticRequest(
    onRequest: (params, state) => repo.fetchLogistics(params ?? ''),
  );
}