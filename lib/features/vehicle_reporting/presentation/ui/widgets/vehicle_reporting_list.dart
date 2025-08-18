import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/vehicle_reporting_filtercubit.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/ui/widgets/vehicle_request_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class VehicleReportingList extends StatelessWidget {
  const VehicleReportingList({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageView2<VehicleReportingFilterCubit>(
      mode: PageMode2.vehicleReporting,

      backgroundColor: AppColors.white,
      onNew: () => AppRoute.newVehiclereporting.push(context),

      scaffoldBg: '',
      
      child: BlocListener<VehicleReportingFilterCubit, PageViewFilters>(
        listener: (_, state) => _fetchInital(context),
        child: InfiniteListViewWidget<VehicleReportingCubit, VehicleReportingForm>(
          childBuilder:
              (context, entry) => VehicleRequestWidget(
                vehicleReporting: entry,
                onTap: () {
                  
                  AppRoute.newVehiclereporting.push<bool?>(context, extra: entry);
                },
              ),
          fetchInitial: () => _fetchInital(context),
          fetchMore: () => fetchMore(context),
          emptyListText: 'No Vehicle Reportings Found.',
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<VehicleReportingFilterCubit>().state;
    context.cubit<VehicleReportingCubit>().fetchInitial(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<VehicleReportingFilterCubit>().state;

    context.cubit<VehicleReportingCubit>().fetchMore(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }
}
