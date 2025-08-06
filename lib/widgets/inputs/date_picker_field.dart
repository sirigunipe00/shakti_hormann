import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  final Color? fillColor;
  final bool isRequired;

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  final controller = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate.containsValidValue) {
      controller.text = widget.initialDate!;
      selectedDate = DateTime.tryParse(widget.initialDate!);
    }
  }

  // final textFieldBorder = OutlineInputBorder(
  //   borderRadius: BorderRadius.circular(10.0),
  //   borderSide: const BorderSide(color: AppColors.black, width: 0.8),
  // );
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
            color: Colors.grey[100],
            // border: Border.all(color: AppColors.white),
            // boxShadow: [
            //   BoxShadow(
            //     color: borderColor ?? AppColors.white,
            //     blurRadius: 2,
            //     offset: const Offset(2, 2)
            //   ),
            // ],
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
              fillColor:  Colors.grey[100],
              filled: true,
              contentPadding: const EdgeInsets.all(16.0),
              suffixIcon: widget.suffixIcon,
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    BorderSide.none, 
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

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: widget.startDate,
      lastDate: widget.endDate,
    ).then((value) {
      if (value != null) {
        widget.onSelected(value);
        selectedDate = value;
        controller.text = DateFormat(widget.dateformat).format(value);
        setState(() {});
      }
    });
  }
}
