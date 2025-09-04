import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order_form.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/app_spacer.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';

class SearchMultiDropDownList<T> extends StatefulWidget {
  const SearchMultiDropDownList({
    super.key,
    this.title,
    this.hint,
    required this.items,
    required this.onSelected,
    this.defaultSelection = const [],
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
  final ListMultiItemBuilder<T>? listItemBuilder;
  final HintBuilder? hintBuilder;
  final Future<List<T>> Function(String)? futureRequest;
  final List<T> defaultSelection;
  final bool isMandatory;
  final bool readOnly;
  final bool isloading;
  final Color color;
  final Color? closedFillColor;
  final void Function(List<T> items) onSelected;
  final FocusNode? focusNode;

  @override
  State<SearchMultiDropDownList<T>> createState() =>
      _SearchMultiDropDownListState<T>();
}

class _SearchMultiDropDownListState<T>
    extends State<SearchMultiDropDownList<T>> {
  late List<T> _selectedValues;
  late List<T> selectedValues;
  final scrollCtlr = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.defaultSelection;
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
            child: GestureDetector(
              onTap: () async {
                // make a local copy, so edits don’t affect parent state until confirmed
                final tempSelected = List<T>.from(_selectedValues);

                final results = await showModalBottomSheet<List<T>>(
                  context: context,
                  builder: (context) {
                    final availableItems = widget.items;

                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: availableItems.length,
                                itemBuilder: (context, index) {
                                  final item = availableItems[index];
                                  final isSelected = tempSelected.contains(
                                    item,
                                  );

                                  return CheckboxListTile(
                                    title:
                                        widget.listItemBuilder != null
                                            ? widget.listItemBuilder!(
                                              context,
                                              item,
                                              index,
                                              isSelected,
                                            )
                                            : Text(item.toString()),
                                    value: isSelected,
                                    onChanged: (checked) {
                                      setModalState(() {
                                        if (checked == true) {
                                          tempSelected.add(item);
                                        } else {
                                          tempSelected.remove(item);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  tempSelected,
                                ); // ✅ only commit on Done
                              },
                              child: const Text('Done'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );

                // ✅ commit only if Done pressed
                if (results != null) {
                  setState(() {
                    _selectedValues = results;
                  });
                  widget.onSelected(_selectedValues);
                }
              },

              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: borderColor, width: 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:
                    _selectedValues.isNotEmpty
                        ? Text(
                          _selectedValues
                              .map((e) {
                                if (e is PurchaseOrderForm) {
                                  return e.name ?? '';
                                }
                                return e.toString();
                              })
                              .where((name) => name.isNotEmpty)
                              .join(', '),
                          style: context.textTheme.titleMedium?.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Urbanist',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                        : Text(
                          widget.hint ?? 'Select items',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: AppColors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Urbanist',
                          ),
                        ),

                // Wrap(
                //   spacing: 8,
                //   children:
                //       _selectedValues.isNotEmpty
                //           ? _selectedValues
                //               .map((e) => Chip(label: Text(e.toString())))
                //               .toList()
                //           : [
                //             Text(
                //               widget.hint ?? "Select items",
                //               style: context.textTheme.titleMedium?.copyWith(
                //                 color: AppColors.black,
                //                 fontWeight: FontWeight.w600,
                //                 fontFamily: 'Urbanist',
                //               ),
                //             ),
                //           ],
                // ),
              ),
            ),
          ),
          AppSpacer.p4(),
        ],
      ),
    );
  }
}