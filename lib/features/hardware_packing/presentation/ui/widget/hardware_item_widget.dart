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

  static const List<int> _flexes = [1, 2, 4, 3, 2, 2];
  static const Color _lineColor = Color(0xFFE2E8F0);
  static const Color _headerColor = Color(0xFF1A3C6B);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(
            cells: const [
              '#',
              'SAP Code',
              'Description',
              'MES Sticker',
              'Qty',
              'UOM',
            ],
            isHeader: true,
          ),
          if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: Text(
                  'No items added yet',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            for (var i = 0; i < items.length; i++)
              _buildRow(
                cells: [
                  items[i].slNO ?? (i + 1).toString(),
                  items[i].materialCode.toString(),
                  items[i].productName.toString(),
                  items[i].mesNumber ?? '—',
                  items[i].qtySticker.toString(),
                  items[i].uom.toString(),
                ],
                isHeader: false,
                isLastRow: i == items.length - 1,
              ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required List<String> cells,
    required bool isHeader,
    bool isLastRow = false,
  }) {
    final headerStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 13,
      fontFamily: 'Urbanist',
    );
    const cellStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Color(0xFF1E293B),
    );

    return Container(
      decoration: BoxDecoration(
        color: isHeader ? _headerColor : Colors.white,
        border:
            isLastRow
                ? null
                : const Border(
                  bottom: BorderSide(color: _lineColor, width: 1),
                ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var col = 0; col < cells.length; col++) ...[
              Expanded(
                flex: _flexes[col],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Text(
                    cells[col],
                    style: isHeader ? headerStyle : cellStyle,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              if (col != cells.length - 1)
                Container(width: 1, color: _lineColor),
            ],
          ],
        ),
      ),
    );
  }
}