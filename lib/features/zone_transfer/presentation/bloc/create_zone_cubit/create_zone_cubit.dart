import 'dart:io';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';
import 'package:shakti_hormann/features/zone_transfer/data/zone_repo.dart';
import 'package:shakti_hormann/features/zone_transfer/model/zone_transfer.dart';

part 'create_zone_cubit.freezed.dart';

enum ZoneView { create, completed }

extension ActionType on ZoneView {
  String toName() {
    return switch (this) {
      ZoneView.create => 'Transfer',
      ZoneView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateZoneCubit extends AppBaseCubit<CreateZoneState> {
  CreateZoneCubit(this.repo) : super(CreateZoneState.initial());
  final ZoneRepo repo;

  void onValueChanged({
    String? storedBy,
    String? name,
    String? storageTimeStamp,
    String? remarks,
    int? docStatus,
    String? zoneName,
    String? salesOrders,
    int? totalQty,
    String? newzoneQr,
    String? oldzone,
    String? palletNo,
    File? zonePhoto,
  }) async {
    shouldAskForConfirmation.value = true;

    final form = state.form;

    final zonePhotos = zonePhoto ?? form.locationPhotoImg;
    final newForm = form.copyWith(
      storedBy: storedBy ?? form.storedBy,
      name: name ?? form.name,
      docStatus: docStatus ?? form.docStatus,
      remarks: remarks ?? form.remarks,
      salesOrders: salesOrders ?? form.salesOrders,
      totalQty: totalQty ?? form.totalQty,
      oldZone: oldzone ?? form.oldZone,
      newzoneQr: newzoneQr ?? form.newzoneQr,
      palletBoxQr: palletNo ?? form.palletBoxQr,
      locationPhotoImg: zonePhotos,
    );

    emitSafeState(state.copyWith(form: newForm));
  }
  void initFromStorage(Storage storage) async {
  shouldAskForConfirmation.value = false;
  final form = state.form;
  final updatedForm = form.copyWith(
    palletBoxQr: storage.palletBoxQr,
    totalQty: storage.totalQty,
    salesOrders: storage.salesOrders,
    oldZone: storage.zoneQr ?? storage.zoneName,
  );
  emitSafeState(state.copyWith(form: updatedForm, view: ZoneView.create,isMoveFlow : true));
}

  void initDetails(Object? entry) async {
    shouldAskForConfirmation.value = false;
    if (entry is ZoneTransfer) {
      final form = state.form;
      final updatedForm = form.copyWith(
        docStatus: entry.docStatus,
        name: entry.name,
        remarks: entry.remarks,
        storedBy: entry.storedBy,
        oldZone: entry.oldZone,
        locationPhoto: entry.locationPhoto,
        salesOrders: entry.salesOrders,
        totalQty: entry.totalQty,
        newzoneQr: entry.newzoneQr,
        palletBoxQr: entry.palletBoxQr,
      );
      emitSafeState(
        state.copyWith(form: updatedForm, view: ZoneView.completed),
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
    (items) {
      if (items.isEmpty) {
        emitSafeState(state.copyWith(isLoading: false));
        return;
      }

      final storage = items.first;

      emitSafeState(
        state.copyWith(
          isLoading: false,
          form: state.form.copyWith(
            palletBoxQr: rawQr,
            salesOrders: storage.salesOrders,
            totalQty: storage.totalQty,
            oldZone: storage.zoneName,
          ),
        ),
      );
    },
  );
}

  void save() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));
      // final nextMode = ZoneView.completed;

      final status = switch (state.view) {
        ZoneView.create => 'Draft',
        ZoneView.completed => 'Submitted',
      };

      if (state.view == ZoneView.create) {
        final response = await repo.createZone(state.form);

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
                successMsg: r.first,
                view: ZoneView.completed,
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
      return optionOf(const Pair('Missing PalletQr No', 0));
    } else if (form.oldZone.isNull || (form.oldZone?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing Old Zone No', 0));
    }else if (form.newzoneQr.isNull || (form.newzoneQr?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing New Zone No', 0));
    }
    else if (form.locationPhotoImg.isNull && form.locationPhoto.doesNotHaveValue) {
      return optionOf(const Pair('Missing Zone Photo', 0));
    }

    return const None();
  }
}

@freezed
class CreateZoneState with _$CreateZoneState {
  const factory CreateZoneState({
    required ZoneTransfer form,
    required bool isLoading,
    required bool isSuccess,
    required ZoneView view,
    @Default(false) bool isMoveFlow,

    String? successMsg,
    Failure? error,
  }) = _CreateZoneState;

  factory CreateZoneState.initial() {
    return const CreateZoneState(
      form: ZoneTransfer(),
      view: ZoneView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
