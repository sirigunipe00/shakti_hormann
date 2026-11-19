import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/create_vr_cubit/create_vehicle_cubit.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/ui/create/vehicle_reporting_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/form_page_loading_stack.dart';
import 'package:shakti_hormann/widgets/inputs/compact_search_select.dart';
import 'package:shakti_hormann/widgets/inputs/rejectreasondailog.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewVehicleReporting extends StatefulWidget {
  const NewVehicleReporting({super.key});

  @override
  State<NewVehicleReporting> createState() => _NewVehicleReportingState();
}

class _NewVehicleReportingState extends State<NewVehicleReporting> {
  TransportConfirmationForm? transporterForm;

  @override
  Widget build(BuildContext context) {
    final vehicleState = context.read<CreateVehicleCubit>().state;



    final newform = vehicleState.form;
    final status = newform.status;
    final name = newform.name;

    final isNew = vehicleState.view == VehicleView.create;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Vehicle Reporting',
                actionButton:
                    BlocBuilder<CreateVehicleCubit, CreateVehicleState>(
                      builder: (context, state) {
                        return AppButton(
                          label: state.view.toName(),
                          isLoading: state.isLoading,
                          bgColor:
                              state.view == VehicleView.create
                                  ? const Color.fromARGB(255, 250, 193, 47)
                                  : AppColors.green,
                          textStyle: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          borderColor: Colors.grey,
                          onPressed: context.cubit<CreateVehicleCubit>().save,
                        );
                      },
                    ),
                dropdown: BlocBuilder<LogisticRequest, LogisticRequestState>(
                  builder: (_, state) {
                    return _buildLogisticSelect(
                      context: context,
                      state: state,
                      linkedName: newform.linkedTransporterConfirmation,
                      locked: newform.status == 'Reported' ||
                          newform.status == 'Rejected',
                      labelColor: Colors.white,
                    );
                  },
                ),
                showScanner: false,
              )
              : PreferredSize(
                // Title row + Accept/Reject row + logistic dropdown.
                preferredSize: const Size.fromHeight(236),
                child: BlocBuilder<CreateVehicleCubit, CreateVehicleState>(
                  builder: (context, state) {
                    return TitleStatusAppBar(
                      title: name ?? '',
                      status: status ?? '',
                      textColor: Colors.white,
                      pageMode: PageMode2.vehicleReporting,
                      showRejectButton: true,
                      isSubmitting: state.isSubmitting,
                      isRejecting: state.isRejecting,
                      onSubmit: () => _confirmAcceptVehicle(context),
                      onReject: () {
                        showRejectDialogs(context);
                      },
                      dropdown: BlocBuilder<CreateVehicleCubit, CreateVehicleState>(
                        builder: (context, vehicleCubitState) {
                          final linked = vehicleCubitState
                                  .form.linkedTransporterConfirmation
                                  ?.trim() ??
                              '';
                          final isLocked = status == 'Reported' ||
                              status == 'Rejected';

                          if (linked.isNotEmpty && isLocked) {
                            return _LinkedLogisticReadonlyField(
                              value: linked,
                              locked: true,
                            );
                          }

                          return BlocBuilder<
                            LogisticRequest,
                            LogisticRequestState
                          >(
                            builder: (_, state) {
                              return _buildLogisticSelect(
                                context: context,
                                state: state,
                                linkedName: linked,
                                locked: isLocked,
                                labelColor: Colors.white,
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                // as PreferredSizeWidget,
              ),

      body: BlocBuilder<CreateVehicleCubit, CreateVehicleState>(
        builder: (context, overlayState) {
          final isBusy =
              overlayState.isLoading ||
              overlayState.isSubmitting ||
              overlayState.isRejecting;
          return FormPageLoadingStack(
            isLoading: isBusy,
            message:
                overlayState.isRejecting
                    ? 'Processing rejection...'
                    : overlayState.isSubmitting
                        ? 'Submitting document...'
                        : 'Saving document...',
            statusLabel: 'Processing...',
            child: BlocListener<CreateVehicleCubit, CreateVehicleState>(
              listener: (_, state) async {
                if (state.isSuccess && state.successMsg!.isNotNull) {
                  // create → view becomes edit; approve/submit → completed;
                  // reject → reject
                  final isSubmitSuccess =
                      state.view == VehicleView.completed;
                  if (state.view == VehicleView.reject) {
                    AppDialog.showErrorDialog(
                      context,
                      title: 'Vehicle Rejected',
                      content: state.successMsg.valueOrEmpty,
                      onTapDismiss: context.exit,
                    ).then((_) {
                      if (!context.mounted) return;
                      context.cubit<CreateVehicleCubit>().errorHandled();
                      // Create/reject: leave without confirmation (cubit
                      // already cleared the flag, but form remount/
                      // onValueChanged can set it true again before this pop).
                      if (!isSubmitSuccess) {
                        shouldAskForConfirmation.value = false;
                      }
                      Navigator.pop(context, true);
                    });
                  } else {
                    AppDialog.showSuccessDialog(
                      context,
                      title: 'Success',
                      content: state.successMsg.valueOrEmpty,
                      onTapDismiss: context.exit,
                    ).then((_) {
                      if (!context.mounted) return;
                      context.cubit<CreateVehicleCubit>().errorHandled();
                      if (!isSubmitSuccess) {
                        shouldAskForConfirmation.value = false;
                      }
                      Navigator.pop(context, true);
                      setState(() {});
                    });
                  }
                }

                if (state.error.isNotNull) {
                  await AppDialog.showErrorDialog(
                    context,
                    title: state.error!.title,
                    content: state.error!.error,
                    onTapDismiss: context.exit,
                  );
                  if (!context.mounted) return;
                  context.cubit<CreateVehicleCubit>().errorHandled();
                }
              },
              child: VehicleReportingFormWidget(key: ValueKey(status)),
            ),
          );
        },
      ),
    );
  }

  /// Keep the already-linked TC visible even when fetchLogistics filters it out
  /// (e.g. vehicle_reported_loaded=1 or outside yesterday/today window).
  List<TransportConfirmationForm> _withLinkedLogistic(
    List<TransportConfirmationForm> source,
    String? linkedName,
  ) {
    final names = List<TransportConfirmationForm>.from(source);
    final linked = linkedName?.trim() ?? '';
    if (linked.isEmpty) return names;
    final exists = names.any((e) => e.name == linked);
    if (!exists) {
      names.insert(0, TransportConfirmationForm(name: linked));
    }
    return names;
  }

  TransportConfirmationForm? _linkedOrNull(
    List<TransportConfirmationForm> names,
    String? linkedName,
  ) {
    final linked = linkedName?.trim() ?? '';
    if (linked.isEmpty || names.isEmpty) return null;
    return names.firstWhere(
      (item) => item.name == linked,
      orElse: () => TransportConfirmationForm(name: linked),
    );
  }

  Widget _buildLogisticSelect({
    required BuildContext context,
    required LogisticRequestState state,
    required String? linkedName,
    required bool locked,
    required Color labelColor,
  }) {
    final allData = state.maybeWhen(
      orElse: () => <TransportConfirmationForm>[],
      success: (data) => data,
    );
    final names = _withLinkedLogistic(allData, linkedName);
    final selected = transporterForm ?? _linkedOrNull(names, linkedName);

    return CompactSearchSelect<TransportConfirmationForm>(
      key: ValueKey('vre_lr_${selected?.name ?? 'new'}_${names.length}'),
      label: 'Logistic Request No',
      hint: 'Search Logistic No',
      labelColor: labelColor,
      isRequired: true,
      locked: locked,
      isLoading: state.isLoading && names.isEmpty,
      leadingIcon: Icons.receipt_long_outlined,
      maxMenuHeight: 240,
      options: names,
      value: selected,
      labelOf: (e) => e.name ?? '',
      subtitleOf: (e) {
        final parts = <String>[
          if (e.transporterName?.isNotEmpty == true) e.transporterName!,
          if (e.transporterName2?.isNotEmpty == true) e.transporterName2!,
          if (e.vehicleNumber?.isNotEmpty == true) 'Veh: ${e.vehicleNumber!}',
        ];
        return parts.isEmpty ? null : parts.join(' · ');
      },
      matchesQuery: (item, query) {
        final haystack = [
          item.name,
          item.transporterName,
          item.transporterName2,
          item.vehicleNumber,
        ].whereType<String>().join(' ').toLowerCase();
        return haystack.contains(query);
      },
      onChanged: (picked) => _onLogisticSelected(context, picked),
    );
  }

  void _onLogisticSelected(
    BuildContext context,
    TransportConfirmationForm selected,
  ) {
    setState(() => transporterForm = selected);
    final combinedTransporterName = [
      selected.transporterName,
      selected.transporterName2,
    ].where((e) => e != null && e.isNotEmpty).join(' - ');
    context.cubit<CreateVehicleCubit>().onValueChanged(
          plantName: selected.plantName,
          transporterName: combinedTransporterName,
          vehicleNo: selected.vehicleNumber,
          linkedTransporterConfirmation: selected.name,
          driverContact: selected.driverContact,
          arrivalDate: selected.estimatedArrivalDate,
          arrivalTime: selected.estimatedArrivalTime,
          preferredVehicle: selected.preferredVehicleType,
        );
  }

  Future<void> _confirmAcceptVehicle(BuildContext context) async {
    final cubit = context.read<CreateVehicleCubit>();
    if (cubit.state.isSubmitting) return;
    final form = cubit.state.form;

    await AppDialog.askForConfirmation(
      context,
      title: 'Accept Vehicle?',
      content:
          'Confirm that the vehicle has reported correctly. This will mark the vehicle reporting entry as accepted.',
      buttonText: 'Keep Editing',
      confirmBtnText: 'Accept Vehicle',
      icon: Icons.verified_rounded,
      iconBackground: const Color(0xFFE8F5E9),
      iconColor: const Color(0xFF16A34A),
      confirmIcon: Icons.check_circle_rounded,
      confirmColor: const Color(0xFF16A34A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((form.name ?? '').isNotEmpty)
            Text(
              form.name!,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: 'Urbanist',
                color: Color(0xFF0E1446),
              ),
            ),
          if ((form.vehicleNumber ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Vehicle: ${form.vehicleNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Urbanist',
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ],
      ),
      onTapDismiss: () => Navigator.of(context).pop(false),
      onTapConfirm: () {
        Navigator.of(context).pop(true);
        cubit.approve();
      },
    );
  }
}

/// Shows ERP `linked_transporter_confirmation` without depending on the
/// fresh Transport Confirmation picker list.
class _LinkedLogisticReadonlyField extends StatelessWidget {
  const _LinkedLogisticReadonlyField({
    required this.value,
    required this.locked,
  });

  final String value;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Logistic Request No',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFamily: 'Urbanist',
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: locked
                ? Colors.white.withValues(alpha: 0.14)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: locked ? Colors.white : AppColors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
              if (locked)
                Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
