import 'package:flutter/material.dart';

/// Previous / Next controls for tables that show [pageSize] rows at a time.
class TablePageControls extends StatelessWidget {
  const TablePageControls({
    super.key,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.onPrevious,
    required this.onNext,
  });

  final int page;
  final int pageSize;
  final int totalCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  static const int defaultPageSize = 20;

  static int pageCountFor(int total, [int pageSize = defaultPageSize]) {
    if (total <= 0) return 1;
    return ((total + pageSize - 1) / pageSize).floor();
  }

  static int clampPage(int page, int total, [int pageSize = defaultPageSize]) {
    final pages = pageCountFor(total, pageSize);
    if (page < 0) return 0;
    if (page >= pages) return pages - 1;
    return page;
  }

  @override
  Widget build(BuildContext context) {
    if (totalCount <= pageSize) return const SizedBox.shrink();

    final pages = pageCountFor(totalCount, pageSize);
    final safePage = clampPage(page, totalCount, pageSize);
    final start = safePage * pageSize + 1;
    final end = ((safePage + 1) * pageSize).clamp(0, totalCount);
    final canPrev = safePage > 0;
    final canNext = safePage < pages - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: canPrev ? onPrevious : null,
            icon: const Icon(Icons.chevron_left_rounded, size: 20),
            label: const Text(
              'Previous',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$start–$end of $totalCount',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: canNext ? onNext : null,
            icon: const Icon(Icons.chevron_right_rounded, size: 20),
            label: const Text(
              'Next',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
