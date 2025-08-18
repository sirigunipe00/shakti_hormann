import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/app_spacer.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';

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
    this.isloading = false,
    this.listItemBuilder,
    this.headerBuilder,
    this.futureRequest,
    this.fontSize,
    this.hintBuilder,
    this.closedFillColor,
    this.focusNode,
    required this.color,
  });

  final String? title;
  final String? hint;
  final double? fontSize;
  final List<T> items;
  final HeaderBuilder<T>? headerBuilder;
  final ListItemBuilder<T>? listItemBuilder;
  final HintBuilder? hintBuilder;
  final Future<List<T>> Function(String)? futureRequest;
  final T? defaultSelection;
  final bool isMandatory;
  final bool readOnly;
  final bool isloading;
  final Color color;
  final Color? closedFillColor;
  final void Function(T item) onSelected;
  final FocusNode? focusNode;

  @override
  State<SearchDropDownList<T>> createState() => _SearchDropDownListState<T>();
}

class _SearchDropDownListState<T> extends State<SearchDropDownList<T>> {
  T? _selectedValue;
  final scrollCtlr = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.defaultSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title?.isNotEmpty == true) ...[
            CaptionText(
              title: widget.title ?? '',

              color: widget.color,
              isRequired: widget.isMandatory,
            ),
            AppSpacer.p4(),
          ],
          AbsorbPointer(
            absorbing: widget.readOnly || widget.isloading,
            child: CustomDropdown<T>.searchRequest(
              hideSelectedFieldWhenExpanded: true,
              excludeSelected: false,
              closedHeaderPadding: const EdgeInsets.all(16.0),
              expandedHeaderPadding: const EdgeInsets.all(16.0),
              decoration: CustomDropdownDecoration(
                closedFillColor: Colors.grey.shade100,
                expandedFillColor: Colors.grey.shade100,
                // closedBorder: InputBorder.none,
                // expandedBorder: InputBorder.none,
                closedBorderRadius: BorderRadius.circular(8.0),
                expandedBorderRadius: BorderRadius.circular(8.0),
                hintStyle: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist',
                ),
              ),
              listItemPadding: const EdgeInsets.all(4.0),
              hintBuilder: widget.hintBuilder,
              futureRequest: widget.futureRequest,
              hintText: widget.hint,
              
              items: widget.items,
              headerBuilder: widget.headerBuilder,
              listItemBuilder: widget.listItemBuilder,
              onChanged: (value) {
                if (value != null) {
                  widget.onSelected(value);
                }
              },
              initialItem: _selectedValue,
            ),
          ),
          AppSpacer.p4(),
        ],
      ),
    );
  }
}
