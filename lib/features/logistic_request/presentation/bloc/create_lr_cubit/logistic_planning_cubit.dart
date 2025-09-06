import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/logistic_request/data/logistic_planning_repo.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order.dart';

part 'logistic_planning_cubit.freezed.dart';

enum LogisticPlanningView { create, edit, completed }

extension ActionType on LogisticPlanningView {
  String toName() {
    return switch (this) {
      LogisticPlanningView.create => 'Create',
      LogisticPlanningView.edit => 'Send For\nTransporter Approval',
      LogisticPlanningView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateLogisticCubit extends AppBaseCubit<CreateLogisticState> {
  CreateLogisticCubit(this.repo) : super(CreateLogisticState.initial());
  final LogisticPlanningRepo repo;
  void onValueChanged({
    String? plantName,
    String? name,
    String? creationDate,
    String? owner,
    int? docStatus,
    int? idx,
    String? modifiedBy,
    String? modifiedDate,
    List<SalesOrder>? salesOrder,
    String? vehicleNumber,
    String? transporterName,
    String? preferredVehicleType,
    String? deliveryAddress,
    String? shippingAddress1,
    String? shippingAddress2,
    String? country,
    String? states,
    String? pinCode,
    String? city,
    String? logisticsRequestDate,
    String? rejectReason,
    String? requestedDeliveryDate,
    String? requestedDeliveryTime,
    String? anySpecialInstructions,
    String? transporterConfirmationDate,
    String? driverName,
    String? estimatedArrival,
    String? transporterRemarks,
    String? driverContact,
    String? status,
  }) {
    shouldAskForConfirmation.value = true;
    final form = state.form;

    final newForm = form.copyWith(
      plantName: plantName ?? form.plantName,
      name: name ?? form.name,
      creation: creationDate ?? form.creation,
      owner: owner ?? form.owner,
      docstatus: docStatus ?? form.docstatus,
      idx: idx ?? form.idx,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      modified: modifiedDate ?? form.modified,
      salesOrder: salesOrder ?? form.salesOrder,
      vehicleNumber: vehicleNumber ?? form.vehicleNumber,
      transporterName: transporterName ?? form.transporterName,
      preferredVehicleType: preferredVehicleType ?? form.preferredVehicleType,
      deliveryAddress: deliveryAddress ?? form.deliveryAddress,
      status: status ?? form.status,
      logisticsRequestDate: logisticsRequestDate ?? form.logisticsRequestDate,
      rejectReason: rejectReason ?? form.rejectReason,
      requestedDeliveryDate:
          requestedDeliveryDate ?? form.requestedDeliveryDate,
      requestedDeliveryTime:
          requestedDeliveryTime ?? form.requestedDeliveryTime,
      anySpecialInstructions:
          anySpecialInstructions ?? form.anySpecialInstructions,
      transporterConfirmationDate:
          transporterConfirmationDate ?? form.transporterConfirmationDate,
      driverName: driverName ?? form.driverName,
      estimatedArrival: estimatedArrival ?? form.estimatedArrival,
      transporterRemarks: transporterRemarks ?? form.transporterRemarks,
      driverContact: driverContact ?? form.driverContact,
      shippingAddress1: shippingAddress1 ?? form.shippingAddress1,
      shippingAddress2: shippingAddress2 ?? form.shippingAddress2,
      states : states ?? form.states,
      country : country ?? form.country,
      city : city ?? form.city,
      pincode : pinCode ?? form.pincode,

    );

    emitSafeState(state.copyWith(form: newForm));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is LogisticPlanningForm) {
      final form = state.form;
      final updatedForm = form.copyWith(
        docstatus: entry.docstatus,
        name: entry.name,
        transporterRemarks: entry.transporterRemarks,
        status: entry.status,
        // salesOrder: entry.salesOrder,
        plantName: entry.plantName,
        vehicleNumber: entry.vehicleNumber,
        creation: entry.creation,
        driverContact: entry.driverContact,
        driverName: entry.driverName,
        estimatedArrival: entry.estimatedArrival,
        anySpecialInstructions: entry.anySpecialInstructions,
        preferredVehicleType: entry.preferredVehicleType,
        rejectReason: entry.rejectReason,
        deliveryAddress: entry.deliveryAddress,
        logisticsRequestDate: entry.logisticsRequestDate,
        requestedDeliveryDate: entry.requestedDeliveryDate,
        requestedDeliveryTime: entry.requestedDeliveryTime,
        transporterName: entry.transporterName,
        shippingAddress1: entry.shippingAddress1,
        shippingAddress2: entry.shippingAddress2,
        country: entry.country,
        states: entry.states,
        city: entry.city,
        pincode: entry.pincode,

      );

      final status = entry.docstatus;

      final isSubmitted = StringUtils.equalsIgnoreCase(
        StringUtils.docStatus(status!),
        'Send For Approval',
      );
      final isCancelled = StringUtils.equalsIgnoreCase(
        StringUtils.docStatus(status).trim(),
        'Cancelled',
      );
      final mode =
          (isSubmitted || isCancelled)
              ? LogisticPlanningView.completed
              : LogisticPlanningView.edit;
      emitSafeState(state.copyWith(form: updatedForm, view: mode));
    }
    if (entry == null) return;
  }

  void save() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));
      final nextMode = switch (state.view) {
        LogisticPlanningView.create => LogisticPlanningView.completed,
        LogisticPlanningView.edit ||
        LogisticPlanningView.completed => LogisticPlanningView.completed,
      };

