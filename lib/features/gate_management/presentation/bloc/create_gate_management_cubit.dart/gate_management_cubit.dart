
import 'dart:io';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/gate_management/data/gate_management_repo.dart';
import 'package:shakti_hormann/features/gate_management/model/gate_management_form.dart';

part 'gate_management_cubit.freezed.dart';

enum GateManagementView { create, edit, completed }

extension ActionType on GateManagementView {
  String toName() {
    return switch (this) {
      GateManagementView.create => 'Create',
      GateManagementView.edit => 'Submit',
      GateManagementView.completed => 'Submitted',

    };
  }
}

@injectable
class CreateGateManagementCubit extends AppBaseCubit<CreateGateManagementState> {
  CreateGateManagementCubit(this.repo) : super(CreateGateManagementState.initial());
  final GateManagementRepo repo;

  void onValueChanged({
    String? plantName,
    String? name,
    String? owner,
    int? docStatus,
    String? modifiedBy,
    String? vehicleNo,
    List<String>? requestType,
    String? gateEntryTime,
    String? gateEntryDate,
    String? remarks,
    String? vehicleType,
    String? vendorInvoiceNo,
    String? driverName,
    String? driverMobileNo,
    String? vendorName,
    String? securityRemarks,
    String? gateExitdate,
    String? gateExitTime,
    File? vehiclePhoto,
    File? documentPhoto,
    File? backPhoto,
  }) async {
    shouldAskForConfirmation.value = true;
    final form = state.form;

    final vehiclePhotos = vehiclePhoto ?? form.vehiclePhotoImg;
    final backPhotos = backPhoto ?? form.backPhotoImg;
    // final documentPhotos = documentPhoto ?? form.documentPhotoImg;
     List<File> updatedInvoiceFiles = List.from(form.documentPhotoImg ?? []);
    if (documentPhoto != null) {
      updatedInvoiceFiles.add(documentPhoto);
    }

    final newForm = form.copyWith(
      plantName: plantName ?? form.plantName,
      name: name ?? form.name,
      owner: owner ?? form.owner,
      docStatus: docStatus ?? form.docStatus,
      driverMobileNo: driverMobileNo ?? form.driverMobileNo,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      vehicleNo: vehicleNo ?? form.vehicleNo,
      requestType: requestType ?? form.requestType,
      gateEntryTime: gateEntryTime ?? form.gateEntryTime,
      remarks: remarks ?? form.remarks,
      vendorInvoiceNo: vendorInvoiceNo ?? form.vendorInvoiceNo,
      vehicleType: vehicleType ?? form.vehicleType,
      driverName: driverName ?? form.driverName,
      vendorName: vendorName ?? form.vendorName,
      securityRemarks: securityRemarks ?? form.securityRemarks,
      gateExitdate: gateExitdate ?? form.gateExitdate,
      gateExitTime: gateExitTime ?? form.gateExitTime,
      gateeEntrydate: gateEntryDate ?? form.gateeEntrydate,
      vehiclePhotoImg: vehiclePhotos,
      backPhotoImg: backPhotos,
      documentPhotoImg: updatedInvoiceFiles,
    );

    emitSafeState(state.copyWith(form: newForm));
  }

