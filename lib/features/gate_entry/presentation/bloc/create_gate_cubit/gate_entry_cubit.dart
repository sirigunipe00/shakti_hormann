import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/gate_entry/data/gate_entry.repo.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';

part 'gate_entry_cubit.freezed.dart';

enum GateEntryView { create, edit, completed }

extension ActionType on GateEntryView {
  String toName() {
    return switch (this) {
      GateEntryView.create => 'Create',
      GateEntryView.edit => 'Submit',
      GateEntryView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateGateEntryCubit extends AppBaseCubit<CreateGateEntryState> {
  CreateGateEntryCubit(this.repo) : super(CreateGateEntryState.initial());
  final GateEntryRepo repo;

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
    String? vendorInvoiceDate,
    String? vendorInvoiceNo,
    String? gateEntryDate,
    int? vendorInvoiceQuantity,
    int? invoiceAmount,
    int? receipt,
    String? scanIrn,
    String? remarks,

    File? vehiclePhoto,
    File? vehicleInvoicePhoto,
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
    final vehicleinvoicePhotos =
        vehicleInvoicePhoto.isNull
            ? form.vehicleInvoicePhoto
            : base64Encode(vehicleInvoicePhoto!.readAsBytesSync());
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

      modifiedDate: modifiedDate ?? form.modifiedDate,
      purchaseOrder: purchaseOrder ?? form.purchaseOrder,
      vehicleNo: vehicleNo ?? form.vehicleNo,
      vendorInvoiceDate: vendorInvoiceDate ?? form.vendorInvoiceDate,
      vendorInvoiceNo: vendorInvoiceNo ?? form.vendorInvoiceNo,
      gateEntryDate: gateEntryDate ?? form.gateEntryDate,
      vendorInvoiceQuantity:
          vendorInvoiceQuantity ?? form.vendorInvoiceQuantity,
      invoiceAmount: invoiceAmount ?? form.invoiceAmount,
      receipt: receipt ?? form.receipt,
      scanIrn: scanIrn ?? form.scanIrn,
      remarks: remarks ?? form.remarks,
      vehiclePhoto: vehiclePhotos,
      vehicleInvoicePhoto: vehicleinvoicePhotos,
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
    if (entry is GateEntryForm) {
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
              ? GateEntryView.completed
              : GateEntryView.edit;
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
        GateEntryView.create => GateEntryView.edit,
        GateEntryView.edit ||
        GateEntryView.completed => GateEntryView.completed,
      };

      final status = switch (state.view) {
        GateEntryView.create => 'Draft',
        GateEntryView.edit || GateEntryView.completed => 'Submitted',
      };

      if (state.view == GateEntryView.create) {
        final response = await repo.createGateEntry(state.form);

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
        final response = await repo.submitGateEntry(state.form);

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
                view: GateEntryView.completed,
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
    } else if (form.invoiceAmount.isNull) {
      return optionOf(const Pair('Enter Invoice Amount', 0));
    } 

    return const None();
  }
}

@freezed
class CreateGateEntryState with _$CreateGateEntryState {
  const factory CreateGateEntryState({
    required GateEntryForm form,
    required bool isLoading,
    required bool isSuccess,
    required GateEntryView view,

    String? successMsg,
    Failure? error,
  }) = _CreateGateEntryState;

  factory CreateGateEntryState.initial() {
    final creationDate = DFU.friendlyFormat(DFU.now());

    return CreateGateEntryState(
      form: GateEntryForm(creationDate: creationDate),
      view: GateEntryView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
