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
import 'package:shakti_hormann/widgets/form_page_loading_stack.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewEntry extends StatefulWidget {
  const NewEntry({super.key});

  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  bool _needsListRefresh = false;

  bool _canSave(CreateZoneState zoneState) {
    final form = zoneState.form;
    final hasPallet = zoneState.isMoveFlow ||
        (form.palletBoxQr != null && form.palletBoxQr!.trim().isNotEmpty);
    final hasZone = form.zoneQr != null && form.zoneQr!.trim().isNotEmpty;
    final hasPhoto = form.locationPhotoImg != null ||
        (form.locationPhoto?.trim().isNotEmpty ?? false);
    return hasPallet && hasZone && hasPhoto;
  }

  String _saveHint(CreateZoneState zoneState) {
    final form = zoneState.form;
    final hasPallet = zoneState.isMoveFlow ||
        (form.palletBoxQr != null && form.palletBoxQr!.trim().isNotEmpty);
    final hasZone = form.zoneQr != null && form.zoneQr!.trim().isNotEmpty;
    final hasPhoto = form.locationPhotoImg != null ||
        (form.locationPhoto?.trim().isNotEmpty ?? false);

    if (!hasPallet) return 'Scan the pallet / box QR first';
    if (!hasZone) return 'Scan the zone QR before saving';
    if (!hasPhoto) return 'Capture the allocated zone photo before saving';
    return 'Please wait for processing to finish';
  }

  void _showSaveHint(CreateZoneState zoneState) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_saveHint(zoneState)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _refreshLists() {
    if (!mounted) return;
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateZoneCubit, CreateZoneState>(
      builder: (context, zoneState) {
        final isEditingExisting = zoneState.form.docStatus != null;
        final canSave = _canSave(zoneState);
        final title = zoneState.isMoveFlow
            ? 'Move to Zone'
            : 'New Storage Allocation';

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            Navigator.of(context).pop(_needsListRefresh);
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: isEditingExisting
                ? _statusAppBar(context, zoneState)
                : SimpleAppBar(
                    title: title,
                    actionButton: AppButton(
                      borderColor: Colors.grey,
                      bgColor: !canSave
                          ? const Color(0xFFCBD5E1)
                          : zoneState.view == ZoneView.create
                              ? const Color.fromARGB(255, 250, 193, 47)
                              : AppColors.green,
                      textStyle: TextStyle(
                        color: !canSave
                            ? Colors.grey.shade600
                            : AppColors.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      isLoading: zoneState.isLoading,
                      label: zoneState.view.toName(),
                      onPressed: zoneState.isLoading
                          ? null
                          : () {
                              if (!canSave) {
                                _showSaveHint(zoneState);
                                return;
                              }
                              _onSaveWithConfirmation(context);
                            },
                    ),
                  ),
            body: FormPageLoadingStack(
              isLoading: zoneState.isLoading,
              message: zoneState.isLoading &&
                      (zoneState.form.palletBoxQr == null ||
                          zoneState.form.palletBoxQr!.isEmpty)
                  ? 'Reading pallet…'
                  : 'Saving document...',
              statusLabel: 'Please wait...',
              child: BlocListener<CreateZoneCubit, CreateZoneState>(
                listenWhen: (p, c) =>
                    p.isSuccess != c.isSuccess || p.error != c.error,
                listener: (context, state) => _handleZoneState(context, state),
                child: const StorageFormWidget(),
              ),
            ),
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
                      : () {
                          if (!_canSave(state)) {
                            _showSaveHint(state);
                            return;
                          }
                          _onSaveWithConfirmation(context);
                        },
                ),
        )
        as PreferredSizeWidget;
  }

  Future<void> _onSaveWithConfirmation(BuildContext context) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Confirm Save',
      content:
          'Do you really want to submit? Once saved, this record cannot be modified.',
      confirmText: 'Save',
      icon: Icons.warning_amber_rounded,
      iconBackground: const Color(0xFFFEF3C7),
      iconColor: const Color(0xFFD97706),
      confirmIcon: Icons.save_rounded,
      confirmColor: AppColors.darkBlue,
    );

    if (confirmed == true && context.mounted) {
      context.cubit<CreateZoneCubit>().save();
    }
  }

  void _handleZoneState(BuildContext context, CreateZoneState state) async {
    if (state.isSuccess && state.successMsg.isNotNull) {
      await AppDialog.showSuccessDialog(
        context,
        title: 'Success',
        content: state.successMsg.valueOrEmpty,
        onTapDismiss: context.exit,
      );
      if (!context.mounted) return;
      _needsListRefresh = true;
      context.cubit<CreateZoneCubit>().errorHandled();
      _refreshLists();
      shouldAskForConfirmation.value = false;
      Navigator.pop(context, true);
      return;
    }
    if (state.error.isNotNull) {
      // Scan / same-zone errors are shown as snackbars in the form.
      if (state.error?.title == 'SAME_ZONE') {
        return;
      }
      // Skip missing-fields here — Save button already snackbars those.
      if (state.error?.title == 'Missing Fields') {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!.error),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.cubit<CreateZoneCubit>().errorHandled();
        return;
      }
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
