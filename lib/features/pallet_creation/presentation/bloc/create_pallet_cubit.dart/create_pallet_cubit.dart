import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/pallet_creation/data/pallet_repo.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_items.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';

part 'create_pallet_cubit.freezed.dart';

enum PalletView { create, edit, completed }

extension ActionType on PalletView {
  String toName() {
    return switch (this) {
      PalletView.create => 'Save',
      PalletView.edit => 'Update',
      PalletView.completed => 'Submitted',
    };
  }
}

@injectable
class CreatePalletCubit extends AppBaseCubit<CreatePalletState> {
  CreatePalletCubit(this.repo) : super(CreatePalletState.initial());
  final PalletRepo repo;

  void onValueChanged({
    String? owner,
    String? name,
    String? creation,
    String? modifiedDate,
    int? docStatus,
    String? modifiedBy,
    String? salesOrder,
    int? noofPallets,
  }) {
    shouldAskForConfirmation.value = true;

    final form = state.form;
    final newForm = form.copyWith(
      owner: owner ?? form.owner,
      name: name ?? form.name,
      creationDate: creation ?? form.creationDate,
      docStatus: docStatus ?? form.docStatus,
      modifiedDate: modifiedDate ?? form.modifiedDate,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      salesOrder: salesOrder ?? form.salesOrder,
      noofPallets: noofPallets ?? form.noofPallets,
    );
    emitSafeState(state.copyWith(form: newForm, isModified: true));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is PalletModel) {
      final form = state.form;
      final updatedForm = form.copyWith(
        docStatus: entry.docStatus,
        name: entry.name,
        creationDate: entry.creationDate,
        modifiedDate: entry.modifiedDate,
        modifiedBy: entry.modifiedBy,
        salesOrder: entry.salesOrder,
        noofPallets: entry.noofPallets,
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
              ? PalletView.completed
              : PalletView.edit;

      emitSafeState(
        state.copyWith(form: updatedForm, view: mode, isModified: false),
      );
    }
    if (entry == null) return;
  }

  /// Loads existing pallet line items fetched from the server (has `idx`).
  void addAllLines(List<PalletItems> lines) {
    emitSafeState(state.copyWith(lines: lines));
  }

  /// Adds a brand-new pallet entry (from the "Product Type" dialog).
  /// No `idx` set — the backend will treat this as a new row.
  void addPalletItem(PalletItems item) {
    emitSafeState(
      state.copyWith(
        lines: [...state.lines, item],
        isModified: true,
      ),
    );
  }

  /// Replaces the row at [index] after editing via the dialog.
  /// Preserves the original `idx` (if the row was already persisted) so the
  /// backend still recognizes it as an existing item on update, rather than
  /// treating an edited row as a brand-new one.
  void updatePalletItemAt(int index, PalletItems updatedItem) {
    if (index < 0 || index >= state.lines.length) return;

    final existing = state.lines[index];
    final merged = updatedItem.copyWith(idx: existing.idx);

    final updatedLines = [...state.lines];
    updatedLines[index] = merged;

    emitSafeState(state.copyWith(lines: updatedLines, isModified: true));
  }

  // void updateLinePhoto(int index, String localPath) {
  //   final lines = [...state.lines];
  //   lines[index] = lines[index].copyWith(shutterPhotoImg: File(localPath));
  //   emitSafeState(state.copyWith(lines: lines, isModified: true));
  // }

  void removeLineAt(int index) {
    final lines = [...state.lines]..removeAt(index);
    emitSafeState(state.copyWith(lines: lines, isModified: true));
  }

  void resetLines() {
    emitSafeState(state.copyWith(lines: []));
  }

  // void clearVehiclePhoto() {
  //   final form = state.form.copyWith(palletPhoto: null);
  //   emitSafeState(state.copyWith(form: form));
  // }

  void save() async {
    final validation = _validate();

    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

      final form = state.form;
      final isNew = form.name == null || form.name!.isEmpty;

      if (isNew) {
        final response = await repo.createPallet(form, state.lines);
        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            shouldAskForConfirmation.value = false;
            final docstatus = r.second;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: form.copyWith(status: 'Draft', name: docstatus),
                successMsg: '${r.first}\n${r.second}',
                view: PalletView.edit,
                isModified: false,
              ),
            );
          },
        );
        }

      // Existing draft doc — every subsequent save is an update.
      // Send the full line list; the repo distinguishes existing rows
      // (has `idx`) from new rows (no `idx`) and builds the request body
      // accordingly, so we don't need to track a separate "new" list here.
      final response = await repo.updatePallet(form, state.lines);
      return response.fold(
        (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
        (r) {
          shouldAskForConfirmation.value = false;
          emitSafeState(
            state.copyWith(
              isLoading: false,
              form: form.copyWith(status: 'Draft', name: r.second),
              isSuccess: true,
              successMsg: r.first,
              isModified: false,
              view: PalletView.edit,
            ),
          );
        },
      );
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

    if (form.salesOrder == null || form.salesOrder!.isEmpty) {
      return optionOf(const Pair('Select Sales Order', 0));
    }
    if (state.lines.isEmpty) {
      return optionOf(const Pair('Add at least one pallet entry', 0));
    }

    return const None();
  }
}

@freezed
class CreatePalletState with _$CreatePalletState {
  const factory CreatePalletState({
    required PalletModel form,
    required bool isLoading,
    required List<PalletItems> lines,
    required bool isSuccess,
    required PalletView view,
    @Default(false) bool isModified,

    String? successMsg,
    Failure? error,
  }) = _CreatePalletState;

  factory CreatePalletState.initial() {
    return const CreatePalletState(
      form: PalletModel(),
      lines: [],
      view: PalletView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}