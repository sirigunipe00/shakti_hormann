import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/drop_down_optn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/data/pallet_repo.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_items.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/create_pallet_cubit.dart/create_pallet_cubit.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_size.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/dailogs/app_popup_card.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

const _ink = Color(0xFF0E1446);
const _muted = Color(0xFF6B7280);
const _accent = Color(0xFFF2A93E);
const _accentSoft = Color(0xFFFFF4E4);
const _fieldBorder = Color(0xFFD6DCE8);
const _fieldFill = Color(0xFFFBFBFD);

class PalletFormWidget extends StatefulWidget {
  const PalletFormWidget({super.key});

  @override
  State<PalletFormWidget> createState() => __PalletFormWidgetState();
}

class __PalletFormWidgetState extends State<PalletFormWidget> {
  SalesOrderForm? invoiceform;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _salesOrderSelected() {
    final fromForm =
        context.read<CreatePalletCubit>().state.form.salesOrder?.isNotEmpty ??
            false;
    return (invoiceform?.name?.isNotEmpty ?? false) || fromForm;
  }

  Future<void> _openItemDialog({
    PalletItems? existing,
    int? editIndex,
    required List<String> palletSizeNames,
    required bool readOnly,
  }) async {
    if (readOnly) return;
    if (!_salesOrderSelected()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a Sales Order before adding items'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final cubit = context.read<CreatePalletCubit>();
    final entry = await showPalletDetailsDialog(
      context,
      existingItem: existing,
      palletSizes: palletSizeNames,
      productTypes: Dropdownoptions.productType,
      isDuplicate: (item) => cubit.hasDuplicateLine(
        item,
        excludingIndex: editIndex,
      ),
    );
    if (entry == null || !mounted) return;

    if (editIndex != null) {
      cubit.updatePalletItemAt(editIndex, entry);
    } else {
      cubit.addPalletItem(entry);
    }
  }

  void _onSalesOrderSelected(SalesOrderForm selected) {
    final previous = invoiceform?.name;
    setState(() => invoiceform = selected);
    final cubit = context.cubit<CreatePalletCubit>()
      ..onValueChanged(salesOrder: selected.name);
    if (previous != null &&
        previous != selected.name &&
        cubit.state.lines.isNotEmpty) {
      cubit.resetLines();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pallet items cleared — sales order changed'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<CreatePalletCubit>().state;
    final isCompleted = formState.view == PalletView.completed;
    final lines = formState.lines;
    final newform = formState.form;
    final status = newform.docStatus;
    final readOnly = isCompleted || status == 1;
    final soLocked = status == 0 || status == 1 || readOnly;
    final hasSalesOrder =
        (invoiceform?.name?.isNotEmpty ?? false) ||
        (newform.salesOrder?.isNotEmpty ?? false);
    final canAddItems = !readOnly && hasSalesOrder;

    final palletSizeState = context.watch<PalletSizeCubit>().state;
    final palletSizeNames =
        palletSizeState
            .maybeWhen(orElse: () => <PalletSize>[], success: (data) => data)
            .map((e) => e.name)
            .whereType<String>()
            .where((n) => n.isNotEmpty)
            .toList();

    final totalPallets = newform.noofPallets ??
        lines.fold<int>(0, (sum, line) => sum + (line.noOfPallets ?? 0));

    return MultiBlocListener(
      listeners: [
        BlocListener<PalletItemCubit, PalletItemState>(
          listener: (_, state) {
            state.maybeWhen(
              orElse: () {},
              success: context.cubit<CreatePalletCubit>().addAllLines,
            );
          },
        ),
      ],
      child: ColoredBox(
        color: const Color(0xFFF7F8FA),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: ShellInsets.scrollPadding(context),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.all(5),
            defaultHeight: 0,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: SectionHeader(
                  title: 'Pallet Details',
                  assetIcon: 'assets/images/palleticon.svg',
                ),
              ),
              Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE8ECF4)),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 15, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<PalletSales, PalletSalesState>(
                        builder: (_, state) {
                          final orders = state.maybeWhen(
                            orElse: () => <SalesOrderForm>[],
                            success: (data) => data,
                          );

                          if (invoiceform == null &&
                              newform.salesOrder != null) {
                            SalesOrderForm? match;
                            for (final item in orders) {
                              if (item.name == newform.salesOrder) {
                                match = item;
                                break;
                              }
                            }
                            invoiceform = match ??
                                SalesOrderForm(name: newform.salesOrder);
                          }

                          final dropdownItems = <SalesOrderForm>[...orders];
                          if (invoiceform != null &&
                              invoiceform!.name != null &&
                              !dropdownItems.any(
                                (e) => e.name == invoiceform!.name,
                              )) {
                            dropdownItems.insert(0, invoiceform!);
                          }

                          return _SalesOrderSelectField(
                            key: ValueKey(
                              'pallet_so_${invoiceform?.name ?? 'new'}_'
                              '${soLocked ? 'locked' : 'edit'}',
                            ),
                            orders: dropdownItems,
                            selected: invoiceform,
                            isLoading: state.isLoading,
                            locked: soLocked,
                            onSelected: _onSalesOrderSelected,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        key: ValueKey('pallet_total_$totalPallets'),
                        title: 'No of Pallets',
                        hintText: 'Auto-calculated from items',
                        readOnly: true,
                        isRequired: true,
                        initialValue: totalPallets.toString(),
                        borderColor: AppColors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total updates automatically when you add or edit items.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: SectionHeader(
                        title: 'Pallet Items Details',
                        assetIcon: 'assets/images/palleticon.svg',
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (canAddItems)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkBlue.withValues(alpha: 0.22),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _openItemDialog(
                            palletSizeNames: palletSizeNames,
                            readOnly: readOnly,
                          ),
                          icon: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            'Add Item',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Urbanist',
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkBlue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 11,
                            ),
                          ),
                        ),
                      )
                    else if (!readOnly)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Select SO to add',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _PalletPreviewTable(
                  lines: lines,
                  readOnly: readOnly,
                  waitingForSalesOrder: !hasSalesOrder && !readOnly,
                  onAddTap: canAddItems
                      ? () => _openItemDialog(
                            palletSizeNames: palletSizeNames,
                            readOnly: readOnly,
                          )
                      : null,
                  onEditTap: (index) => _openItemDialog(
                    existing: lines[index],
                    editIndex: index,
                    palletSizeNames: palletSizeNames,
                    readOnly: readOnly,
                  ),
                  onDeleteTap: (index) async {
                    final confirmed = await AppDialog.confirm(
                      context,
                      title: 'Remove item?',
                      content:
                          'Remove ${lines[index].productType ?? 'this item'} '
                          '(${lines[index].size ?? '-'}) from the pallet?',
                      confirmText: 'Remove',
                      icon: Icons.delete_outline_rounded,
                      iconBackground: const Color(0xFFFEE2E2),
                      iconColor: const Color(0xFFE11D48),
                      confirmIcon: Icons.delete_rounded,
                      confirmColor: const Color(0xFFE11D48),
                    );
                    if (confirmed == true && context.mounted) {
                      context.cubit<CreatePalletCubit>().removeLineAt(index);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(
    this.text, {
    this.required = false,
    this.asteriskColor = Colors.red,
  });

  final String text;
  final bool required;
  final Color asteriskColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _ink,
          fontFamily: 'Urbanist',
        ),
        children: [
          TextSpan(text: text),
          if (required)
            TextSpan(
              text: ' *',
              style: TextStyle(color: asteriskColor, fontSize: 14),
            ),
        ],
      ),
    );
  }
}

