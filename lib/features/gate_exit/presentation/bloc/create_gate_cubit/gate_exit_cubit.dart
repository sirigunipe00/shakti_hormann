import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/gate_exit/data/gate_exit_repo.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate_exit_form.dart';

part 'gate_exit_cubit.freezed.dart';

enum GateExitView { create, edit, completed }

extension ActionType on GateExitView {
  String toName() {
    return switch (this) {
      GateExitView.create => 'Create',
      GateExitView.edit => 'Submit',
      GateExitView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateGateExitCubit extends AppBaseCubit<CreateGateExitState> {
  CreateGateExitCubit(this.repo) : super(CreateGateExitState.initial());
  final GateExitRepo repo;

  void onValueChanged({
    String? plantName,
    String? name,
    String? creationDate,
    String? owner,
    int? docStatus,
    String? modifiedBy,
    String? modifiedDate,
    String? purchaseOrder,
    String? vehicleNo,
    String? salesInvoiceNo,
    String? gateEntryDate,
    String? scanIrn,
    String? remarks,
    File? vehiclePhoto,
    File? vehicleBackPhoto,
  }) {
    shouldAskForConfirmation.value = true;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final form = state.form;
     final vehPhoto = vehiclePhoto.isNull
        ? form.vehiclePhoto
        : base64Encode(vehiclePhoto!.readAsBytesSync());
    final vehBackPhoto = vehicleBackPhoto.isNull
        ? form.vehicleBackPhoto
        : base64Encode(vehicleBackPhoto!.readAsBytesSync());

    final newForm = form.copyWith(
      plantName: plantName ?? form.plantName,
      name: name ?? form.name,
      creationDate: today,
      owner: owner ?? form.owner,
      docStatus: docStatus ?? form.docStatus,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      salesInvoice: salesInvoiceNo ?? form.salesInvoice,

      modifiedDate: modifiedDate ?? form.modifiedDate,
      vehicleNo: vehicleNo ?? form.vehicleNo,

      gateEntryDate: gateEntryDate ?? form.gateEntryDate,

      remarks: remarks ?? form.remarks,
      vehiclePhoto: vehPhoto,

      vehicleBackPhoto: vehBackPhoto,
    );
    emitSafeState(state.copyWith(form: newForm));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is GateExitForm) {


      
      DFU.toDateTime(
        entry.creationDate.valueOrEmpty,
        'yyyy-MM-dd',
      );
      DFU.toDateTime(
        entry.gateEntryDate.valueOrEmpty,
        'dd-MM-yyyy',
      );
        final form = state.form;
    final updatedForm = form.copyWith(
      docStatus: entry.docStatus,
      name: entry.name,
      remarks: entry.remarks,
      plantName: entry.plantName,
      gateEntryDate: entry.gateEntryDate,
      
      vehicleNo: entry.vehicleNo,
      vehiclePhoto: entry.vehiclePhoto,
      vehicleBackPhoto: entry.vehicleBackPhoto,
    );

      final status = entry.docStatus;

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
              ? GateExitView.completed
              : GateExitView.edit;
      emitSafeState(
        state.copyWith(
          form: updatedForm,

          view: mode,
        ),
      );
    }
    if (entry == null) return;
  }

  void clearVehiclePhoto() {
    final form = state.form.copyWith(vehiclePhoto: null);
    emitSafeState(state.copyWith(form: form));
  }
   void clearVehicleBackPhoto() {
    final form = state.form.copyWith(vehicleBackPhoto: null);
    emitSafeState(state.copyWith(form: form));
  }

  

  void save() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));
      final nextMode = switch (state.view) {
        GateExitView.create => GateExitView.edit,
        GateExitView.edit || GateExitView.completed => GateExitView.completed,
      };

      final status = switch (state.view) {
        GateExitView.create => 'Draft',
        GateExitView.edit || GateExitView.completed => 'Submitted',
      };

      if (state.view == GateExitView.create) {
        final response = await repo.createGateExit(state.form);

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
        final response = await repo.submitGateExit(state.form);

        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            shouldAskForConfirmation.value = false;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: state.form.copyWith(docStatus: 1),
                successMsg: r.first,
                view: GateExitView.completed,
              ),
            );
          },
        );
      }
    }, _emitError);
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
    }
    if (form.vehicleNo == null || form.vehicleNo!.trim().isEmpty) {
      return optionOf(const Pair('Enter Vehicle Number', 0));
    }else if (form.vehiclePhoto.doesNotHaveValue) {
      return optionOf(const Pair('Capture Vehicle Front Photo.',0));
    } else if (form.vehicleBackPhoto.doesNotHaveValue) {
      return optionOf(const Pair('Capture Vehicle Back Photo.',0));
    } 

    return const None();
  }
}

@freezed
class CreateGateExitState with _$CreateGateExitState {
  const factory CreateGateExitState({
    required GateExitForm form,
    required bool isLoading,
    required bool isSuccess,
    required GateExitView view,

    String? successMsg,
    Failure? error,
  }) = _CreateGateExitState;

  factory CreateGateExitState.initial() {
    final creationDate = DFU.friendlyFormat(DFU.now());

    return CreateGateExitState(
      form: GateExitForm(creationDate: creationDate),
      view: GateExitView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
