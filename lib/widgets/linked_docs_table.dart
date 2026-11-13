import 'package:flutter/material.dart';

const _ink = Color(0xFF0E1446);
const _muted = Color(0xFF6B7280);
const _lineColor = Color(0xFFE6EAF2);
const _headerBlue = Color(0xFF0E2A5C);

/// Compact always-visible linked-document table (PO / Invoice / SO names).
class LinkedDocsTable extends StatelessWidget {
  const LinkedDocsTable({
    super.key,
    required this.headerTitle,
    required this.docs,
    this.emptyLabel = 'No linked documents',
  });

  final String headerTitle;
  final List<String> docs;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final items = docs.where((e) => e.trim().isNotEmpty).toList();

    return Container(
      width: double.infinity,
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
          _row(
            isHeader: true,
            isLast: false,
            isAlt: false,
            label: headerTitle,
            serial: null,
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 28,
                    color: Color(0xFF6B849F),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    emptyLabel,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ],
              ),
            )
          else
            for (var i = 0; i < items.length; i++)
              _row(
                isHeader: false,
                isLast: i == items.length - 1,
                isAlt: i.isOdd,
                serial: i + 1,
                label: items[i],
              ),
        ],
      ),
    );
  }

  Widget _row({
    required bool isHeader,
    required bool isLast,
    required bool isAlt,
    required String label,
    required int? serial,
  }) {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 12,
      fontFamily: 'Urbanist',
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
        border: isLast || isHeader
            ? null
            : const Border(bottom: BorderSide(color: _lineColor)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 48,
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
                          serial!.toString().padLeft(2, '0'),
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
            Container(
              width: 1,
              color: isHeader
                  ? Colors.white.withValues(alpha: 0.18)
                  : _lineColor,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: isHeader ? headerStyle : cellStyle,
                  ),
                ),
              ),
            ),
            if (!isHeader) ...[
              Container(width: 1, color: _lineColor),
              const SizedBox(
                width: 36,
                child: Center(
                  child: Icon(Icons.lock_outline, size: 14, color: _muted),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