      final status = switch (state.view) {
        LogisticPlanningView.create => 'Draft',
        LogisticPlanningView.edit ||
        LogisticPlanningView.completed => 'Send For Approval',
      };

      if (state.view == LogisticPlanningView.create) {
        final response = await repo.createLogisticPlanning(state.form);

        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            shouldAskForConfirmation.value = false;
            final docstatus = r.second;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: state.form.copyWith(status: status, name: docstatus),
                successMsg: r.first,
                view: nextMode,
              ),
            );
          },
        );
      } else {
        final response = await repo.updateLogisticPlanning(state.form);

        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            shouldAskForConfirmation.value = false;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: state.form.copyWith(docstatus: 1),
                successMsg: r,
                view: LogisticPlanningView.completed,
              ),
            );
          },
        );
      }
    }, _emitError);
  }
 
 void addsaleseorders({List<SalesOrder>? salesorder}) {
    final form = state.form.copyWith(salesOrder: salesorder);

    emitSafeState(state.copyWith(form: form));
  }
  void _emitError(Pair<String, int?> error) {
    final failure = Failure(
      error: error.first,
      title: 'Missing Fields',
      status: error.second,
    );
    emitSafeState(state.copyWith(error: failure, isLoading: false));
  }

  void errorHandled() {
    emitSafeState(
      state.copyWith(
        error: null,
        isLoading: false,
        isSuccess: false,
        successMsg: null,
      ),
    );
  }

  Option<Pair<String, int?>> _validate() {
    final form = state.form;

    if (form.salesOrder == null) {
      return optionOf(const Pair('Select Sales Order No', 0));
    } else if (form.requestedDeliveryDate.isNull || 
             (form.requestedDeliveryDate?.trim().isEmpty ?? true)) {
    return optionOf(const Pair('Missing Request Delivery Date', 0));
  } else if (form.requestedDeliveryTime.isNull || 
             (form.requestedDeliveryTime?.trim().isEmpty ?? true)) {
    return optionOf(const Pair('Missing Request Delivery Time', 0));
  }
    return none();
  }
}

@freezed
class CreateLogisticState with _$CreateLogisticState {
  const factory CreateLogisticState({
    required LogisticPlanningForm form,
    required bool isLoading,
    required bool isSuccess,
    required LogisticPlanningView view,

    String? successMsg,
    Failure? error,
  }) = _CreateLogisticState;

  factory CreateLogisticState.initial() {
    final creationDate = DFU.friendlyFormat(DFU.now());

    return CreateLogisticState(
      form: LogisticPlanningForm(creation: creationDate, name: ''),
      view: LogisticPlanningView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
