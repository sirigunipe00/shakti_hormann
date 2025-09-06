import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/vehicle_reporting/data/vehicle_reporting_repo.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';

part 'create_vehicle_cubit.freezed.dart';

enum VehicleView { create, edit, completed, reject }

extension ActionType on VehicleView {
  String toName() {
    return switch (this) {
      VehicleView.create => 'Create',
      VehicleView.edit => 'Submit',
      VehicleView.reject => 'Reject',
      VehicleView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateVehicleCubit extends AppBaseCubit<CreateVehicleState> {
  CreateVehicleCubit(this.repo) : super(CreateVehicleState.initial());
  final VehicleReportingRepo repo;

  void onValueChanged({
    String? plantName,
    String? name,
    String? creationDate,
    String? owner,
    int? docStatus,
    int? idx,
    String? modifiedBy,
    String? modifiedDate,
    String? amendedFrom,
    String? vehicleReportingEntryVreDate,
    String? transporterName,
    String? arrivalDateAndTime,
    File? driverIdPhoto,
    String? loadedByUser,
    String? status,
    String? linkedTransporterConfirmation,
    String? vehicleNo,
    String? driverContact,
    String? remarks,
    String? rejectReason,
  }) {
    shouldAskForConfirmation.value = true;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final form = state.form;

    name ??= name == null ? form.name : null;
    final driverIdPhotos = driverIdPhoto ?? form.driverIdPhotoImg;


    final newForm = form.copyWith(
      plantName: plantName ?? form.plantName,
      name: name,
      creation: today,
      owner: owner ?? form.owner,
      docstatus: docStatus ?? form.docstatus,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      modified: modifiedDate ?? form.modified,
      vehicleReportingEntryVreDate:
          vehicleReportingEntryVreDate ?? form.vehicleReportingEntryVreDate,
      transporterName: transporterName ?? form.transporterName,
      arrivalDateAndTime: arrivalDateAndTime ?? form.arrivalDateAndTime,
      loadedByUser: loadedByUser ?? form.loadedByUser,
      status: status ?? form.status,
      linkedTransporterConfirmation:
          linkedTransporterConfirmation ?? form.linkedTransporterConfirmation,
      driverContact: driverContact ?? form.driverContact,
      vehicleNumber: vehicleNo ?? form.vehicleNumber,
      remarks: remarks ?? form.remarks,
      driverIdPhotoImg: driverIdPhotos,
      rejectReason: rejectReason ?? form.rejectReason,
    );
    emitSafeState(state.copyWith(form: newForm));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is VehicleReportingForm) {
      final status = entry.docstatus;

      final isSubmitted = StringUtils.equalsIgnoreCase(
        StringUtils.docStatus(status!),
        'Submitted',
      );
      final isCancelled = StringUtils.equalsIgnoreCase(
        StringUtils.docStatus(status).trim(),
        'Cancelled',
      );
      final form = state.form;
      final updatedForm = form.copyWith(
        docstatus: entry.docstatus,
        name: entry.name,
        remarks: entry.remarks,
        status: entry.status,
        plantName: entry.plantName,
        loadedByUser: entry.loadedByUser,
        vehicleNumber: entry.vehicleNumber,
        arrivalDateAndTime: entry.arrivalDateAndTime,
        driverContact: entry.driverContact,
        driverIdPhoto: entry.driverIdPhoto,
        vehicleReportingEntryVreDate: entry.vehicleReportingEntryVreDate,
        linkedTransporterConfirmation: entry.linkedTransporterConfirmation,
        transporterName: entry.transporterName,
        rejectReason:  entry.rejectReason,
      );
      final mode =
          (isSubmitted || isCancelled)
              ? VehicleView.completed
              : VehicleView.edit;
      emitSafeState(state.copyWith(form: updatedForm, view: mode));
    }
    if (entry == null) return;
  }

  void clearDriverIdPhoto() {
    final form = state.form.copyWith(driverIdPhoto: null);
    emitSafeState(state.copyWith(form: form));
  }

  void save() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));
      final nextMode = switch (state.view) {
        VehicleView.create => VehicleView.edit,
        VehicleView.edit => VehicleView.completed,
        VehicleView.completed => VehicleView.completed,
        VehicleView.reject => VehicleView.reject, 
      };

      final status = switch (state.view) {
        VehicleView.create => 'Draft',
        VehicleView.edit => 'Submitted',
        VehicleView.completed => 'Submitted',
        VehicleView.reject => 'Rejected',
      };

      if (state.view == VehicleView.create) {
        final response = await repo.createVehicleReporting(state.form);

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
      }
      // else {
      //   final response = await repo.submitGateEntry(state.form);

      //   return response.fold(
      //     (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
      //     (r) {
      //       shouldAskForConfirmation.value = false;
      //       emitSafeState(
      //         state.copyWith(
      //           isLoading: false,
      //           isSuccess: true,
      //           form: state.form.copyWith(docStatus: 1),
      //           successMsg: r.first,
      //           view: VehicleView.completed,
      //         ),
      //       );
      //     },
      //   );
      // }
    }, _emitError);
  }

  void approve() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isSubmitting: true, isSuccess: false));

      final formToSend = state.form;

      final response = await repo.submitVehicleReporting(formToSend);
      return response.fold(
        (l) => emitSafeState(state.copyWith(isSubmitting: false, error: l)),
        (r) {
          shouldAskForConfirmation.value = false;
          emitSafeState(
            state.copyWith(
              isSubmitting: false,
              isSuccess: true,
              form: formToSend.copyWith(name: r.second),
              successMsg: r.first,
              view: VehicleView.completed,
            ),
          );
        },
      );
    }, _emitError);
  }

  void reject(String reason) async {
    emitSafeState(state.copyWith(isRejecting: true, isSuccess: false));

    // Update form with reject reason
    final updatedForm = state.form.copyWith(rejectReason: reason);

    if (reason.isEmpty) {
      _emitError(const Pair('Please enter reject reason', 0));
      return;
    }

    final response = await repo.rejectVehicleReporting(updatedForm);

    response.fold(
      (l) => emitSafeState(state.copyWith(isRejecting: false, error: l)),
      (r) {
        shouldAskForConfirmation.value = false;
        emitSafeState(
          state.copyWith(
            isRejecting: false,
            isSuccess: true,
            form: updatedForm.copyWith(docstatus: 1),
            successMsg: r.first,
            view: VehicleView.reject,
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
    if (form.linkedTransporterConfirmation.doesNotHaveValue) {
      return optionOf(const Pair('Select Logistic Request No', 0));
    } else if (form.driverIdPhoto.doesNotHaveValue &&
        form.driverIdPhotoImg.isNull) {
      return optionOf(const Pair('Capture DriverID Photo.', 0));
    }

    return const None();
  }
}

@freezed
class CreateVehicleState with _$CreateVehicleState {
  const factory CreateVehicleState({
    required VehicleReportingForm form,
    required bool isLoading,
    required bool isSuccess,
    required VehicleView view,
    @Default(false) bool isSubmitting,
    @Default(false) bool isRejecting,
    String? successMsg,
    Failure? error,
  }) = _CreateVehicleState;

  factory CreateVehicleState.initial() {
    final creationDate = DFU.friendlyFormat(DFU.now());

    return CreateVehicleState(
      form: VehicleReportingForm(creation: creationDate),
      view: VehicleView.create,
      isLoading: false,
      isSuccess: false,
      isRejecting: false,
      isSubmitting: false
    );
  }
}
