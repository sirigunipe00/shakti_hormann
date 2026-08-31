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
      ZoneView.create => 'Save',
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
    int? palletCount,
  }) async {
    shouldAskForConfirmation.value = true;

    if (newzoneQr != null &&
        newzoneQr.trim().isNotEmpty &&
        state.form.oldZone != null &&
        state.form.oldZone!.trim().isNotEmpty &&
        newzoneQr.trim() == state.form.oldZone!.trim()) {
      emitSafeState(
        state.copyWith(
          error: Failure(
            error:
                "Pallet is already in zone '${state.form.oldZone}'. Scan a different zone to move it.",
            title: 'SAME_ZONE',
            status: 400,
          ),
        ),
      );
      return;
    }

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
      zoneQr: newzoneQr ?? form.zoneQr,
      palletBoxQr: palletNo ?? form.palletBoxQr,
      palletCount: palletCount ?? form.palletCount,
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
    emitSafeState(
      state.copyWith(form: updatedForm, view: ZoneView.create, isMoveFlow: true),
    );
    final palletQr = storage.palletBoxQr;
    if (palletQr != null && palletQr.isNotEmpty) {
      await onQrScanned(palletQr);
    }
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
        oldZone: entry.oldZone,
        locationPhoto: entry.locationPhoto,
        salesOrders: entry.salesOrders,
        totalQty: entry.totalQty,
        palletCount: entry.palletCount,
        zoneQr: entry.zoneQr,
        palletBoxQr: entry.palletBoxQr,
      );
      emitSafeState(
        state.copyWith(
          form: updatedForm,
          view: entry.docStatus == null ? ZoneView.create : ZoneView.completed,
        ),
      );
      await _loadTransferCount(entry.palletBoxQr);
    } else if (entry is ZoneTransfer) {
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
        zoneQr: entry.newzoneQr,
        palletBoxQr: entry.palletBoxQr,
      );
      emitSafeState(
        state.copyWith(
          form: updatedForm,
          view: entry.docStatus == null ? ZoneView.create : ZoneView.completed,
        ),
      );
      await _loadTransferCount(entry.palletBoxQr);
    }
  }

  Future<void> _loadTransferCount(String? palletQr) async {
    if (palletQr == null || palletQr.isEmpty) return;
    final history = await repo.getPalletTransferCount(palletQr);
    history.fold((_) {}, (count) {
      emitSafeState(
        state.copyWith(form: state.form.copyWith(palletCount: count)),
      );
    });
  }

Future<void> onQrScanned(String rawQr) async {
  emitSafeState(state.copyWith(isLoading: true, error: null));

  final result = await repo.scanPalletForZoneTransfer(rawQr);

  await result.fold(
    (failure) async {
      emitSafeState(
        state.copyWith(
          isLoading: false,
          error: failure,
        ),
      );
    },
    (scan) async {
      var transferCount = scan.transferCount;
      final history = await repo.getPalletTransferCount(scan.palletQr);
      history.fold((_) {}, (count) => transferCount = count);

      emitSafeState(
        state.copyWith(
          isLoading: false,
          form: state.form.copyWith(
            palletBoxQr: scan.palletQr,
            salesOrders: scan.salesOrder ?? '',
            totalQty: scan.totalQty,
            oldZone: scan.oldZoneName ?? '',
            currentZone: scan.oldZoneName ?? '',
            allocationStatus: scan.allocationStatus,
            palletCount: transferCount,
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

      if (state.view == ZoneView.create) {
        final response = await repo.createZone(state.form);

        return response.fold(
          (l) => emitSafeState(
            state.copyWith(isLoading: false, error: l, isSuccess: false),
          ),
          (r) {
            shouldAskForConfirmation.value = false;
            final docstatus = r.second;
            final isFirstAllocation =
                state.form.oldZone == null ||
                state.form.oldZone!.trim().isEmpty;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: state.form.copyWith(
                  status: isFirstAllocation ? 'Stored' : 'Transferred',
                  allocationStatus: 'Allocated',
                  currentZone: state.form.zoneQr,
                  name: docstatus,
                  docStatus: 1,
                ),
            successMsg: '${r.first} ${r.second}',
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
    } else if (form.zoneQr.isNull || (form.zoneQr?.trim().isEmpty ?? true)) {
      return optionOf(const Pair('Missing New Zone QR', 0));
    } else if (form.locationPhotoImg.isNull &&
        form.locationPhoto.doesNotHaveValue) {
      return optionOf(const Pair('Missing Zone Photo', 0));
    }

    return const None();
  }
}

@freezed
class CreateZoneState with _$CreateZoneState {
  const factory CreateZoneState({
    required Storage form,
    required bool isLoading,
    required bool isSuccess,
    required ZoneView view,
    @Default(false) bool isMoveFlow,

    String? successMsg,
    Failure? error,
  }) = _CreateZoneState;

  factory CreateZoneState.initial() {
    return const CreateZoneState(
      form: Storage(),
      view: ZoneView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
