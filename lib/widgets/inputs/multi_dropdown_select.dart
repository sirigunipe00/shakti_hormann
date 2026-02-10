import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/app_spacer.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';

class MultiSearchDropDownList<T> extends StatefulWidget {
  const MultiSearchDropDownList({
    super.key,
    this.title,
    this.hint,
    required this.items,
    required this.onSelected,
    this.defaultSelection,
    this.readOnly = false,
    this.isRequired = false,
    required this.color,
  });

  final String? title;
  final String? hint;
  final List<T> items;
  final List<T>? defaultSelection;
  final bool readOnly;
  final bool isRequired;
  final Color color;
  final void Function(List<T> items) onSelected;

  @override
  State<MultiSearchDropDownList<T>> createState() =>
      _MultiSearchDropDownListState<T>();
}

class _MultiSearchDropDownListState<T>
    extends State<MultiSearchDropDownList<T>> {
  late List<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.defaultSelection ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnlyMode = widget.readOnly;

    final backgroundColor =
        isReadOnlyMode ? AppColors.grey.withValues(alpha: 0.20) : Colors.white;

    final borderColor =
        isReadOnlyMode
            ? Colors.grey.withValues(alpha: 0.3)
            : AppColors.grey.withValues(alpha: 0.30);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)...[
          CaptionText(
            title: widget.title!,
            color: widget.color,
            isRequired: widget.isRequired,
          ),
          AppSpacer.p4(),
        ],
        if (isReadOnlyMode)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              _selectedValues.isEmpty ? '-' : _selectedValues.join(', '),
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppColors.black,
                height: 1.4,
              ),
            ),
          )
        else
          CustomDropdown<T>.multiSelectSearch(
            items: widget.items,
            initialItems: _selectedValues,
            hintText: widget.hint,
            onListChanged: (values) {
              _selectedValues = values;
              widget.onSelected(values);
            },
            decoration: CustomDropdownDecoration(
              closedFillColor: backgroundColor,
              expandedFillColor: backgroundColor,
              closedBorderRadius: BorderRadius.circular(8.0),
              expandedBorderRadius: BorderRadius.circular(8.0),
              closedBorder: Border.all(color: borderColor, width: 1),
              expandedBorder: Border.all(color: borderColor, width: 1),
              hintStyle: context.textTheme.titleMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
      ],
    );
  }
}
