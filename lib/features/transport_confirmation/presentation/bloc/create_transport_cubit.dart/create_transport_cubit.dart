import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/transport_confirmation/data/transport_confrimation_repo.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';

part 'create_transport_cubit.freezed.dart';

enum TransportView { create, edit, completed, reject }

extension ActionType on TransportView {
  String toName() {
    return switch (this) {
      TransportView.create => 'Create',
      TransportView.edit => 'Submit',
      TransportView.reject => 'Reject',
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
      states: states ?? form.states,
      country: country ?? form.country,
      city: city ?? form.city,
      pincode: pinCode ?? form.pincode,
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
        transporterConfirmationDate: entry.transporterConfirmationDate,
        shippingAddress1: entry.shippingAddress1,
        shippingAddress2: entry.shippingAddress2,
        country: entry.country,
        states: entry.states,
        city: entry.city,
        pincode: entry.pincode,
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
    $logger.devLog('approve........');
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

      final formToSend = state.form;

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

  void reject(String reason) async {
    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    // Update form with reject reason
    final updatedForm = state.form.copyWith(rejectReason: reason);

    if (reason.isEmpty) {
      _emitError(const Pair('Please enter reject reason', 0));
      return;
    }

    final response = await repo.rejectTransport(updatedForm);

    response.fold(
      (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
      (r) {
        shouldAskForConfirmation.value = false;
        emitSafeState(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            form: updatedForm.copyWith(docstatus: 1),
            successMsg: r.first,
            view: TransportView.reject,
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

    if (form.driverContact.doesNotHaveValue ||
        form.driverContact!.length != 10) {
      return optionOf(
        const Pair('Please re-enter a valid 10-digit driver contact number', 0),
      );
    } else if (form.driverName.isNull ||
        (form.driverName?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing Driver Name', 0));
    } else if (form.vehicleNumber.isNull ||
        (form.vehicleNumber?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing Vehicle Number', 0));
    } else if (form.estimatedArrival.isNull ||
        (form.estimatedArrival?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing Estimated Arrival Date', 0));
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
      form: TransportConfirmationForm(creation: creationDate),
      view: TransportView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
