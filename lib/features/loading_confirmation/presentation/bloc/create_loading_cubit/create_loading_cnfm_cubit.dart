import 'dart:developer';

import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/loading_confirmation/data/loading_cnfm_repo.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';


part 'create_loading_cnfm_cubit.freezed.dart';

enum LoadingView { create, edit, completed, sumitted }

extension ActionType on LoadingView {
  String toName() {
    return switch (this) {
      LoadingView.create => 'Create',
      LoadingView.edit => 'Update',
      LoadingView.completed => 'Submit',
      LoadingView.sumitted => 'Submitted',
    };
  }
}

@injectable
class CreateLoadingCnfmCubit extends AppBaseCubit<CreateLaodingCnfmState> {
  CreateLoadingCnfmCubit(this.repo) : super(CreateLaodingCnfmState.initial());
  final LoadingCnfmRepo repo;

  void onValueChanged({
    String? remarks,
    String? itemName,
    String? salesUom,
    String? itemCode,
    String? images,
    String? name,
    String? uomValue,
    int? quantityLoaded,
  }) {
    shouldAskForConfirmation.value = true;
    final form = state.items;

    final newForm = form.copyWith(
      name: name ?? form.name,
      itemCode: itemCode ?? form.itemCode,
      itemName: itemName ?? form.itemName,
      uomValue: salesUom ?? form.uomValue,
      qty: quantityLoaded ?? form.qty,
    );
    emitSafeState(state.copyWith(items: newForm));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is LoadingCnfmForm) {
    
      final form = state.form;
      final updatedForm = form.copyWith(
        docstatus: entry.docstatus,
        name: entry.name,

        remarks: entry.remarks,
        status: entry.status,
        plantName: entry.plantName,
        loadedByUser: entry.loadedByUser,
        vehicleNumber: entry.vehicleNumber,
        arrivalDateAndTime: entry.arrivalDateAndTime,
        driverContact: entry.driverContact,
        driverIdPhoto: entry.driverIdPhoto,
        arrivalDate: entry.arrivalDate,
        arrivalTime: entry.arrivalTime,
        vehicleReportingEntryVreDate: entry.vehicleReportingEntryVreDate,
        linkedTransporterConfirmation: entry.linkedTransporterConfirmation,
        transporterName: entry.transporterName,
        transporterName2: entry.transporterName2,
      );
      final mode = LoadingView.completed;
      emitSafeState(state.copyWith(form: updatedForm, view: mode));
    }
    if (entry == null) return;
  }

  void addItem(ItemModel newItem) {

    final updatedItems = [...state.listitems, newItem];


    final stat = state.copyWith(listitems: updatedItems, view: LoadingView.create);

    emitSafeState(stat);
  }
  void addInitialItem(ItemModel newItem) {

    final updatedItems = [...state.listitems, newItem];

    final stat = state.copyWith(listitems: updatedItems);

    emitSafeState(stat);
  }
void updateItem(int index, ItemModel updatedItem) {

  final currentItems = List<ItemModel>.from(state.listitems);
  final oldItem = currentItems[index];

  final mergedItem = updatedItem.copyWith(
  loadedItemPhoto: updatedItem.loadedItemPhoto?.isNotEmpty == true
      ? updatedItem.loadedItemPhoto
      : oldItem.loadedItemPhoto,
  imageFile: updatedItem.imageFile ?? oldItem.imageFile,
);


  currentItems[index] = mergedItem;

  emitSafeState(state.copyWith(
    listitems: currentItems,
    view: LoadingView.edit,
  ));
}



  void save() async {
    log('state.listitems--:${state.listitems}');
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));




      if (state.view == LoadingView.create) {
        final response = await repo.createLoadingCnfm(
          state.listitems,
          state.form.name ?? '',
        );

        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            shouldAskForConfirmation.value = false;
            final docstatus = r.second;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: state.form.copyWith(name: docstatus),
                successMsg: r.first,
                view: LoadingView.edit,
              ),
            );
          },
        );
      }
        else if (state.view == LoadingView.edit) {


      
      final response = await repo.updateLoadingCnfm(
        state.listitems,
        state.form.name ?? '',
      );

      return response.fold(
        (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
        (r) {
          shouldAskForConfirmation.value = false;
          emitSafeState(
            state.copyWith(
              isLoading: false,
              isSuccess: true,
              successMsg: r.first,
              view: LoadingView.edit,
            ),
          );
        },
      );
    }
      else  if (state.view == LoadingView.completed || state.view == LoadingView.sumitted){
        final response = await repo.submitLoading(state.form.name ?? '');
        

        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            final docstatus = r.second ;
            shouldAskForConfirmation.value = false;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: state.form.copyWith(name: docstatus),
                successMsg: r.first,
                view: LoadingView.sumitted,
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
  final items = state.listitems;


  if (items.isEmpty ) {
    return optionOf(const Pair('At least one item is required to submit', 0));
  }


  for (var item in items) {
    if (item.itemCode == null || item.itemCode!.trim().isEmpty) {
      return optionOf(const Pair('Item Code is required', 0));
    }

  }

  return none();
}

}

@freezed
class CreateLaodingCnfmState with _$CreateLaodingCnfmState {
  const factory CreateLaodingCnfmState({
    required LoadingCnfmForm form,
    required List<ItemModel> listitems,
    required ItemModel items,
    required bool isLoading,
    required bool isSuccess,
    required LoadingView view,
    String? successMsg,
    Failure? error,
  }) = _CreateLaodingCnfmState;

  factory CreateLaodingCnfmState.initial() {
    final creationDate = DFU.friendlyFormat(DFU.now());

    return CreateLaodingCnfmState(
      items: const ItemModel(),
      listitems: <ItemModel>[],
      form: LoadingCnfmForm(creation: creationDate),
      view: LoadingView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}