/// Sales Order picker matching the reference: expandable search + orange radios.
class _SalesOrderSelectField extends StatefulWidget {
  const _SalesOrderSelectField({
    super.key,
    required this.orders,
    required this.onSelected,
    required this.isLoading,
    required this.locked,
    this.selected,
  });

  final List<SalesOrderForm> orders;
  final SalesOrderForm? selected;
  final ValueChanged<SalesOrderForm> onSelected;
  final bool isLoading;
  final bool locked;

  @override
  State<_SalesOrderSelectField> createState() => _SalesOrderSelectFieldState();
}

class _SalesOrderSelectFieldState extends State<_SalesOrderSelectField> {
  bool _expanded = false;
  bool _searching = false;
  late final TextEditingController _search;
  late List<SalesOrderForm> _visible;
  int _searchToken = 0;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
    _visible = widget.orders;
  }

  @override
  void didUpdateWidget(covariant _SalesOrderSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orders != widget.orders && _search.text.trim().isEmpty) {
      _visible = widget.orders;
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged(String query) async {
    final q = query.trim();
    final token = ++_searchToken;

    if (q.isEmpty) {
      setState(() {
        _visible = widget.orders;
        _searching = false;
      });
      return;
    }

    setState(() => _searching = true);
    final either =
        await $sl.get<PalletRepo>().salesOrder(search: q, limit: 40);
    if (!mounted || token != _searchToken) return;

    setState(() {
      _searching = false;
      _visible = either.fold((_) => widget.orders, (r) => r);
    });
  }

  void _toggle() {
    if (widget.locked) return;
    setState(() {
      _expanded = !_expanded;
      if (!_expanded) {
        _search.clear();
        _visible = widget.orders;
        _searching = false;
      }
    });
  }

  void _select(SalesOrderForm order) {
    widget.onSelected(order);
    setState(() {
      _expanded = false;
      _search.clear();
      _visible = widget.orders;
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.selected?.name?.isNotEmpty ?? false;
    final borderColor = _expanded
        ? const Color(0xFF9BB0D6)
        : _fieldBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(
          'Sales Order No.',
          required: true,
          asteriskColor: _accent,
        ),
        const SizedBox(height: 8),
        if (widget.isLoading && widget.orders.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _fieldBorder),
            ),
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: _expanded
                  ? [
                      BoxShadow(
                        color: const Color(0xFF0E1446).withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: widget.locked ? null : _toggle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 13,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: hasValue ? _ink : _muted,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: hasValue
                                ? Text(
                                    widget.selected!.name ?? '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: _ink,
                                      fontFamily: 'Urbanist',
                                    ),
                                  )
                                : const Text(
                                    'Select sales order',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: _muted,
                                      fontFamily: 'Urbanist',
                                    ),
                                  ),
                          ),
                          if (widget.locked)
                            const Icon(Icons.lock_outline, color: _muted, size: 18)
                          else
                            AnimatedRotation(
                              turns: _expanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 180),
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: _muted,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_expanded) ...[
                  const Divider(height: 1, color: Color(0xFFE8ECF4)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                    child: TextField(
                      controller: _search,
                      onChanged: _onSearchChanged,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search sales order',
                        hintStyle: const TextStyle(
                          color: _muted,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Urbanist',
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: _muted,
                        ),
                        suffixIcon: _search.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                ),
                                color: _muted,
                                onPressed: () {
                                  _search.clear();
                                  _onSearchChanged('');
                                },
                              ),
                        filled: true,
                        fillColor: const Color(0xFFF3F5F9),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  if (_searching)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: _visible.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'No sales orders found',
                                style: TextStyle(
                                  color: _muted,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                              itemCount: _visible.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 4),
                              itemBuilder: (context, index) {
                                final item = _visible[index];
                                final selected =
                                    item.name == widget.selected?.name;
                                final date = DFU.ddMMyyyyFromStr(
                                  item.orderDate ?? '',
                                );
                                return Material(
                                  color: selected
                                      ? _accentSoft
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => _select(item),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 140),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selected
                                              ? _accent
                                              : Colors.transparent,
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: selected
                                                  ? _accent
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: selected
                                                    ? _accent
                                                    : const Color(0xFFC5CAD3),
                                                width: 2,
                                              ),
                                            ),
                                            child: selected
                                                ? const Icon(
                                                    Icons.circle,
                                                    size: 7,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name ?? '—',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w800,
                                                    color: _ink,
                                                    fontFamily: 'Urbanist',
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if ((item.customerName
                                                            ?.isNotEmpty ??
                                                        false) ||
                                                    date.isNotEmpty) ...[
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      if (item.customerName
                                                              ?.isNotEmpty ??
                                                          false)
                                                        Flexible(
                                                          child: Text(
                                                            item.customerName!,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 11,
                                                              color: _muted,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'Urbanist',
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      if ((item.customerName
                                                                  ?.isNotEmpty ??
                                                              false) &&
                                                          date.isNotEmpty)
                                                        const Text(
                                                          '  ·  ',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: _muted,
                                                            fontFamily:
                                                                'Urbanist',
                                                          ),
                                                        ),
                                                      if (date.isNotEmpty) ...[
                                                        const Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          size: 11,
                                                          color: _muted,
                                                        ),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          date,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 11,
                                                            color: _muted,
                                                            fontFamily:
                                                                'Urbanist',
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _PalletPreviewTable extends StatelessWidget {
  const _PalletPreviewTable({
    required this.lines,
    required this.onEditTap,
    required this.onDeleteTap,
    this.onAddTap,
    this.readOnly = false,
    this.waitingForSalesOrder = false,
  });

  final List<PalletItems> lines;
  final void Function(int index) onEditTap;
  final void Function(int index) onDeleteTap;
  final VoidCallback? onAddTap;
  final bool readOnly;
  final bool waitingForSalesOrder;

  /// [# , Product, Size, Qty, Edit?, Delete?]
  static const List<int> _flexesWithActions = [2, 4, 4, 3, 2, 2];
  static const List<int> _flexesWithoutActions = [2, 5, 5, 3];
  static const Color _lineColor = Color(0xFFE6EAF2);
  static const Color _headerBlue = Color(0xFF0E2A5C);

  List<int> get _flexes =>
      readOnly ? _flexesWithoutActions : _flexesWithActions;

  @override
  Widget build(BuildContext context) {
    final headerCells = [
      'Product\nType',
      'Size (mm)',
      'No. of\nPallets',
      if (!readOnly) 'Edit',
      if (!readOnly) 'Del',
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1446).withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(cells: headerCells, isHeader: true),
          if (lines.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FB),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      waitingForSalesOrder
                          ? Icons.playlist_add_check_circle_outlined
                          : Icons.inventory_2_outlined,
                      size: 30,
                      color: const Color(0xFF6B849F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    waitingForSalesOrder
                        ? 'Select a sales order first'
                        : 'No pallet items yet',
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    waitingForSalesOrder
                        ? 'Choose an order above to add Frame, Shutter or Combo lines.'
                        : 'Add Frame, Shutter, or Combo lines with size and quantity.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 13,
                      fontFamily: 'Urbanist',
                      height: 1.35,
                    ),
                  ),
                  if (!readOnly && onAddTap != null) ...[
                    const SizedBox(height: 14),
                    TextButton.icon(
                      onPressed: onAddTap,
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text(
                        'Add first item',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.darkBlue,
                      ),
                    ),
                  ],
                ],
              ),
            )
          else
            for (var i = 0; i < lines.length; i++)
              _buildRow(
                serialNo: i + 1,
                cells: [
                  lines[i].productType.toString(),
                  lines[i].size.toString(),
                  (lines[i].noOfPallets ?? 0).toString().padLeft(2, '0'),
                  if (!readOnly) '',
                  if (!readOnly) '',
                ],
                isHeader: false,
                isLastRow: i == lines.length - 1,
                isAlt: i.isOdd,
                rowIndex: readOnly ? null : i,
              ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required List<String> cells,
    required bool isHeader,
    bool isLastRow = false,
    bool isAlt = false,
    int? rowIndex,
    int? serialNo,
  }) {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 12,
      fontFamily: 'Urbanist',
      height: 1.2,
    );
    const cellStyle = TextStyle(
      color: _ink,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    );

    return Container(
      decoration: BoxDecoration(
        color: isHeader
            ? _headerBlue
            : (isAlt ? const Color(0xFFF8FAFD) : Colors.white),
        border: isLastRow || isHeader
            ? null
            : const Border(bottom: BorderSide(color: _lineColor)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: _flexes.first,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                child: Center(
                  child: isHeader
                      ? const Text('#', style: headerStyle)
                      : Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF4FB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            serialNo!.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              color: Color(0xFF2957A4),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Container(
              width: 1,
              color: isHeader
                  ? Colors.white.withValues(alpha: 0.18)
                  : _lineColor,
            ),
            for (var col = 0; col < cells.length; col++) ...[
              Expanded(
                flex: _flexes[col + 1],
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  child: _buildCell(
                    col: col,
                    cells: cells,
                    isHeader: isHeader,
                    rowIndex: rowIndex,
                    editColIndex: cells.length - 2,
                    deleteColIndex: cells.length - 1,
                    headerStyle: headerStyle,
                    cellStyle: cellStyle,
                  ),
                ),
              ),
              if (col != cells.length - 1)
                Container(
                  width: 1,
                  color: isHeader
                      ? Colors.white.withValues(alpha: 0.18)
                      : _lineColor,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCell({
    required int col,
    required List<String> cells,
    required bool isHeader,
    required int? rowIndex,
    required int editColIndex,
    required int deleteColIndex,
    required TextStyle headerStyle,
    required TextStyle cellStyle,
  }) {
    final hasActions = !readOnly && cells.length > 3;

    if (!isHeader && hasActions && col == editColIndex) {
      return Center(
        child: _ActionIconButton(
          tooltip: 'Edit item',
          icon: Icons.edit_outlined,
          color: const Color(0xFF2957A4),
          background: const Color(0xFFE8F0FB),
          onPressed: rowIndex != null ? () => onEditTap(rowIndex) : null,
        ),
      );
    }

    if (!isHeader && hasActions && col == deleteColIndex) {
      return Center(
        child: _ActionIconButton(
          tooltip: 'Remove item',
          icon: Icons.delete_outline_rounded,
          color: const Color(0xFFD64545),
          background: const Color(0xFFFDECEC),
          onPressed: rowIndex != null ? () => onDeleteTap(rowIndex) : null,
        ),
      );
    }

    return Center(
      child: Text(
        cells[col],
        style: isHeader ? headerStyle : cellStyle,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: isHeader ? 2 : 1,
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.color,
    required this.background,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: color, size: 18),
          ),
        ),
      ),
    );
  }
}

Future<PalletItems?> showPalletDetailsDialog(
  BuildContext context, {
  PalletItems? existingItem,
  required List<String> palletSizes,
  required List<String> productTypes,
  bool Function(PalletItems item)? isDuplicate,
}) {
  return showDialog<PalletItems>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => _PalletDetailsDialog(
      existingItem: existingItem,
      palletSizes: palletSizes,
      productTypes: productTypes,
      isDuplicate: isDuplicate,
    ),
  );
}

class _PalletDetailsDialog extends StatefulWidget {
  const _PalletDetailsDialog({
    required this.palletSizes,
    required this.productTypes,
    this.existingItem,
    this.isDuplicate,
  });

  final PalletItems? existingItem;
  final List<String> palletSizes;
  final List<String> productTypes;
  final bool Function(PalletItems item)? isDuplicate;

  @override
  State<_PalletDetailsDialog> createState() => _PalletDetailsDialogState();
}

class _PalletDetailsDialogState extends State<_PalletDetailsDialog> {
  late final TextEditingController _qtyController;
  late final TextEditingController _widthController;
  late final TextEditingController _lengthController;

  String? _selectedSize;
  String? _selectedProductType;
  String? _qtyError;
  String? _sizeError;
  String? _productTypeError;

  bool get _isEdit => widget.existingItem != null;

  List<String> get _sizeOptions {
    final sizes = [...widget.palletSizes];
    if (!sizes.contains('Others')) sizes.add('Others');
    return sizes;
  }

  @override
  void initState() {
    super.initState();
    final existing = widget.existingItem;
    final existingSize = existing?.size;
    final useCustomSize = existingSize != null &&
        !widget.palletSizes.contains(existingSize);

    _selectedProductType = existing?.productType;
    _selectedSize = useCustomSize ? 'Others' : existingSize;
    _qtyController = TextEditingController(
      text: existing?.noOfPallets?.toString() ?? '',
    );

    String width = '';
    String length = '';
    if (useCustomSize) {
      final parts = existingSize.split(RegExp(r'\s*[*x×]\s*'));
      if (parts.length >= 2) {
        width = parts.first.trim();
        length = parts.last.trim();
      }
    }
    _widthController = TextEditingController(text: width);
    _lengthController = TextEditingController(text: length);
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _widthController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _productTypeError = null;
      _qtyError = null;
      _sizeError = null;
    });

    if (_selectedProductType == null || _selectedProductType!.trim().isEmpty) {
      setState(() => _productTypeError = 'Select a product type');
      return;
    }

    final qty = int.tryParse(_qtyController.text.trim());
    if (qty == null || qty <= 0) {
      setState(() => _qtyError = 'Enter a number between 1 and 100');
      return;
    }
    if (qty > 100) {
      setState(() => _qtyError = 'Cannot exceed 100 pallets');
      return;
    }

    if (_selectedSize == null || _selectedSize!.trim().isEmpty) {
      setState(() => _sizeError = 'Select a pallet size');
      return;
    }

    late final String finalSize;
    if (_selectedSize == 'Others') {
      final width = _widthController.text.trim();
      final length = _lengthController.text.trim();
      final widthN = int.tryParse(width);
      final lengthN = int.tryParse(length);
      if (width.isEmpty || length.isEmpty) {
        setState(() => _sizeError = 'Enter both width and length (mm)');
        return;
      }
      if (widthN == null || widthN <= 0 || lengthN == null || lengthN <= 0) {
        setState(() => _sizeError = 'Width and length must be positive numbers');
        return;
      }
      finalSize = '$widthN * $lengthN';
    } else {
      finalSize = _selectedSize!;
    }

    final item = PalletItems(
      productType: _selectedProductType,
      size: finalSize,
      noOfPallets: qty,
    );

    if (widget.isDuplicate?.call(item) ?? false) {
      setState(
        () => _sizeError =
            'This product type and size is already on the list',
      );
      return;
    }

    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialogShell(
      title: _isEdit ? 'Edit Pallet Item' : 'Add Pallet Item',
      subtitle: _isEdit
          ? 'Update product type, quantity, and size'
          : 'Choose product type, quantity, and pallet size',
      icon: Icons.inventory_2_outlined,
      iconBackground: const Color(0xFFE8F0FE),
      iconColor: AppColors.darkBlue,
      onClose: () => Navigator.pop(context),
      cancelText: 'Cancel',
      onCancel: () => Navigator.pop(context),
      confirmText: _isEdit ? 'Save Changes' : 'Add Item',
      confirmIcon: Icons.check_rounded,
      confirmColor: AppColors.darkBlue,
      onConfirm: _submit,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              _RefSelectField(
                label: 'Product Type',
                hint: 'Select product type',
                leadingIcon: Icons.category_outlined,
                searchIcon: Icons.inventory_2_outlined,
                options: widget.productTypes,
                value: _selectedProductType,
                errorText: _productTypeError,
                onChanged: (value) => setState(() {
                  _selectedProductType = value;
                  _productTypeError = null;
                }),
              ),
              const SizedBox(height: 14),
              const _FieldLabel('No. of Pallets', required: true),
              const SizedBox(height: 8),
              TextField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist',
                  color: _ink,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: _refFieldDecoration(
                  hint: 'e.g. 12',
                  prefixIcon: Icons.tag_rounded,
                  errorText: _qtyError,
                ),
                onChanged: (_) {
                  if (_qtyError != null) {
                    setState(() => _qtyError = null);
                  }
                },
              ),
              const SizedBox(height: 14),
              _RefSelectField(
                label: 'Pallet Size (mm)',
                hint: 'Select pallet size',
                leadingIcon: Icons.layers_outlined,
                searchIcon: Icons.straighten_rounded,
                options: _sizeOptions,
                value: _selectedSize,
                errorText: _sizeError,
                maxMenuHeight: 220,
                onChanged: (value) => setState(() {
                  _selectedSize = value;
                  _sizeError = null;
                  if (value != 'Others') {
                    _widthController.clear();
                    _lengthController.clear();
                  }
                }),
              ),
              if (_selectedSize == 'Others') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _widthController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Urbanist',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: _refFieldDecoration(hint: 'Width (mm)'),
                        onChanged: (_) {
                          if (_sizeError != null) {
                            setState(() => _sizeError = null);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _lengthController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Urbanist',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: _refFieldDecoration(hint: 'Length (mm)'),
                        onChanged: (_) {
                          if (_sizeError != null) {
                            setState(() => _sizeError = null);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
    );
  }
}

/// Compact searchable dropdown matching the Add Item reference design.
class _RefSelectField extends StatefulWidget {
  const _RefSelectField({
    required this.label,
    required this.hint,
    required this.options,
    required this.onChanged,
    required this.leadingIcon,
    required this.searchIcon,
    this.value,
    this.errorText,
    this.maxMenuHeight = 180,
  });

  final String label;
  final String hint;
  final List<String> options;
  final String? value;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final IconData leadingIcon;
  final IconData searchIcon;
  final double maxMenuHeight;

  @override
  State<_RefSelectField> createState() => _RefSelectFieldState();
}

class _RefSelectFieldState extends State<_RefSelectField> {
  bool _expanded = false;
  late final TextEditingController _search;
  late List<String> _filtered;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
    _filtered = widget.options;
  }

  @override
  void didUpdateWidget(covariant _RefSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options != widget.options) {
      _applyFilter(_search.text);
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _applyFilter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = widget.options;
      } else {
        _filtered = widget.options
            .where((e) => e.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (!_expanded) {
        _search.clear();
        _filtered = widget.options;
      }
    });
  }

  void _select(String value) {
    widget.onChanged(value);
    setState(() {
      _expanded = false;
      _search.clear();
      _filtered = widget.options;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value != null && widget.value!.isNotEmpty;
    final borderColor = widget.errorText != null
        ? Colors.red
        : (_expanded ? const Color(0xFFB8C4DE) : _fieldBorder);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(widget.label, required: true),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: _expanded
                ? [
                    BoxShadow(
                      color: const Color(0xFF0E1446).withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _toggle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 13,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.leadingIcon,
                          size: 20,
                          color: hasValue ? _ink : _muted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            hasValue ? widget.value! : widget.hint,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  hasValue ? FontWeight.w700 : FontWeight.w500,
                              color: hasValue ? _ink : _muted,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_expanded) ...[
                const Divider(height: 1, color: Color(0xFFE8ECF4)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                  child: TextField(
                    controller: _search,
                    onChanged: _applyFilter,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        color: _muted,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Urbanist',
                      ),
                      prefixIcon: Icon(
                        widget.searchIcon,
                        size: 18,
                        color: _muted,
                      ),
                      suffixIcon: _search.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              color: _muted,
                              onPressed: () {
                                _search.clear();
                                _applyFilter('');
                              },
                            ),
                      filled: true,
                      fillColor: _fieldFill,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: widget.maxMenuHeight),
                  child: _filtered.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No matches',
                            style: TextStyle(
                              color: _muted,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 4),
                          itemBuilder: (context, index) {
                            final option = _filtered[index];
                            final selected = option == widget.value;
                            return Material(
                              color: selected ? _accentSoft : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _select(option),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 11,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selected
                                              ? _accent
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: selected
                                                ? _accent
                                                : const Color(0xFFC5CAD3),
                                            width: 2,
                                          ),
                                        ),
                                        child: selected
                                            ? const Icon(
                                                Icons.circle,
                                                size: 8,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: selected
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: _ink,
                                            fontFamily: 'Urbanist',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ],
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 13),
          ),
        ],
      ],
    );
  }
}

InputDecoration _refFieldDecoration({
  required String hint,
  IconData? prefixIcon,
  String? errorText,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: _fieldBorder, width: 1.2),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontSize: 15,
      color: _muted,
      fontWeight: FontWeight.w500,
      fontFamily: 'Urbanist',
    ),
    prefixIcon: prefixIcon == null
        ? null
        : Icon(prefixIcon, size: 20, color: _muted),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: border,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFB8C4DE), width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.red, width: 1.4),
    ),
    errorText: errorText,
    errorStyle: const TextStyle(fontSize: 13),
  );
}
