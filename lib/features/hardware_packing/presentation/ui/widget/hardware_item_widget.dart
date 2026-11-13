import 'package:flutter/material.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_item.dart';

class HardwareItemWidget extends StatelessWidget {
  const HardwareItemWidget({
    super.key,
    required this.items,
    required this.onDelete,
    this.isCompleted = false,
  });

  final List<HardwareItem> items;
  final ValueChanged<int> onDelete;
  final bool isCompleted;

  static const Color _lineColor = Color(0xFFE6EAF2);
  static const Color _headerColor = Color(0xFF0E2A5C);
  static const Color _ink = Color(0xFF0E1446);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1446).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _HeaderRow(),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 32,
                    color: Color(0xFF9CA3AF),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No items added yet',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Capture an MES sticker to load SAP items into this table.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ],
              ),
            )
          else
            for (var i = 0; i < items.length; i++)
              _ItemRow(
                index: items[i].slNO ?? (i + 1).toString(),
                item: items[i],
                isAlt: i.isOdd,
                isLast: i == items.length - 1,
              ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HardwareItemWidget._headerColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: const Row(
        children: [
          SizedBox(
            width: 22,
            child: _HCell('#'),
          ),
          Expanded(flex: 3, child: _HCell('SAP / Description')),
          Expanded(flex: 2, child: _HCell('MES')),
          SizedBox(width: 36, child: _HCell('Qty')),
          SizedBox(width: 32, child: _HCell('UOM')),
          SizedBox(width: 78, child: _HCell('Alloc.')),
        ],
      ),
    );
  }
}

class _HCell extends StatelessWidget {
  const _HCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 11,
        fontFamily: 'Urbanist',
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.index,
    required this.item,
    required this.isAlt,
    required this.isLast,
  });

  final String index;
  final HardwareItem item;
  final bool isAlt;
  final bool isLast;

  String get _sap =>
      item.materialCode?.trim().isNotEmpty == true
          ? item.materialCode!.trim()
          : '—';

  String get _desc =>
      item.productName?.trim().isNotEmpty == true
          ? item.productName!.trim()
          : '—';

  String get _mes =>
      item.mesNumber?.trim().isNotEmpty == true
          ? item.mesNumber!.trim()
          : '—';

  String get _qty => item.qtySticker?.toString() ?? '—';

  String get _uom =>
      item.uom?.trim().isNotEmpty == true ? item.uom!.trim() : '—';

  String get _allocation {
    final status = item.allocationStatus?.trim().isNotEmpty == true
        ? item.allocationStatus!.trim()
        : 'Unallocated';
    final zone = item.currentZone?.trim() ?? '';
    return zone.isEmpty ? status : zone;
  }

  bool get _isUnallocated {
    final s = (item.allocationStatus ?? 'Unallocated').toLowerCase();
    return s.contains('unallocated');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isAlt ? const Color(0xFFF8FAFD) : Colors.white,
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: HardwareItemWidget._lineColor),
              ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Text(
              index.padLeft(2, '0'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2957A4),
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _sap,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: HardwareItemWidget._ink,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B5563),
                      fontFamily: 'Urbanist',
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                _mes,
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: HardwareItemWidget._ink,
                  fontFamily: 'Urbanist',
                  height: 1.2,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              _qty,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: HardwareItemWidget._ink,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              _uom,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4B5563),
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          SizedBox(
            width: 78,
            child: Align(
              alignment: Alignment.center,
              child: _AllocationPill(
                label: _allocation,
                isUnallocated: _isUnallocated,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocationPill extends StatelessWidget {
  const _AllocationPill({
    required this.label,
    required this.isUnallocated,
  });

  final String label;
  final bool isUnallocated;

  @override
  Widget build(BuildContext context) {
    final bg =
        isUnallocated ? const Color(0xFFFFF4E4) : const Color(0xFFE8F8EF);
    final fg =
        isUnallocated ? const Color(0xFFC97800) : const Color(0xFF15803D);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: fg,
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }
}
