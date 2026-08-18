import 'dart:io';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/storage_allocation/data/storage_repo.dart';
import 'package:shakti_hormann/features/storage_allocation/model/pallet_details.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';

part 'create_storage_cubit.freezed.dart';

enum StorageView { create, completed }

extension ActionType on StorageView {
  String toName() {
    return switch (this) {
      StorageView.create => 'Allocate',
      StorageView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateStorageCubit extends AppBaseCubit<CreateStorageState> {
  CreateStorageCubit(this.repo) : super(CreateStorageState.initial());
  final StorageRepo repo;

  void onValueChanged({
    String? storedBy,
    String? name,
    String? storageTimeStamp,
    String? remarks,
    int? docStatus,
    String? zoneName,
    String? salesOrders,
    int? totalQty,
    String? zoneQr,
    int? palletCount,
    String? oldZone,
    String? palletNo,
    File? zonePhoto,
  }) async {
    shouldAskForConfirmation.value = true;

    final form = state.form;

    final zonePhotos = zonePhoto ?? form.locationPhotoImg;
    final newForm = form.copyWith(
      storedBy: storedBy ?? form.storedBy,
      name: name ?? form.name,
      storageTimeStamp: storageTimeStamp ?? form.storageTimeStamp,
      docStatus: docStatus ?? form.docStatus,
      remarks: remarks ?? form.remarks,
      zoneName: zoneName ?? form.zoneName,
      salesOrders: salesOrders ?? form.salesOrders,
      totalQty: totalQty ?? form.totalQty,
      oldZone: oldZone ?? form.oldZone,
      zoneQr: zoneQr ?? form.zoneQr,
      palletBoxQr: palletNo ?? form.palletBoxQr,
      locationPhotoImg: zonePhotos,
    );

    emitSafeState(state.copyWith(form: newForm));
  }

  void initDetails(Object? entry) async {
    shouldAskForConfirmation.value = false;
    if (entry is Storage) {
      final form = state.form;
      final updatedForm = form.copyWith(
        docStatus: entry.docStatus,
        name: entry.name,
        remarks: entry.remarks,
        storedBy: entry.storedBy,
        storageTimeStamp: entry.storageTimeStamp,
        locationPhoto: entry.locationPhoto,
        salesOrders: entry.salesOrders,
        totalQty: entry.totalQty,
        zoneName: entry.zoneName,
        zoneQr: entry.zoneQr,
        palletBoxQr: entry.palletBoxQr,
        palletCount: entry.palletCount,
        oldZone: entry.oldZone
      );
      emitSafeState(
        state.copyWith(form: updatedForm, view: StorageView.completed),
      );
    }
    if (entry == null) return;
  }

Future<void> onQrScanned(String rawQr) async {
  emitSafeState(state.copyWith(isLoading: true));

  final result = await repo.fetchSales(rawQr);

  result.fold(
    (failure) {
      emitSafeState(
        state.copyWith(
          isLoading: false,
          error: failure,
        ),
      );
    },
   (response) {
  emitSafeState(
    state.copyWith(
      isLoading: false,
      pallet: response,
      form: state.form.copyWith(
        palletBoxQr: response.data?.palletNo,
        totalQty: response.data?.totalQty,
        salesOrders: response.data?.salesOrders?.join(', '),
      ),
    ),
  );
}
  );
}

  void save() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));
      // final nextMode = StorageView.completed;

      final status = switch (state.view) {
        StorageView.create => 'Draft',
        StorageView.completed => 'Submitted',
      };

      if (state.view == StorageView.create) {
        final response = await repo.createStorage(state.form);

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
                form: state.form.copyWith(
                  status: status,
                  name: docstatus,
                  docStatus: 1,
                ),
                successMsg: '${r.first}\n${r.second}',
                view: StorageView.completed,
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
    if (form.palletBoxQr.isNull || (form.palletBoxQr?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing Pallet Qr No', 0));
    } else if (form.zoneQr.isNull || (form.zoneQr?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing Zone No', 0));
    }else if (form.salesOrders.isNull || (form.salesOrders?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing Sales Order No', 0));
    }
    else if (form.locationPhotoImg.isNull && form.locationPhoto.doesNotHaveValue) {
      return optionOf(const Pair('Missing Zone Photo', 0));
    }

    return const None();
  }
}

@freezed
class CreateStorageState with _$CreateStorageState {
  const factory CreateStorageState({
    required Storage form,
    required bool isLoading,
    required bool isSuccess,
    required StorageView view,
    required PalletDetails pallet,

    String? successMsg,
    Failure? error,
  }) = _CreateStorageState;

  factory CreateStorageState.initial() {
    return const CreateStorageState(
      form: Storage(),
      view: StorageView.create,
      isLoading: false,
      pallet: PalletDetails(),
      isSuccess: false,
    );
  }
}
