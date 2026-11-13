import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/utils/responsive.dart';
import 'package:shakti_hormann/styles/app_color.dart';

mixin StatusModeSelectionMixin {
  Future<String?> showOptions(
    BuildContext context, {
    String? defaultValue,
    required PageMode2 pageMode,
  }) async {
    final filters = _filtersFor(pageMode);
    final title = _filterTitleFor(pageMode);

    // Measure from the page context (not the sheet) so shell/nav insets
    // aren't double-counted inside the modal route.
    final bottomClearance = Responsive.filterSheetAboveNav(context);

    return showModalBottomSheet<String>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      // Keep under the shell so the floating nav stays undimmed on top.
      useRootNavigator: false,
      // We pad for the floating nav ourselves; default SafeArea doubles the gap.
      useSafeArea: false,
      builder: (sheetContext) {
        // Explicit bottom align: with isScrollControlled the sheet gets tall
        // constraints and would otherwise leave the card floating mid-screen.
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomClearance),
            child: _StatusFilterSheet(
              title: title,
              filters: filters,
              initialValue: defaultValue ?? filters.first,
              resetValue: filters.contains('All') ? 'All' : filters.first,
            ),
          ),
        );
      },
    );
  }

  List<String> _filtersFor(PageMode2 pageMode) {
    switch (pageMode) {
      case PageMode2.gateentry:
      case PageMode2.gateexit:
      case PageMode2.proofOfDelivery:
      case PageMode2.gateManagement:
        return ['Draft', 'Submitted', 'All'];
      case PageMode2.palletCreation:
      case PageMode2.visionPanel:
      case PageMode2.installation:
        return ['Draft', 'Submitted', 'Cancelled', 'All'];
      case PageMode2.shutterPacking:
      case PageMode2.framePacking:
      case PageMode2.hardwarePackaging:
        return [
          'Draft',
          'Unallocated',
          'Allocated',
          'Dispatched',
          'Submitted',
          'Cancelled',
          'All',
        ];
      case PageMode2.storageAllocation:
      case PageMode2.zoneTransfer:
        return ['Completed', 'Cancelled'];
      case PageMode2.logisticRequest:
        return [
          'Transporter Confirmed',
          'Transporter Rejected',
          'Pending From Transporter',
          'Draft',
          'All',
        ];
      case PageMode2.transportConfirmation:
        return [
          'Transporter Confirmed',
          'Transporter Rejected',
          'Pending From Transporter',
          'All',
        ];
      case PageMode2.vehicleReporting:
        return ['Draft', 'Reported', 'Rejected', 'All'];
      case PageMode2.loadingConfirmation:
        return ['Reported', 'Submitted', 'All'];
    }
  }

  String _filterTitleFor(PageMode2 pageMode) {
    return switch (pageMode) {
      PageMode2.gateentry => 'Filter Gate Entries',
      PageMode2.gateexit => 'Filter Gate Exits',
      PageMode2.logisticRequest => 'Filter Logistic Requests',
      PageMode2.transportConfirmation => 'Filter Transport Confirmations',
      PageMode2.vehicleReporting => 'Filter Vehicle Reporting',
      PageMode2.loadingConfirmation => 'Filter Dispatch Loading',
      PageMode2.proofOfDelivery => 'Filter Proof Of Delivery',
      PageMode2.gateManagement => 'Filter Gate Management',
      PageMode2.storageAllocation => 'Filter Storage Allocation',
      PageMode2.zoneTransfer => 'Filter Zone Transfers',
      PageMode2.hardwarePackaging => 'Filter Hardware Packing',
      PageMode2.shutterPacking => 'Filter Shutter Packing',
      PageMode2.framePacking => 'Filter Frame Packing',
      PageMode2.palletCreation => 'Filter Pallet Creation',
      PageMode2.visionPanel => 'Filter Accessories Packing',
      PageMode2.installation => 'Filter Installation Packing',
    };
  }
}

class _StatusFilterSheet extends StatefulWidget {
  const _StatusFilterSheet({
    required this.title,
    required this.filters,
    required this.initialValue,
    required this.resetValue,
  });

  final String title;
  final List<String> filters;
  final String initialValue;
  final String resetValue;

  @override
  State<_StatusFilterSheet> createState() => _StatusFilterSheetState();
}

class _StatusFilterSheetState extends State<_StatusFilterSheet> {
  static const _accent = Color(0xFFF2A93E);
  static const _accentSoft = Color(0xFFFFF4E4);
  static const _ink = Color(0xFF0E1446);
  static const _muted = Color(0xFF6B7280);

  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.filters.contains(widget.initialValue)
        ? widget.initialValue
        : widget.filters.first;
  }

  @override
  Widget build(BuildContext context) {
    final maxListHeight = MediaQuery.sizeOf(context).height * 0.42;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A0E1446),
              blurRadius: 24,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7DCE5),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _accentSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      color: _accent,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                  Material(
                    color: const Color(0xFFF1F3F7),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => context.pop(),
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: _muted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _muted,
                  fontFamily: 'Urbanist',
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxListHeight),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.filters.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final option = widget.filters[index];
                    final selected = option == _selected;
                    return _StatusOptionTile(
                      label: option,
                      selected: selected,
                      accent: _accent,
                      accentSoft: _accentSoft,
                      ink: _ink,
                      onTap: () => setState(() => _selected = option),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  TextButton(
                    onPressed: () =>
                        setState(() => _selected = widget.resetValue),
                    style: TextButton.styleFrom(
                      foregroundColor: _accent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: () => context.pop(_selected),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.darkBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Apply Filter',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusOptionTile extends StatelessWidget {
  const _StatusOptionTile({
    required this.label,
    required this.selected,
    required this.accent,
    required this.accentSoft,
    required this.ink,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final Color accentSoft;
  final Color ink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? accentSoft : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? accent : const Color(0xFFE6EAF0),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? accent : Colors.transparent,
                  border: Border.all(
                    color: selected ? accent : const Color(0xFFC5CAD3),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.circle, size: 8, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: ink,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
