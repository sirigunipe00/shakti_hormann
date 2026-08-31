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
          (isSubmitted || isCancelled) ? PalletView.completed : PalletView.edit;

      emitSafeState(
        state.copyWith(form: updatedForm, view: mode, isModified: false),
      );
    }
    if (entry == null) return;
  }

  void addAllLines(List<PalletItems> lines) {
    emitSafeState(state.copyWith(lines: lines));
  }

  void addPalletItem(PalletItems item) {
    shouldAskForConfirmation.value = true;
    emitSafeState(
      state.copyWith(lines: [...state.lines, item], isModified: true),
    );
  }

  void updatePalletItemAt(int index, PalletItems updatedItem) {
    if (index < 0 || index >= state.lines.length) return;
    shouldAskForConfirmation.value = true;

    final existing = state.lines[index];
    final merged = updatedItem.copyWith(idx: existing.idx);

    final updatedLines = [...state.lines];
    updatedLines[index] = merged;

    emitSafeState(state.copyWith(lines: updatedLines, isModified: true));
  }

  void removeLineAt(int index) {
    final lines = [...state.lines]..removeAt(index);
    emitSafeState(state.copyWith(lines: lines, isModified: true));
  }

  void resetLines() {
    emitSafeState(state.copyWith(lines: []));
  }

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
                form: form.copyWith(
                  status: 'Draft',
                  name: docstatus,
                  docStatus: 0,
                ),
                successMsg: '${r.first}\n${r.second}',
                view: PalletView.edit,
                isModified: false,
              ),
            );
          },
        );
      }

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
              successMsg: '${r.first}\n${r.second}',
              isModified: false,
              view: PalletView.edit,
            ),
          );
        },
      );
    }, _emitError);
  }

  void submit() async {
    final form = state.form;
    final docName = form.name;
    if (docName == null || docName.isEmpty) return;

    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    final response = await repo.submitPallet(docName);
    response.fold(
      (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
      (r) {
        shouldAskForConfirmation.value = false;
        emitSafeState(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            successMsg: '${r.first}\n${r.second}',
            form: form.copyWith(docStatus: 1, status: 'Submitted'),
            view: PalletView.completed,
            isModified: false,
          ),
        );
      },
    );
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
