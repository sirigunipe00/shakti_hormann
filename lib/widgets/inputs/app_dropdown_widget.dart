import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';


class AppDropDown<T> extends StatefulWidget {
  const AppDropDown({
    super.key,
    this.title,
    this.hint,
    required this.items,
    required this.onSelected,
    this.defaultSelection,
    this.isMandatory = false,
    this.readOnly = false,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.closedFillColor,
    this.titleColor,
  });

  final String? title;
  final String? hint;
  final List<T> items;
  final HeaderBuilder<T>? headerBuilder;
  final Widget Function(BuildContext, T, bool, void Function())?
      listItemBuilder;
  final T? defaultSelection;
  final bool isMandatory;
  final bool readOnly;
  final Function(T?)? onSelected;
  final HintBuilder? hintBuilder;
  final Color? closedFillColor;
  final Color? titleColor;
  @override
  State<AppDropDown<T>> createState() => _AppDropDownState<T>();
}

class _AppDropDownState<T> extends State<AppDropDown<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.defaultSelection;
  }

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      defaultHeight: 6.0,
      children: [
        if(widget.title.containsValidValue)...[
          CaptionText(
            title: widget.title.valueOrEmpty, 
            isRequired: widget.isMandatory,
            color: widget.titleColor ?? AppColors.black,
          ),
        ],
        AbsorbPointer(
          absorbing: widget.readOnly,
          child: CustomDropdown<T>(
            hideSelectedFieldWhenExpanded: true,
            excludeSelected: false,
            closedHeaderPadding: const EdgeInsets.all(10.0),
            expandedHeaderPadding: const EdgeInsets.all(10.0),
            decoration: CustomDropdownDecoration(
              closedBorderRadius: BorderRadius.circular(4.0),
              expandedBorderRadius: BorderRadius.circular(4.0),
              closedBorder: Border.all(color: AppColors.green),
              closedFillColor: widget.closedFillColor?.withOpacity(0.5),
              expandedBorder: Border.all(color: AppColors.green),
              hintStyle: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.black, fontWeight: FontWeight.w500),
            ),
            items: widget.items,
            hintText: widget.hint ?? 'Select ${widget.title}'.replaceAll(':', ''),
            hintBuilder: widget.hintBuilder,
            headerBuilder: widget.headerBuilder,
            listItemBuilder: widget.listItemBuilder,
            onChanged: widget.onSelected,
            initialItem: _selectedValue,
          ),
        ),
      ],
    );
  }
}
