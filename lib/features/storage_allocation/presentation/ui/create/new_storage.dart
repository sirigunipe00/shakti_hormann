import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/create_storage_cubit/create_storage_cubit.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/storage_filter_cubit.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/ui/create/storage_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewStorage extends StatefulWidget {
  const NewStorage({super.key});

  @override
  State<NewStorage> createState() => _NewStorageState();
}

class _NewStorageState extends State<NewStorage> {
  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreateStorageCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          status == null
              ? SimpleAppBar(
                title: 'New Storage Allocation',
                actionButton:
                    BlocBuilder<CreateStorageCubit, CreateStorageState>(
                      builder: (context, state) {
                        return AppButton(
                          borderColor: Colors.grey,
                          bgColor:
                              state.view == StorageView.create
                                  ? const Color.fromARGB(255, 250, 193, 47)
                                  : AppColors.green,
                          textStyle: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          isLoading: state.isLoading,
                          label: state.view.toName(),
                          onPressed: () {
                            context.cubit<CreateStorageCubit>().save();
                          },
                        );
                      },
                    ),
              )
              : TitleStatusAppBar(
                    title: '  $name',
                    status: StringUtils.docStatus(status),
                    textColor: AppColors.white,
                    pageMode: PageMode2.storagePacking,
                    onSubmit: () {},
                    onReject: () {},
                    showRejectButton: false,
                    actionButton:
                        gateEntryState.view == StorageView.completed
                            ? null
                            : BlocBuilder<
                              CreateStorageCubit,
                              CreateStorageState
                            >(
                              builder: (context, state) {
                                return AppButton(
                                  borderColor: Colors.grey,
                                  isLoading: state.isLoading,
                                  label: 'Save',
                                  onPressed: () {
                                    context.cubit<CreateStorageCubit>().save();
                                  },
                                );
                              },
                            ),
                  )
                  as PreferredSizeWidget,
      body: BlocListener<CreateStorageCubit, CreateStorageState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              // final docName = state.form.name;
              if (!context.mounted) return;
              context.cubit<CreateStorageCubit>().errorHandled();
              // context.cubit<FrameLinesCubit>().request(docName);
              final gateEntryFilters = context.read<StorageFilterCubit>().state;
              context.cubit<StorageCubit>().fetchInitial(
                Pair(
                  StringUtils.docStatusInt(gateEntryFilters.status),
                  gateEntryFilters.query,
                ),
              );
              Navigator.pop(context, true);
              setState(() {});
            });
          }
          if (state.error.isNotNull) {
            await AppDialog.showErrorDialog(
              context,
              title: state.error?.title,
              content: state.error!.error,
              onTapDismiss: context.exit,
            );
            if (!context.mounted) return;
            context.cubit<CreateStorageCubit>().errorHandled();
          }
        },
        child: StorageFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
