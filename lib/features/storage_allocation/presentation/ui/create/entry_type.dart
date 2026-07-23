import 'package:flutter/material.dart';

enum EntryType { storage, zone }

class EntryTypeToggle extends StatelessWidget {
  const EntryTypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final EntryType selected;
  final ValueChanged<EntryType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: 'Storage Allocation',
              isSelected: selected == EntryType.storage,
              onTap: () => onChanged(EntryType.storage),
            ),
          ),
          Expanded(
            child: _Segment(
              label: 'Zone Transfer',
              isSelected: selected == EntryType.zone,
              onTap: () => onChanged(EntryType.zone),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}