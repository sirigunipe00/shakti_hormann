import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';

class RejectReasonDialog extends StatefulWidget {
  const RejectReasonDialog({super.key});

  @override
  State<RejectReasonDialog> createState() => _RejectReasonDialogState();
}

class _RejectReasonDialogState extends State<RejectReasonDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Enter your reason here...'),
        maxLength: 64,
        minLines: 3,
        maxLines: 6,
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(context.colorScheme.secondary),
          ),
          child: const Text('REJECT', style: TextStyle(color: Colors.white)),
        ),
        OutlinedButton(child: const Text('CANCEL'), onPressed: () => Navigator.of(context).pop('')),
      ],
    );
  }
}
