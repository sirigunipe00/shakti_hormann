import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class AppDateField extends StatefulWidget {
  const AppDateField({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.onSelected,
    this.initialDate,
    this.readOnly = false,
    this.hintText,
    this.suffixIcon = const Icon(Icons.today_rounded),
    this.isRequired = false,
    this.dateformat = 'dd-MM-yyyy',
    this.fillColor,
    this.initialValue,
  });

  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String? initialDate;
  final String dateformat;
  final bool readOnly;
  final Function(DateTime date) onSelected;
  final String? hintText;
  final Widget? suffixIcon;
  final String? initialValue;
  final Color? fillColor;
  final bool isRequired;

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    String dateToShow;

    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      dateToShow = widget.initialValue!;
    } else if (widget.initialDate != null && widget.initialDate!.isNotEmpty) {
      dateToShow = widget.initialDate!;
    } else {
      dateToShow = DFU.ddMMyyyy(DateTime.now());
    }

    controller = TextEditingController(text: dateToShow);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parts = dateToShow.split('-');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final month = int.tryParse(parts[1]) ?? 1;
        final year = int.tryParse(parts[2]) ?? 2000;
        final parsedDate = DateTime(year, month, day);
        widget.onSelected(parsedDate);
      }
    });

    controller = TextEditingController(text: dateToShow);
  }

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      defaultHeight: 4.0,
      children: [
        CaptionText(title: widget.title, isRequired: widget.isRequired),
        Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: widget.fillColor ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
            onTap: () {
           
              if (widget.readOnly) return;
              _showDatePicker();
            },
            controller: controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: context.textTheme.labelSmall?.copyWith(
                color: AppColors.grey,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w500,
              ),
              fillColor: widget.fillColor ?? Colors.grey[100],
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              suffixIcon: widget.readOnly ? null : widget.suffixIcon,
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),

            obscuringCharacter: '*',
            textInputAction: TextInputAction.done,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            textCapitalization: TextCapitalization.none,
            readOnly: true,
            autocorrect: false,
          ),
        ),
      ],
    );
  }

  void _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.startDate,
      lastDate: widget.endDate,
    );
    if (selectedDate != null) {
      final formattedDate = DFU.ddMMyyyy(selectedDate);
      setState(() {
        controller.text = formattedDate;
      });
      widget.onSelected(selectedDate);
    }
  }
}
