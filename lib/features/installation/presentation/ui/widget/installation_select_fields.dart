import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/data/pallet_repo.dart';

const _ink = Color(0xFF0E1446);
const _muted = Color(0xFF6B7280);
const _accent = Color(0xFFF2A93E);
const _accentSoft = Color(0xFFFFF4E4);
const _fieldBorder = Color(0xFFD6DCE8);

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: _ink,
          fontFamily: 'Urbanist',
        ),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: _accent, fontSize: 13),
            ),
        ],
      ),
    );
  }
}

/// Compact expandable Sales Order picker (server search + customer · date).
class InstallationSalesOrderSelect extends StatefulWidget {
  const InstallationSalesOrderSelect({
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
  State<InstallationSalesOrderSelect> createState() =>
      _InstallationSalesOrderSelectState();
}

class _InstallationSalesOrderSelectState
    extends State<InstallationSalesOrderSelect> {
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
  void didUpdateWidget(covariant InstallationSalesOrderSelect oldWidget) {
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
    final borderColor =
        _expanded ? const Color(0xFF9BB0D6) : _fieldBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Sales Order No.', required: true),
        const SizedBox(height: 6),
        if (widget.isLoading && widget.orders.isEmpty)
          _loadingBox()
        else
          _shell(
            borderColor: borderColor,
            expanded: _expanded,
            child: Column(
              children: [
                _headerTap(
                  locked: widget.locked,
                  onTap: _toggle,
                  leading: Icons.search_rounded,
                  title: hasValue
                      ? (widget.selected!.name ?? '')
                      : 'Select sales order',
                  hasValue: hasValue,
                ),
                if (_expanded) ...[
                  const Divider(height: 1, color: Color(0xFFE8ECF4)),
                  _searchField(
                    controller: _search,
                    hint: 'Search sales order',
                    onChanged: _onSearchChanged,
                    onClear: () {
                      _search.clear();
                      _onSearchChanged('');
                    },
                  ),
                  if (_searching)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  else
                    _ordersList(),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _ordersList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 240),
      child: _visible.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'No sales orders found',
                style: TextStyle(color: _muted, fontFamily: 'Urbanist'),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              itemCount: _visible.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = _visible[index];
                final selected = item.name == widget.selected?.name;
                final date = DFU.ddMMyyyyFromStr(item.orderDate ?? '');
                final customer = item.customerName?.trim() ?? '';

                return _RadioOption(
                  selected: selected,
                  onTap: () => _select(item),
                  title: item.name ?? '—',
                  subtitle: [
                    if (customer.isNotEmpty) customer,
                    if (date.isNotEmpty) date,
                  ].join('  ·  '),
                );
              },
            ),
    );
  }
}

Widget _loadingBox() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _fieldBorder),
    ),
    child: const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );
}

Widget _shell({
  required Color borderColor,
  required bool expanded,
  required Widget child,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 180),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: borderColor, width: 1.2),
      boxShadow: expanded
          ? [
              BoxShadow(
                color: const Color(0xFF0E1446).withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ]
          : null,
    ),
    child: child,
  );
}

Widget _headerTap({
  required bool locked,
  required VoidCallback onTap,
  required IconData leading,
  required String title,
  required bool hasValue,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: locked ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(leading, size: 18, color: hasValue ? _ink : _muted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: hasValue ? FontWeight.w700 : FontWeight.w500,
                  color: hasValue ? _ink : _muted,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            if (locked)
              const Icon(Icons.lock_outline, color: _muted, size: 16)
            else
              const Icon(Icons.keyboard_arrow_down_rounded, color: _muted),
          ],
        ),
      ),
    ),
  );
}

Widget _searchField({
  required TextEditingController controller,
  required String hint,
  required ValueChanged<String> onChanged,
  required VoidCallback onClear,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
    child: TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 13,
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: _muted,
          fontWeight: FontWeight.w500,
          fontFamily: 'Urbanist',
        ),
        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: _muted),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded, size: 16),
                color: _muted,
                onPressed: onClear,
              ),
        filled: true,
        fillColor: const Color(0xFFF3F5F9),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

class _RadioOption extends StatelessWidget {
  const _RadioOption({
    required this.selected,
    required this.onTap,
    required this.title,
    this.subtitle,
  });

  final bool selected;
  final VoidCallback onTap;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _accentSoft : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? _accent : Colors.transparent,
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
                  color: selected ? _accent : Colors.transparent,
                  border: Border.all(
                    color: selected ? _accent : const Color(0xFFC5CAD3),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.circle, size: 7, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _muted,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Urbanist',
                        ),
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
  }
}
