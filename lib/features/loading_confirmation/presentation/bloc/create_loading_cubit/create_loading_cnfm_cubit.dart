import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/loading_confirmation/data/loading_cnfm_repo.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';


part 'create_loading_cnfm_cubit.freezed.dart';

enum LoadingView { create, edit, completed }

extension ActionType on LoadingView {
  String toName() {
    return switch (this) {
      LoadingView.create => 'Create',
      LoadingView.edit => 'Submit',
      LoadingView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateLoadingCnfmCubit extends AppBaseCubit<CreateLaodingCnfmState> {
  CreateLoadingCnfmCubit(this.repo) : super(CreateLaodingCnfmState.initial());
  final LoadingCnfmRepo repo;

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
    // File? driverIdPhoto,
    String? loadedByUser,
    String? status,
    String? linkedTransporterConfirmation,
    String? vehicleNo,
    String? driverContact,
    // String? remarks,
    // String? itemName,
    // String? salesUom,
    // String? itemCode,
    // String? images,
    //  String? name,
    // int? quantityLoaded,
    
  }) {
    shouldAskForConfirmation.value = true;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final form = state.form;

    // name ??= name == null ? form.name : null;
    // final driverID =
    //     driverIdPhoto.isNull
    //         ? form.driverIdPhoto
    //         : base64Encode(driverIdPhoto!.readAsBytesSync());

    final newForm = form.copyWith(
      // plantName: plantName ?? form.plantName,
      // name: name ?? form.name,
      // itemCode : itemCode ?? form.itemCode,
      // itemName : itemName ?? form.itemName,
      // salesUom :salesUom ?? form.salesUom,
      //  sampleQuantity: quantityLoaded ?? form.sampleQuantity

      creation: today,
      owner: owner ?? form.owner,
      docstatus: docStatus ?? form.docstatus,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      modified: modifiedDate ?? form.modified,
      // vehicleReportingEntryVreDate:
      //     vehicleReportingEntryVreDate ?? form.vehicleReportingEntryVreDate,
      // transporterName: transporterName ?? form.transporterName,
      // arrivalDateAndTime: arrivalDateAndTime ?? form.arrivalDateAndTime,
      // loadedByUser: loadedByUser ?? form.loadedByUser,
      // status: status ?? form.status,
      // linkedTransporterConfirmation:
      //     linkedTransporterConfirmation ?? form.linkedTransporterConfirmation,
      // driverContact: driverContact ?? form.driverContact,
      // vehicleNumber: vehicleNo ?? form.vehicleNumber,
      // remarks: remarks ?? form.remarks,
      // driverIdPhoto: driverID,
    
      
    );
    emitSafeState(state.copyWith(form: newForm));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is ItemModel) {
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
        
        // remarks: entry.remarks,
        // status: entry.status,
        // plantName: entry.plantName,
        // loadedByUser: entry.loadedByUser,
        // vehicleNumber: entry.vehicleNumber,
        // arrivalDateAndTime: entry.arrivalDateAndTime,
        // driverContact: entry.driverContact,
        // driverIdPhoto: entry.driverIdPhoto,
        // vehicleReportingEntryVreDate: entry.vehicleReportingEntryVreDate,
        // linkedTransporterConfirmation: entry.linkedTransporterConfirmation,
        // transporterName: entry.transporterName,
    
      );
      final mode =
          (isSubmitted || isCancelled)
              ? LoadingView.completed
              : LoadingView.edit;
      emitSafeState(state.copyWith(form: updatedForm, view: mode));
    }
    if (entry == null) return;
  }



  void save() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));
      final nextMode = switch (state.view) {
        LoadingView.create => LoadingView.edit,
        LoadingView.edit || LoadingView.completed => LoadingView.completed,
      };

      final status = switch (state.view) {
        LoadingView.create => 'Draft',
        LoadingView.edit || LoadingView.completed => 'Submitted',
      };

      if (state.view == LoadingView.create) {
        final response = await repo.createLoadingCnfm(state.form);

        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            shouldAskForConfirmation.value = false;
            final docstatus = r.second;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: state.form.copyWith( name: docstatus),
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
  //   if (form.itemCode.doesNotHaveValue) {
  //     return optionOf(const Pair('Plant Name Missing', 0));
  //   }
  // //   } else if (form.vehicleNumber.doesNotHaveValue) {
  // //     return optionOf(const Pair('Enter Vehicle Number', 0));
  // //   } else if (form.driverIdPhoto.isNull) {
  // //     return optionOf(const Pair('Driver Id is Required ', 0));
  // //   }else if (form.driverContact.doesNotHaveValue || form.driverContact!.length != 10) {
  // //   return optionOf(const Pair('Please re-enter a valid 10-digit driver contact number', 0));
  // // }

    return const None();
  }
}

@freezed
class CreateLaodingCnfmState with _$CreateLaodingCnfmState {
  const factory CreateLaodingCnfmState({
    required LoadingCnfmForm form,
    required bool isLoading,
    required bool isSuccess,
    required LoadingView view,
    String? successMsg,
    Failure? error,
  }) = _CreateLaodingCnfmState;

  factory CreateLaodingCnfmState.initial() {
    final creationDate = DFU.friendlyFormat(DFU.now());
    

    return CreateLaodingCnfmState(
      form: LoadingCnfmForm(creation: creationDate),
      view: LoadingView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
