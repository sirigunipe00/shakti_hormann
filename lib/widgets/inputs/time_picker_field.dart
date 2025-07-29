import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';


class AppTimeField extends StatefulWidget {
  const AppTimeField({
    super.key,
    required this.title,
    required this.onSelected,
    this.initialTime,
    this.readOnly = false,
    this.hintText,
    this.suffixIcon = const Icon(Icons.timer_outlined, color: AppColors.black),
    this.isRequired = false,
  });

  final String title;
  final String? initialTime;
  final bool readOnly;
  final Function(TimeOfDay) onSelected;
  final String? hintText;
  final Widget? suffixIcon;
  final bool isRequired;

  @override
  State<AppTimeField> createState() => _AppTimeFieldState();
}

class _AppTimeFieldState extends State<AppTimeField> {
  final controller = TextEditingController();
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime.containsValidValue){
      controller.text = widget.initialTime!;
      final dateTime = DateTime.tryParse(widget.initialTime!);
      if(dateTime.isNotNull) {
        selectedTime = TimeOfDay.fromDateTime(dateTime!);
      }
    }
  }

  final textFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4.0),
    borderSide: const BorderSide(color: AppColors.green),
  );
  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      defaultHeight: 4.0,
      children: [
        CaptionText(title: widget.title, isRequired: widget.isRequired),
        TextField(
          onTap: () {
            if (widget.readOnly) return;
            _showDatePicker();
          },
          controller: controller,
          decoration: InputDecoration(
            border: textFieldBorder,
            enabledBorder: textFieldBorder,
            focusedBorder: textFieldBorder,
            disabledBorder: textFieldBorder,
            contentPadding: const EdgeInsets.all(12.0),
            suffixIcon: widget.suffixIcon,
            counterText: '',
          ),
          obscuringCharacter: '*',
          textInputAction: TextInputAction.done,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          textCapitalization: TextCapitalization.none,
          readOnly: true,
          autocorrect: false,
        ),
      ],
    );
  }

  void _showDatePicker() {
    showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: selectedTime ?? TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        widget.onSelected(value);
        selectedTime = value;
        final formatter = NumberFormat('00');
        final timeFormat =
                '${formatter.format(value.hour)}:${formatter.format(value.minute)}:${formatter.format(value.hourOfPeriod)}';
        controller.text = timeFormat;
        setState(() {});
      }
    });
  }
}
