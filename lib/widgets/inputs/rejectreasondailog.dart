import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/create_transport_cubit.dart/create_transport_cubit.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/create_vr_cubit/create_vehicle_cubit.dart';

void showRejectDialog(BuildContext context) {
  final parentContext = context;
  final TextEditingController reasonController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Reject Confirmation',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter a reason for rejection:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Reject Reason'),
                    Text(' *', style: TextStyle(color: Colors.red)),
                  ],
                ),
                hintText: 'Enter reject reason',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final reason = reasonController.text.trim();

              if (reason.isEmpty) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(content: Text('Enter reject reason')),
                );
                return;
              }

              Navigator.pop(dialogContext);

              parentContext.read<CreateTransportCubit>().reject(reason);
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}

void showRejectDialogs(BuildContext context) {
  final parentContext = context;
  final TextEditingController reasonController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Reject Confirmation',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter a reason for rejection:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Reject Reason'),
                    Text(' *', style: TextStyle(color: Colors.red)),
                  ],
                ),
                hintText: 'Enter reject reason',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final reason = reasonController.text.trim();

              if (reason.isEmpty) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(content: Text('Enter reject reason')),
                );
                return;
              }

              Navigator.pop(dialogContext);

              parentContext.read<CreateVehicleCubit>().reject(reason);
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}