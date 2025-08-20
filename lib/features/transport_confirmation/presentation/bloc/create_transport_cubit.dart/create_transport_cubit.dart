import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/transport_confirmation/data/transport_confrimation_repo.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';

part 'create_transport_cubit.freezed.dart';

enum TransportView { create, edit, completed }

extension ActionType on TransportView {
  String toName() {
    return switch (this) {
      TransportView.create => 'Create',
      TransportView.edit => 'Submit',
      TransportView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateTransportCubit extends AppBaseCubit<CreateTransportState> {
  CreateTransportCubit(this.repo) : super(CreateTransportState.initial());
  final TransportConfrimationRepo repo;
  void onValueChanged({
    String? plantName,
    String? name,
    String? creationDate,
    String? owner,
    int? docStatus,
    int? idx,
    String? modifiedBy,
    String? modifiedDate,
    String? salesOrder,
    String? vehicleNumber,
    String? transporterName,
    String? preferredVehicleType,
    String? deliveryAddress,
    String? status,
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
    );

    emitSafeState(state.copyWith(form: newForm));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is TransportConfirmationForm) {
      final form = state.form;
      final updatedForm = form.copyWith(
        docstatus: entry.docstatus,
        name: entry.name,
        transporterRemarks: entry.transporterRemarks,
        status: entry.status,
        salesOrder: entry.salesOrder,
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
      );

      // final formattedStr = DFU.friendlyFormat(parsedDate);
      // final date = DFU.ddMMyyyy(selectedDate);

      final status = entry.docstatus;

      final isSubmitted = StringUtils.equalsIgnoreCase(
        StringUtils.docStatus(status!),
        'Submitted',
      );
      final isCancelled = StringUtils.equalsIgnoreCase(
        StringUtils.docStatus(status).trim(),
        'Cancelled',
      );
      final mode =
          (isSubmitted || isCancelled)
              ? TransportView.completed
              : TransportView.edit;
      emitSafeState(state.copyWith(form: updatedForm, view: mode));
    }
    if (entry == null) return;
  }

  void approve() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

      // Don't set status here
      final formToSend = state.form.copyWith(
        transporterConfirmationDate: DFU.ddMMyyyy(DFU.now()),
      );

      final response = await repo.submitTransport(formToSend);
      return response.fold(
        (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
        (r) {
          shouldAskForConfirmation.value = false;
          emitSafeState(
            state.copyWith(
              isLoading: false,
              isSuccess: true,
              form: formToSend.copyWith(name: r.second),
              successMsg: r.first,
              view: TransportView.completed,
            ),
          );
        },
      );
    }, _emitError);
  }

  void reject() async {
    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    if (state.form.rejectReason.doesNotHaveValue) {
      _emitError(const Pair('Please enter reject reason', 0));
      return;
    }
    final formToSend = state.form;

    final response = await repo.rejectTransport(formToSend);

    response.fold(
      (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
      (r) {
        shouldAskForConfirmation.value = false;
        emitSafeState(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            form: formToSend.copyWith(docstatus: 1),
            successMsg: r.first,
            view: TransportView.completed,
          ),
        );
      },
    );
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
    if (form.plantName.doesNotHaveValue) {
      return optionOf(const Pair('Select Plant Name', 0));
    } else if (form.driverContact.doesNotHaveValue ||
        form.driverContact!.length != 10) {
      return optionOf(
        const Pair('Please re-enter a valid 10-digit driver contact number', 0),
      );
    }

    return const None();
  }
}

@freezed
class CreateTransportState with _$CreateTransportState {
  const factory CreateTransportState({
    required TransportConfirmationForm form,
    required bool isLoading,
    required bool isSuccess,
    required TransportView view,

    String? successMsg,
    Failure? error,
  }) = _CreateTransportState;

  factory CreateTransportState.initial() {
    final creationDate = DFU.friendlyFormat(DFU.now());

    return CreateTransportState(
      form: TransportConfirmationForm(creation: creationDate, name: ''),
      view: TransportView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
