// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shakti_hormann/core/core.dart';
// import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/bloc_provider.dart';
// import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/create_storage_cubit/create_storage_cubit.dart';
// import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/storage_filter_cubit.dart';
// import 'package:shakti_hormann/features/storage_allocation/presentation/ui/create/storage_form_widget.dart';
// import 'package:shakti_hormann/styles/app_color.dart';
// import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
// import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
// import 'package:shakti_hormann/widgets/simple_app_bar.dart';
// import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

// class NewStorage extends StatefulWidget {
//   const NewStorage({super.key});

//   @override
//   State<NewStorage> createState() => _NewStorageState();
// }

// class _NewStorageState extends State<NewStorage> {
//   @override
//   Widget build(BuildContext context) {
//     final gateEntryState = context.read<CreateStorageCubit>().state;
//     final newform = gateEntryState.form;
//     final status = newform.docStatus;
//     final name = newform.name;
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar:
//           status == null
//               ? SimpleAppBar(
//                 title: 'New Storage Allocation',
//                 actionButton:
//                     BlocBuilder<CreateStorageCubit, CreateStorageState>(
//                       builder: (context, state) {
//                         return AppButton(
//                           borderColor: Colors.grey,
//                           bgColor:
//                               state.view == StorageView.create
//                                   ? const Color.fromARGB(255, 250, 193, 47)
//                                   : AppColors.green,
//                           textStyle: const TextStyle(
//                             color: AppColors.darkBlue,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                           isLoading: state.isLoading,
//                           label: state.view.toName(),
//                           onPressed: () {
//                             context.cubit<CreateStorageCubit>().save();
//                           },
//                         );
//                       },
//                     ),
//               )
//               : TitleStatusAppBar(
//                     title: '  $name',
//                     status: StringUtils.docStatus(status),
//                     textColor: AppColors.white,
//                     pageMode: PageMode2.storagePacking,
//                     onSubmit: () {},
//                     onReject: () {},
//                     showRejectButton: false,
//                     actionButton:
//                         gateEntryState.view == StorageView.completed
//                             ? null
//                             : BlocBuilder<
//                               CreateStorageCubit,
//                               CreateStorageState
//                             >(
//                               builder: (context, state) {
//                                 return AppButton(
//                                   borderColor: Colors.grey,
//                                   isLoading: state.isLoading,
//                                   label: 'Save',
//                                   onPressed: () {
//                                     context.cubit<CreateStorageCubit>().save();
//                                   },
//                                 );
//                               },
//                             ),
//                   )
//                   as PreferredSizeWidget,
//       body: BlocListener<CreateStorageCubit, CreateStorageState>(
//         listener: (_, state) async {
//           if (state.isSuccess && state.successMsg.isNotNull) {
//             AppDialog.showSuccessDialog(
//               context,
//               title: 'Success',
//               content: state.successMsg.valueOrEmpty,
//               onTapDismiss: context.exit,
//             ).then((_) {
//               // final docName = state.form.name;
//               if (!context.mounted) return;
//               context.cubit<CreateStorageCubit>().errorHandled();
//               // context.cubit<FrameLinesCubit>().request(docName);
//               final gateEntryFilters = context.read<StorageFilterCubit>().state;
//               context.cubit<StorageCubit>().fetchInitial(
//                 Pair(
//                   StringUtils.docStatusInt(gateEntryFilters.status),
//                   gateEntryFilters.query,
//                 ),
//               );
//               Navigator.pop(context, true);
//               setState(() {});
//             });
//           }
//           if (state.error.isNotNull) {
//             await AppDialog.showErrorDialog(
//               context,
//               title: state.error?.title,
//               content: state.error!.error,
//               onTapDismiss: context.exit,
//             );
//             if (!context.mounted) return;
//             context.cubit<CreateStorageCubit>().errorHandled();
//           }
//         },
//         child: StorageFormWidget(key: ValueKey(status)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/storage_filter_cubit.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/ui/create/storage_form_widget.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/create_zone_cubit/create_zone_cubit.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/zone_filter_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewEntry extends StatelessWidget {
  const NewEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateZoneCubit, CreateZoneState>(
      builder: (context, zoneState) {
        final isEditingExisting = zoneState.form.docStatus != null;
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: isEditingExisting
              ? _statusAppBar(context, zoneState)
              : SimpleAppBar(
                  title: 'New Entry',
                  actionButton: AppButton(
                    borderColor: Colors.grey,
                    bgColor: zoneState.view == ZoneView.create
                        ? const Color.fromARGB(255, 250, 193, 47)
                        : AppColors.green,
                    textStyle: const TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    isLoading: zoneState.isLoading,
                    label: zoneState.view.toName(),
                    onPressed: zoneState.isLoading
                        ? null
                        : () => _onSaveWithConfirmation(context),
                  ),
                ),
          body: BlocListener<CreateZoneCubit, CreateZoneState>(
            listenWhen: (p, c) => p.isSuccess != c.isSuccess || p.error != c.error,
            listener: (context, state) => _handleZoneState(context, state),
            child: const StorageFormWidget(),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _statusAppBar(
    BuildContext context,
    CreateZoneState state,
  ) {
    final newform = state.form;
    return TitleStatusAppBar(
          title: '  ${newform.name}',
          status: StringUtils.docStatus(newform.docStatus ?? 0),
          textColor: AppColors.white,
          pageMode: PageMode2.storagePacking,
          onSubmit: () {},
          onReject: () {},
          showRejectButton: false,
          actionButton: state.view == ZoneView.completed
              ? null
              : AppButton(
                  borderColor: Colors.grey,
                  isLoading: state.isLoading,
                  label: 'Save',
                  onPressed: state.isLoading
                      ? null
                      : () => _onSaveWithConfirmation(context),
                ),
        )
        as PreferredSizeWidget;
  }

  Future<void> _onSaveWithConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Confirm Save',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Do you really want to submit? Once saved, this record cannot be modified.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF64748B),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      context.cubit<CreateZoneCubit>().save();
    }
  }

  // Widget _moveButton(BuildContext context, Storage storageForm) {
  //   return AppButton(
  //     borderColor: Colors.grey,
  //     bgColor: AppColors.green,
  //     textStyle: const TextStyle(
  //       color: AppColors.white,
  //       fontWeight: FontWeight.bold,
  //       fontSize: 15,
  //     ),
  //     label: 'Move',
  //     onPressed: () async {
  //       final refresh = await AppRoute.newZoneTransfer.push<bool>(
  //         context,
  //         extra: storageForm, // note: a Storage, not a ZoneTransfer
  //       );
  //       if (!context.mounted) return;
  //       if (refresh == true) Navigator.pop(context, true);
  //     },
  //   );
  // }

  void _handleZoneState(BuildContext context, CreateZoneState state) async {
    if (state.isSuccess && state.successMsg.isNotNull) {
      await AppDialog.showSuccessDialog(
        context,
        title: 'Success',
        content: state.successMsg.valueOrEmpty,
        onTapDismiss: context.exit,
      );
      if (!context.mounted) return;
      context.cubit<CreateZoneCubit>().errorHandled();
      try {
        final filters = context.read<StorageFilterCubit>().state;
        context.cubit<StorageCubit>().fetchInitial(
          Pair(StringUtils.docStatusInt(filters.status), filters.query),
        );
      } catch (_) {}
      try {
        final filters = context.read<ZoneFilterCubit>().state;
        context.cubit<ZoneCubit>().fetchInitial(
          Pair(StringUtils.docStatusInt(filters.status), filters.query),
        );
      } catch (_) {}
      Navigator.pop(context, true);
    }
    if (state.error.isNotNull) {
      await AppDialog.showErrorDialog(
        context,
        title: state.error?.title,
        content: state.error!.error,
        onTapDismiss: context.exit,
      );
      if (!context.mounted) return;
      context.cubit<CreateZoneCubit>().errorHandled();
    }
  }
}