  Future<void> initDetails(Object? entry) async {
    shouldAskForConfirmation.value = false;
    if (entry is GateManagementForm) {
      final form = state.form;
      final updatedForm = form.copyWith(
        docStatus: entry.docStatus,
        name: entry.name,
        remarks: entry.remarks,
        plantName: entry.plantName,
        gateExitdate: entry.gateExitdate,
        vendorInvoiceNo: entry.vendorInvoiceNo,
        gateEntryTime: entry.gateEntryTime,
        vehicleNo: entry.vehicleNo,
        vehiclePhoto: entry.vehiclePhoto,
        backPhoto: entry.backPhoto,
        invoicePhotos: entry.invoicePhotos,
        driverMobileNo: entry.driverMobileNo,
        requestType: entry.requestType,
        vehicleType: entry.vehicleType,
        driverName: entry.driverName,
        vendorName: entry.vendorName,
        securityRemarks: entry.securityRemarks,
        gateeEntrydate: entry.gateeEntrydate,
        gateExitTime: entry.gateExitTime,
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
              ? GateManagementView.completed
              : GateManagementView.edit;
      
     
      emitSafeState(state.copyWith(form: updatedForm, view: mode));
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
    if(entry == null) return;
  }

 void addInvoicePhoto(File file) {
  final form = state.form;

  final List<File> updatedFiles = List<File>.from(form.documentPhotoImg ?? []);
  updatedFiles.add(file);

  emitSafeState(
    state.copyWith(
      form: form.copyWith(documentPhotoImg: updatedFiles),
     
    ),
  );
}


  void removeLocalInvoicePhoto(int index) {
    final form = state.form;
    final List<File> updatedFiles = List.from(form.documentPhotoImg ?? []);

    if (index >= 0 && index < updatedFiles.length) {
      updatedFiles.removeAt(index);
    }

    emitSafeState(
      state.copyWith(
        form: form.copyWith(documentPhotoImg: updatedFiles),
       
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
        
      ),
    );
  }


  void save() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));
      final nextMode = switch (state.view) {
        GateManagementView.create => GateManagementView.edit,
        GateManagementView.edit ||
        GateManagementView.completed => GateManagementView.completed,
      };

      final status = switch (state.view) {
        GateManagementView.create => 'Draft',
        GateManagementView.edit || GateManagementView.completed => 'Submitted',
      };

      if (state.view == GateManagementView.create) {
        final response = await repo.createGateManagement(state.form);

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
                form: state.form.copyWith(status: status,name: docstatus),
                successMsg: r.first,
                view: nextMode,
              ),
            );
          },
        );
      } else {
        final response = await repo.submitGateManagement(state.form);

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
                view: GateManagementView.completed,
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
  final currentView = state.view;


  // final rt = form.requestType?.firstOrNull?.trim().toLowerCase();
  // final isSpecialType = rt == 'amazon' || rt == 'swiggy';
    final selectedTypes =
      form.requestType!
          .map((e) => e.trim().toLowerCase())
          .toList();

  final isSpecialType =
      selectedTypes.contains('amazon') ||
      selectedTypes.contains('swiggy');

  if (form.vehiclePhotoImg.isNull  &&  form.vehiclePhoto.doesNotHaveValue ) {
    return optionOf(const Pair('Missing Vehicle Front Photo', 0));
  } else if (form.backPhotoImg.isNull && form.backPhoto.doesNotHaveValue ) {
    return optionOf(const Pair('Missing Vehicle Back Photo', 0));
  }else if (form.documentPhotoImg.isNull  && form.invoicePhotos!.isEmpty) {
    return optionOf(const Pair('Missing Document Photo', 0));
  }
    final isSubmissionAttempt = currentView == GateManagementView.completed;
    // || currentView == GateManagementView.submitted;


  if ( isSubmissionAttempt && !isSpecialType) {
    if (form.gateExitdate == null || form.gateExitdate!.isEmpty) {
      return optionOf(const Pair('Missing Gate Exit Date', 0));
    }

    if (form.gateExitTime == null || form.gateExitTime!.isEmpty) {
      return optionOf(const Pair('Missing Gate Exit Time', 0));
    }
  }


  return const None();
}

}

@freezed
class CreateGateManagementState with _$CreateGateManagementState {
  const factory CreateGateManagementState({
    required GateManagementForm form,
    required bool isLoading,
    required bool isSuccess,
    required GateManagementView view,
    String? successMsg,
    Failure? error,
  }) = _CreateGateManagementState;

  factory CreateGateManagementState.initial() {
    return const CreateGateManagementState(
      form: GateManagementForm(),
      view: GateManagementView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}