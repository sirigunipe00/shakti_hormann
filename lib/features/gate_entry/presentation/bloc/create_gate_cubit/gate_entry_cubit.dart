import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/gate_entry/data/gate_entry.repo.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order.dart';

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
    List<PurchaseOrder>? purchaseOrder,
    String? vehicleNo,
    String? vendorInvoiceDate,
    String? vendorInvoiceNo,
    String? gateEntryDate,
    int? invoiceQuantity,
    int? invoiceAmount,
    int? receipt,
    String? scanIrn,
    String? remarks,
    String? gateNumber,

    File? vehiclePhoto,
    File? invoicePhoto,
    File? vehicleBackPhoto,
  }) async {
    shouldAskForConfirmation.value = true;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final form = state.form;

    final vehiclePhotos = vehiclePhoto ?? form.vehiclePhotoImg;

    // final vendorInvoicePhotoBase64 = invoicePhoto ?? form.invoicePhotoImg;

    final vehiclebackPhotos = vehicleBackPhoto ?? form.vehicleBackPhotoImg;
    List<File> updatedInvoiceFiles = List.from(form.invoicePhotoImg ?? []);
    if (invoicePhoto != null) {
      updatedInvoiceFiles.add(invoicePhoto);
    }
    final newForm = form.copyWith(
      plantName: plantName ?? form.plantName,
      name: name ?? form.name,
      creationDate: today,
      owner: owner ?? form.owner,
      docStatus: docStatus ?? form.docStatus,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      gateNumber: gateNumber ?? form.gateNumber,
      modifiedDate: modifiedDate ?? form.modifiedDate,
      purchaseOrder: purchaseOrder ?? form.purchaseOrder,
      vehicleNo: vehicleNo ?? form.vehicleNo,
      vendorInvoiceDate: vendorInvoiceDate ?? form.vendorInvoiceDate,
      vendorInvoiceNo: vendorInvoiceNo ?? form.vendorInvoiceNo,
      gateEntryDate: gateEntryDate ?? form.gateEntryDate,
      invoiceQuantity: invoiceQuantity ?? form.invoiceQuantity,
      invoiceAmount: invoiceAmount ?? form.invoiceAmount,
      receipt: receipt ?? form.receipt,
      scanIrn: scanIrn ?? form.scanIrn,
      remarks: remarks ?? form.remarks,
      vehiclePhotoImg: vehiclePhotos,
      invoicePhotoImg: updatedInvoiceFiles,
      vehicleBackPhotoImg: vehiclebackPhotos,
    );

    emitSafeState(state.copyWith(form: newForm,isModified: true));
  }

  void initDetails(Object? entry) async{
    shouldAskForConfirmation.value = false;
    if (entry is GateEntryForm) {
      log('entry.gateEntryDate loggg: ${state.form.purchaseOrder}');

      final parsedDate = DFU.toDateTime(
        entry.creationDate.valueOrEmpty,
        'yyyy-MM-dd',
      );
      final formattedStr = DFU.friendlyFormat(parsedDate);
      final form = state.form;
      final updatedForm = form.copyWith(
        docStatus: entry.docStatus,
        name: entry.name,
        remarks: entry.remarks,
        plantName: entry.plantName,
        // purchaseOrder: state.form.purchaseOrder,
        gateEntryDate: entry.gateEntryDate,
        vendorInvoiceNo: entry.vendorInvoiceNo,
        vendorInvoiceDate: entry.vendorInvoiceDate,
        vehicleNo: entry.vehicleNo,
        vehiclePhoto: entry.vehiclePhoto,
        vehicleBackPhoto: entry.vehicleBackPhoto,
        invoicePhotos: entry.invoicePhotos,
        gateExitDateandTime: entry.gateExitDateandTime,
        invoiceAmount: entry.invoiceAmount,
        invoiceQuantity: entry.invoiceQuantity,
        scanIrn: entry.scanIrn,
        gateNumber: entry.gateNumber,
        creationDate: formattedStr,
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
              ? GateEntryView.completed
              : GateEntryView.edit;
      emitSafeState(state.copyWith(form: updatedForm, view: mode,isModified: false));
      if (entry.name != null) {
      final response = await repo.fetchAttachments(entry.name!);
      response.fold(
        (l) => null, 
        (attachments) {

          final List<String> urls = attachments
              .map((e) => e.fileUrl ?? '')
              .where((url) => url.isNotEmpty)
              .toList();

          emitSafeState(state.copyWith(
            form: state.form.copyWith(invoicePhotos: urls),
          ));
        },
      );
    }
    }
    if (entry == null) return;
  }

  void clearVehiclePhoto() {
    final form = state.form.copyWith(vehiclePhoto: null);
    emitSafeState(state.copyWith(form: form));
  }

 void addInvoicePhoto(File file) {
  final form = state.form;

  final List<File> updatedFiles = List<File>.from(form.invoicePhotoImg ?? [])
  ..add(file);

  emitSafeState(
    state.copyWith(
      form: form.copyWith(invoicePhotoImg: updatedFiles),
      isModified: true,
    ),
  );
}


  void removeLocalInvoicePhoto(int index) {
    final form = state.form;
    final List<File> updatedFiles = List.from(form.invoicePhotoImg ?? []);

    if (index >= 0 && index < updatedFiles.length) {
      updatedFiles.removeAt(index);
    }

    emitSafeState(
      state.copyWith(
        form: form.copyWith(invoicePhotoImg: updatedFiles),
        isModified: true,
      ),
    );
  }


  void removeServerInvoicePhoto(int index) {
    final form = state.form;
    final List<String> updatedUrls = List.from(form.invoicePhotos ?? []);

    if (index >= 0 && index < updatedUrls.length) {
      updatedUrls.removeAt(index);
    }

    emitSafeState(
      state.copyWith(
        form: form.copyWith(invoicePhotos: updatedUrls),
        isModified: true,
      ),
    );
  }
  void addpurchseorders({List<PurchaseOrder>? purchaseorder}) {
    final form = state.form.copyWith(purchaseOrder: purchaseorder);

    emitSafeState(state.copyWith(form: form));
  }

  void clearVehicleBackPhoto() {
    final form = state.form.copyWith(vehicleBackPhoto: null);
    emitSafeState(state.copyWith(form: form));
  }
  void removeInvoicePhoto(int index) {
  final form = state.form;


  List<File> updatedFiles = List.from(form.invoicePhotoImg ?? []);
  List<String> updatedUrls = List.from(form.invoicePhotos ?? []);


  if (index < updatedFiles.length) {
    updatedFiles.removeAt(index);
  } 

  else {
   
    int adjustedIndex = index - updatedFiles.length;
    if (adjustedIndex < updatedUrls.length) {
      updatedUrls.removeAt(adjustedIndex);
    }
  }


  final newForm = form.copyWith(
    invoicePhotoImg: updatedFiles,
    invoicePhotos: updatedUrls,
  );

  emitSafeState(state.copyWith(form: newForm));
}

  void clearInvoicePhoto() {
  final form = state.form.copyWith(
    invoicePhotos: [],     
    invoicePhotoImg: [],   
  );
  emitSafeState(state.copyWith(form: form));
}

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
          (l) => emitSafeState(
            state.copyWith(isLoading: false, error: l, isSuccess: false),
          ),
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
                isModified: false,
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





    if (form.purchaseOrder == null || form.purchaseOrder!.isEmpty) {
      return optionOf(const Pair('Select Purchase Order', 0));
    } else if (form.vendorInvoiceNo.isNull ||
        (form.vendorInvoiceNo?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing VendorInvoice No', 0));
    }  else if (form.vendorInvoiceDate.isNull ||
        (form.vendorInvoiceDate?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing VendorInvoice Date', 0));
    } else if (form.vehicleNo.isNull ||
        (form.vehicleNo?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing Vehicle Number', 0));
    }else if (form.vehiclePhotoImg.isNull &&
        form.vehiclePhoto.doesNotHaveValue) {
      return optionOf(const Pair('Missing VehicleFront Photo', 0));
    } else if (form.vehicleBackPhotoImg.isNull &&
        form.vehicleBackPhoto.doesNotHaveValue) {
      return optionOf(const Pair('Missing VehicleBack Photo', 0));
    } else if ((form.invoicePhotoImg == null || form.invoicePhotoImg!.isEmpty) &&
        (form.invoicePhotos == null || form.invoicePhotos!.isEmpty)) {
      return optionOf(const Pair('Missing VendorInvoice Photo', 0));
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
    @Default(false) bool isModified,

    String? successMsg,
    Failure? error,
  }) = _CreateGateEntryState;

  factory CreateGateEntryState.initial() {
    final creationDate = DFU.friendlyFormat(DFU.now());
    final entryDate = DFU.ddMMyyyy(DFU.now());

    return CreateGateEntryState(
      form: GateEntryForm(creationDate: creationDate, gateEntryDate: entryDate),
      view: GateEntryView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
