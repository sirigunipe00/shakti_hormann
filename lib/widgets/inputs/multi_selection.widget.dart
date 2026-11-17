import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order_form.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
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
    this.serverSearch,
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

  /// When set, typing asks this callback instead of filtering [items] only.
  /// Other screens leave it null and keep the on-device filter.
  final Future<List<T>> Function(String query)? serverSearch;
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
    _selectedValues = List<T>.from(widget.defaultSelection);
  }

  @override
  void didUpdateWidget(covariant SearchMultiDropDownList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.defaultSelection != widget.defaultSelection) {
      _selectedValues = List<T>.from(widget.defaultSelection);
    }
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
                final results = await showModalBottomSheet<List<T>>(
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return _MultiSelectSearchSheet<T>(
                      title: widget.title ?? 'Select',
                      hint: widget.hint ?? 'Search...',
                      items: widget.items,
                      initialSelected: List<T>.from(_selectedValues),
                      listItemBuilder: widget.listItemBuilder,
                      scrollController: scrollCtlr,
                      serverSearch: widget.serverSearch,
                    );
                  },
                );

                // Commit only if Done pressed
                if (results != null) {
                  setState(() {
                    _selectedValues = results;
                  });
                  widget.onSelected(_selectedValues);
                }
              },

              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(
                    color: isReadOnlyMode
                        ? borderColor
                        : const Color(0xFFD6DCE8),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: widget.isloading
                    ? const Row(
                        children: [
                          SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 20,
                            color: _selectedValues.isNotEmpty
                                ? const Color(0xFF0E1446)
                                : const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _selectedValues.isNotEmpty
                                ? Text(
                                    _selectedValues
                                        .map((e) {
                                          if (e is PurchaseOrderForm) {
                                            return e.name ?? '';
                                          }
                                          if (e is SalesOrderForm) {
                                            return e.name ?? '';
                                          }
                                          if (e is SalesInvoiceForm) {
                                            return e.name ?? '';
                                          }
                                          return e.toString();
                                        })
                                        .where((name) => name.isNotEmpty)
                                        .join(', '),
                                    style: TextStyle(
                                      color: widget.readOnly &&
                                              widget.color == Colors.white
                                          ? Colors.white
                                          : const Color(0xFF0E1446),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      fontFamily: 'Urbanist',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Text(
                                    widget.hint ?? 'Select items',
                                    style: const TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      fontFamily: 'Urbanist',
                                    ),
                                  ),
                          ),
                          if (widget.readOnly)
                            Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: widget.color == Colors.white
                                  ? Colors.white70
                                  : const Color(0xFF6B7280),
                            )
                          else
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF6B7280),
                            ),
                        ],
                      ),
              ),
            ),
          ),
          AppSpacer.p4(),
        ],
      ),
    );
  }
}

/// Owns search state so keyboard dismiss / MediaQuery rebuilds do not clear
/// the query text or reset filtered results.
class _MultiSelectSearchSheet<T> extends StatefulWidget {
  const _MultiSelectSearchSheet({
    required this.title,
    required this.hint,
    required this.items,
    required this.initialSelected,
    required this.listItemBuilder,
    required this.scrollController,
    this.serverSearch,
  });

  final String title;
  final String hint;
  final List<T> items;
  final List<T> initialSelected;
  final ListMultiItemBuilder<T>? listItemBuilder;
  final ScrollController scrollController;
  final Future<List<T>> Function(String query)? serverSearch;

  @override
  State<_MultiSelectSearchSheet<T>> createState() =>
      _MultiSelectSearchSheetState<T>();
}

class _MultiSelectSearchSheetState<T> extends State<_MultiSelectSearchSheet<T>> {
  late final TextEditingController _searchController;
  late List<T> _selected;
  late List<T> _filteredItems;
  Timer? _searchDebounce;
  int _searchToken = 0;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selected = List<T>.from(widget.initialSelected);
    _filteredItems = List<T>.from(widget.items);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String _searchBlob(T item) {
    if (item is PurchaseOrderForm) {
      return [
        item.name ?? '',
        item.supplier ?? '',
        item.supplierName ?? '',
      ].join(' ');
    }
    if (item is SalesOrderForm) {
      return [item.name ?? '', item.customerName ?? ''].join(' ');
    }
    if (item is SalesInvoiceForm) {
      return [
        item.name ?? '',
        item.customerName ?? '',
        item.vehicleNo ?? '',
      ].join(' ');
    }
    return item.toString();
  }

  String _fallbackLabel(T item) {
    if (item is PurchaseOrderForm) return item.name ?? '';
    if (item is SalesOrderForm) return item.name ?? '';
    if (item is SalesInvoiceForm) return item.name ?? '';
    return item.toString();
  }

  void _filterItems(String query) {
    final search = query.trim().toLowerCase();
    setState(() {
      _searching = false;
      if (search.isEmpty) {
        _filteredItems = List<T>.from(widget.items);
      } else {
        _filteredItems = widget.items
            .where((item) => _searchBlob(item).toLowerCase().contains(search))
            .toList();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (widget.serverSearch == null) {
      _filterItems(query);
      return;
    }

    final search = query.trim();
    _searchDebounce?.cancel();
    if (search.isEmpty) {
      _searchToken++;
      _filterItems('');
      return;
    }

    // Show whatever is already on this phone while the server answers.
    final local = widget.items
        .where((item) => _searchBlob(item).toLowerCase().contains(search.toLowerCase()))
        .toList();
    setState(() {
      _filteredItems = local;
      _searching = true;
    });

    final token = ++_searchToken;
    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final results = await widget.serverSearch!(search);
        if (!mounted || token != _searchToken) return;
        setState(() {
          _filteredItems = results;
          _searching = false;
        });
      } catch (_) {
        if (!mounted || token != _searchToken) return;
        setState(() => _searching = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = List<T>.from(_filteredItems)
      ..sort((a, b) {
        final aSelected = _selected.contains(a);
        final bSelected = _selected.contains(b);
        if (aSelected && !bSelected) return -1;
        if (!aSelected && bSelected) return 1;
        return 0;
      });

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                        color: Color(0xFF0E1446),
                      ),
                    ),
                  ),
                  Text(
                    '${_selected.length} selected',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Urbanist',
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: _onSearchChanged,
                onSubmitted: _onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: widget.hint,
                  filled: true,
                  fillColor: const Color(0xFFF8FAFD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _searching && displayItems.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : displayItems.isNotEmpty
                  ? ListView.builder(
                      controller: widget.scrollController,
                      itemCount: displayItems.length,
                      itemBuilder: (context, index) {
                        final item = displayItems[index];
                        final isSelected = _selected.contains(item);

                        return CheckboxListTile(
                          title: widget.listItemBuilder != null
                              ? widget.listItemBuilder!(
                                  context,
                                  item,
                                  index,
                                  isSelected,
                                )
                              : Text(_fallbackLabel(item)),
                          value: isSelected,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                if (!_selected.contains(item)) {
                                  _selected.add(item);
                                }
                              } else {
                                _selected.remove(item);
                              }
                            });
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, _selected),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
