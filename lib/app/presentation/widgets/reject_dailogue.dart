import 'package:flutter/material.dart';

class RejectionDialog extends StatelessWidget {

  const RejectionDialog({super.key, required this.entryId});
  final String entryId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.close_rounded, size: 64, color: Colors.white),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close_rounded, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Gate Entry Rejected!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Urbanist',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your Gate Entry for $entryId has been rejected.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Urbanist',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
