import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/create_transport_cubit.dart/create_transport_cubit.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/create_vr_cubit/create_vehicle_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_popup_card.dart';

void showRejectDialog(BuildContext context) {
  final parentContext = context;
  final reasonController = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'RejectDialog',
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, _, __) {
      return AppPopupCard(
        title: 'Reject Confirmation',
        icon: Icons.block_rounded,
        iconBackground: const Color(0xFFFEE2E2),
        iconColor: const Color(0xFFE11D48),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please enter a reason for rejection:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: reasonController,
              maxLines: 3,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Enter reject reason',
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.darkBlue,
                    width: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
        cancelText: 'Cancel',
        onCancel: () => Navigator.pop(dialogContext),
        confirmText: 'Confirm',
        confirmIcon: Icons.check_rounded,
        confirmColor: const Color(0xFFE11D48),
        onConfirm: () {
          final reason = reasonController.text.trim();
          if (reason.isEmpty) {
            ScaffoldMessenger.of(parentContext).showSnackBar(
              const SnackBar(content: Text('Enter Reject Reason')),
            );
            return;
          }
          Navigator.pop(dialogContext);
          parentContext.read<CreateTransportCubit>().reject(reason);
        },
        onClose: () => Navigator.pop(dialogContext),
      );
    },
  );
}

void showRejectDialogs(BuildContext context) {
  final parentContext = context;
  final reasonController = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'RejectDialog',
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, _, __) {
      return AppPopupCard(
        title: 'Reject Confirmation',
        icon: Icons.block_rounded,
        iconBackground: const Color(0xFFFEE2E2),
        iconColor: const Color(0xFFE11D48),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please enter a reason for rejection:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: reasonController,
              maxLines: 3,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Enter reject reason',
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.darkBlue,
                    width: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
        cancelText: 'Cancel',
        onCancel: () => Navigator.pop(dialogContext),
        confirmText: 'Confirm',
        confirmIcon: Icons.check_rounded,
        confirmColor: const Color(0xFFE11D48),
        onConfirm: () {
          final reason = reasonController.text.trim();
          if (reason.isEmpty) {
            ScaffoldMessenger.of(parentContext).showSnackBar(
              const SnackBar(content: Text('Enter Reject Reason')),
            );
            return;
          }
          Navigator.pop(dialogContext);
          parentContext.read<CreateVehicleCubit>().reject(reason);
        },
        onClose: () => Navigator.pop(dialogContext),
      );
    },
  );
}
