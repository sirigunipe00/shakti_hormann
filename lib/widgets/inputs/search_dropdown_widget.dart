import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';
import 'package:shakti_hormann/widgets/loading_indicator.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class SearchDropDownList<T> extends StatefulWidget {
  const SearchDropDownList({
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
    this.futureRequest,
    this.hintBuilder,
    this.closedFillColor,
  });

  final String? title;
  final String? hint;
  final List<T> items;
  final HintBuilder? hintBuilder;
  final HeaderBuilder<T>? headerBuilder;
  final Future<List<T>> Function(String)? futureRequest;
  final ListItemBuilder<T>? listItemBuilder;
  final T? defaultSelection;
  final bool isMandatory;
  final bool readOnly;
  final Color? closedFillColor;
  final void Function(T? item) onSelected;

  @override
  State<SearchDropDownList<T>> createState() => _SearchDropDownListState<T>();
}

class _SearchDropDownListState<T> extends State<SearchDropDownList<T>> {
  T? _selectedValue;

  @override
  Widget build(BuildContext context) {
    _selectedValue = widget.defaultSelection;

    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      defaultHeight: 6.0,
      children: [
        CaptionText(
          title: widget.title.valueOrEmpty, 
          isRequired: widget.isMandatory,
        ),
        AbsorbPointer(
          absorbing: widget.readOnly,
          child: CustomDropdown<T>.searchRequest(
            hideSelectedFieldWhenExpanded: true,
            excludeSelected: false,
            futureRequestDelay: const Duration(milliseconds: 500),
            closedHeaderPadding: const EdgeInsets.all(14.0),
            expandedHeaderPadding: const EdgeInsets.all(14.0),
            searchRequestLoadingIndicator: const LoadingIndicator(),
            decoration: CustomDropdownDecoration(
              closedBorder: Border.all(color: AppColors.green),
              expandedBorder: Border.all(color: AppColors.green),
              closedBorderRadius: BorderRadius.circular(4.0),
              expandedBorderRadius: BorderRadius.circular(4.0),
              closedFillColor: widget.closedFillColor?.withOpacity(0.5),
              hintStyle: context.textTheme.labelSmall?.copyWith(
                color: AppColors.black, 
                fontWeight: FontWeight.w500,
              ),
            ),
            hintBuilder: widget.hintBuilder,
            futureRequest: widget.futureRequest,
            hintText: widget.hint,
            items: widget.items,
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
