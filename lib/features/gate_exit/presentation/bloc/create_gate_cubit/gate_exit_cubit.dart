import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/gate_exit/data/gate_exit_repo.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate%20_exit_form.dart';

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
    plantName ??= plantName == null ? form.plantName : null;
    name ??= name == null ? form.name : null;
    final vehiclePhotos =
        vehiclePhoto.isNull
            ? form.vehiclePhoto
            : base64Encode(vehiclePhoto!.readAsBytesSync());

    final vehiclebackPhotos =
        vehicleBackPhoto.isNull
            ? form.vehicleBackPhoto
            : base64Encode(vehicleBackPhoto!.readAsBytesSync());

    final newForm = form.copyWith(
      plantName: plantName,
      name: name,
      creationDate: today,
      owner: owner ?? form.owner,
      docStatus: docStatus ?? form.docStatus,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      salesInvoice: salesInvoiceNo ?? form.salesInvoice,

      modifiedDate: modifiedDate ?? form.modifiedDate,
      vehicleNo: vehicleNo ?? form.vehicleNo,

      gateEntryDate: gateEntryDate ?? form.gateEntryDate,

      remarks: remarks ?? form.remarks,
      vehiclePhoto: vehiclePhotos,

      vehicleBackPhoto: vehiclebackPhotos,
    );
    emitSafeState(state.copyWith(form: newForm));
  }

  // void addInvUrls(List<String> urls) {
  //   final form = state.form.copyWith(addInvs: urls);
  //   emitSafeState(state.copyWith(form: form));
  // }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is GateExitForm) {
      final parsedDate = DFU.toDateTime(
        entry.creationDate.valueOrEmpty,
        'yyyy-MM-dd',
      );
      final formattedStr = DFU.friendlyFormat(parsedDate);

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
          form: entry.copyWith(creationDate: formattedStr),
          view: mode,
        ),
      );
    }
    if (entry == null) return;
  }

  // void removeFile(int indx) {
  //   final invs = [...state.form.invoiceImg];
  //   invs.removeAt(indx);
  //   final form = state.form.copyWith(invoiceImg: invs);
  //   emitSafeState(state.copyWith(form: form));
  // }

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
    // final isMand = form.entryType == 'Gatepass Returnable' && form.expectedReturnDate.doesNotHaveValue;
    if (form.plantName.doesNotHaveValue) {
      return optionOf(const Pair('Select Plant Name', 0));
    } else if (form.vehicleNo.doesNotHaveValue) {
      return optionOf(const Pair('Enter Vehicle Number', 0));
    } else if (form.gateEntryDate.isNull) {
      return optionOf(const Pair('Enter Gate Exit Date', 0));
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
