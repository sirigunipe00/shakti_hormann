import 'dart:io';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/proof_of_delivery/data/pod_repo.dart';
import 'package:shakti_hormann/features/proof_of_delivery/model/proof_of_delivery.dart';

part 'create_pod_cubit.freezed.dart';

enum PodView { create, edit, completed }

extension ActionType on PodView {
  String toName() {
    return switch (this) {
      PodView.create => 'Create',
      PodView.edit => 'Submit',
      PodView.completed => 'Submitted',
    };
  }
}

@injectable
class CreatePodCubit extends AppBaseCubit<CreatePodState> {
  CreatePodCubit(this.repo) : super(CreatePodState.initial());
  final ProofOfDeliveryRepo repo;

  void onValueChanged({
    String? plantName,
    String? name,
    String? podDate,
    String? customerName,
    int? docStatus,
    String? salesInvoiceDate,
    String? salesInvoice,
    String? geoLongitude,
    String? geoLatitude,
    File? podPhoto,
    File? unloadingPhoto1,
    File? unloadingPhoto2,
  }) {
    shouldAskForConfirmation.value = true;
    // final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final form = state.form;
    final podPhotos = podPhoto ?? form.podPhotoImg;

    final unloadingPhotos1 = unloadingPhoto1 ?? form.unloadingPhotoImg1;
    final unloadingPhotos2 = unloadingPhoto2 ?? form.unloadingPhotoImg2;

    final newForm = form.copyWith(
      plantName: plantName ?? form.plantName,
      name: name ?? form.name,
      podDate: podDate ?? form.podDate,
      docStatus: docStatus ?? form.docStatus,
      salesInvoice: salesInvoice ?? form.salesInvoice,
      customerName: customerName ?? form.customerName,
      salesInvoiceDate: salesInvoiceDate ?? form.salesInvoiceDate,
      geoLongitude: geoLongitude ?? form.geoLongitude,
      geoLatitude: geoLatitude ?? form.geoLatitude,
      podPhotoImg: podPhotos,
      unloadingPhotoImg1: unloadingPhotos1,
      unloadingPhotoImg2: unloadingPhotos2,
    );
    emitSafeState(state.copyWith(form: newForm));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is ProofOfDelivery) {
      DFU.toDateTime(entry.podDate.valueOrEmpty, 'dd-MM-yyyy');
      final form = state.form;
      final updatedForm = form.copyWith(
        name: entry.name,
        podDate: entry.podDate,
        plantName: entry.plantName,
        customerName: entry.customerName,
        salesInvoice: entry.salesInvoice,
        salesInvoiceDate: entry.salesInvoiceDate,
        docStatus: entry.docStatus,
        geoLongitude: entry.geoLongitude,
        geoLatitude: entry.geoLatitude,
        podPhoto: entry.podPhoto,
        unloadingPhoto1: entry.unloadingPhoto1,
        unloadingPhoto2: entry.unloadingPhoto2,
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
          (isSubmitted || isCancelled) ? PodView.completed : PodView.edit;
      emitSafeState(state.copyWith(form: updatedForm, view: mode));
    }
    if (entry == null) return;
  }

  void clearPodPhoto() {
    final form = state.form.copyWith(podPhoto: null);
    emitSafeState(state.copyWith(form: form));
  }

  void clearUnLoading1Photo() {
    final form = state.form.copyWith(unloadingPhoto1: null);
    emitSafeState(state.copyWith(form: form));
  }

  void clearUnLoading2Photo() {
    final form = state.form.copyWith(unloadingPhoto2: null);
    emitSafeState(state.copyWith(form: form));
  }

  void save() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));
      final nextMode = switch (state.view) {
        PodView.create => PodView.edit,
        PodView.edit || PodView.completed => PodView.completed,
      };

      final status = switch (state.view) {
        PodView.create => 'Draft',
        PodView.edit || PodView.completed => 'Submitted',
      };

      if (state.view == PodView.create) {
        final response = await repo.createPod(state.form);

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
      else {
        final response = await repo.submitPod(state.form);

        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            final docstatus = r.second;
            shouldAskForConfirmation.value = false;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: state.form.copyWith(name: docstatus),
                successMsg: r.first,
                view: PodView.completed,
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

    if (form.salesInvoice.doesNotHaveValue) {
      return optionOf(const Pair('Select Invoice No', 0));
    } else if (form.podPhoto.doesNotHaveValue && form.podPhotoImg.isNull) {
      return optionOf(const Pair('Capture Pod Photo.', 0));
    } else if (form.unloadingPhoto1.doesNotHaveValue &&
        form.unloadingPhotoImg1.isNull) {
      return optionOf(const Pair('Capture UnLoading Photo.', 0));
    } 
    

    return const None();
  }
}

@freezed
class CreatePodState with _$CreatePodState {
  const factory CreatePodState({
    required ProofOfDelivery form,
    required bool isLoading,
    required bool isSuccess,
    required PodView view,

    String? successMsg,
    Failure? error,
  }) = _CreatePodState;

  factory CreatePodState.initial() {
    // final creationDate = DFU.friendlyFormat(DFU.now());

    return const CreatePodState(
      form: ProofOfDelivery(),
      view: PodView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
