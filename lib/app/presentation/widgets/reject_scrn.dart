import 'package:flutter/material.dart';
import 'package:shakti_hormann/app/presentation/widgets/reject_dailogue.dart';

Future<void> showRejectBottomSheet({
  required BuildContext context,
  required void Function(String reason) onSubmit,
}) {
  final TextEditingController controller = TextEditingController();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return Padding(
        padding: MediaQuery.of(ctx).viewInsets,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: [
                  const Text(
                    'Enter Rejection Reason',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Type your reason here...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx); 
                        },
                        child: const Text('CANCEL', style: TextStyle(
                            fontFamily: 'Urbanist', fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            controller.text.trim().isEmpty
                                ? const Color.fromARGB(255, 187, 174, 174)
                                : Colors.green,
                          ),
                        ),
                        onPressed: controller.text.trim().isEmpty
                            ? null
                            : () {
                                final reason = controller.text.trim();
                                Navigator.pop(ctx);
                                onSubmit(reason);

                                // Show rejection dialog after bottom sheet closes
                                Future.delayed(const Duration(milliseconds: 300), () {
                                  showDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    builder: (_) => const RejectionDialog(
                                      entryId: 'GI-SHM-0001',
                                    ),
                                  );
                                });
                              },
                        child: const Text('SUBMIT', style: TextStyle(
                            fontFamily: 'Urbanist', fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
