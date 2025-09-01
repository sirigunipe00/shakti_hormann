import 'package:flutter/material.dart';

class TimePickerField extends StatefulWidget {
  const TimePickerField({
    super.key,
    this.title,
    this.hintText,
    this.initialTime,
    required this.onTimeChanged,
    this.readOnly = false,
  });

  final String? title;
  final String? hintText;
  final String? initialTime;
  final ValueChanged<String> onTimeChanged;
  final bool readOnly;

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTime ?? '');
  }

  Future<void> _pickTime() async {
    if (widget.readOnly) return;

    TimeOfDay initialTime = TimeOfDay.now();

    if (widget.initialTime != null && widget.initialTime!.isNotEmpty) {
      final parts = widget.initialTime!.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        initialTime = TimeOfDay(hour: hour, minute: minute);
      }
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (pickedTime != null) {
      final hour = pickedTime.hour.toString().padLeft(2, '0');
      final minute = pickedTime.minute.toString().padLeft(2, '0');
      final time24h = '$hour:$minute';

      _controller.text = time24h;
      widget.onTimeChanged(time24h);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Background & border based on readonly state
    final bgColor =
        widget.readOnly ? Colors.grey.withValues(alpha:0.2) : Colors.white;
    final borderColor = widget.readOnly
        ? Colors.grey.withValues(alpha:0.3)
        : Colors.grey.withValues(alpha:0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null && widget.title!.isNotEmpty) ...[
          Text(
            widget.title!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              fontFamily: 'Urbanist',
            ),
          ),
          const SizedBox(height: 2),
        ],
        TextField(
          controller: _controller,
          readOnly: true, // prevent manual typing
          onTap: _pickTime,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Select Time',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.readOnly ? borderColor : Colors.blue,
                width: 1.2,
              ),
            ),
            suffixIcon: const Icon(Icons.access_time),
            fillColor: bgColor,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}
