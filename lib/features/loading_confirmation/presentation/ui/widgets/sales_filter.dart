import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/styles/app_color.dart';



class SalesOrderFilterButton extends StatelessWidget {
  const SalesOrderFilterButton({
    super.key,
    required this.selectedSalesOrder,
    required this.onSelect,
    required this.onClear,
  });

  final String? selectedSalesOrder;
  final ValueChanged<String> onSelect;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final bool isActive = selectedSalesOrder != null;

    return GestureDetector(
      onTap: () {

        context.read<SalesOrderList>().request();
        _showPicker(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.darkBlue : Colors.white,
          border: Border.all(
            color: isActive ? AppColors.darkBlue : Colors.grey.shade300,
            width: 1.4,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppColors.darkBlue.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_alt_rounded,
              size: 17,
              color: isActive ? Colors.white : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                isActive ? selectedSalesOrder! : 'Sales Order',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            if (isActive)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClear,
                child: const Icon(
                  Icons.cancel_rounded,
                  size: 15,
                  color: Colors.white70,
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 17,
                color: Colors.grey.shade500,
              ),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<SalesOrderList>(), 
        child: _SalesOrderPickerSheet(
          selected: selectedSalesOrder,
          onSelect: (val) {
            Navigator.pop(context);
            onSelect(val);
          },
        ),
      ),
    );
  }
}



class _SalesOrderPickerSheet extends StatefulWidget {
  const _SalesOrderPickerSheet({
    required this.selected,
    required this.onSelect,
  });

  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  State<_SalesOrderPickerSheet> createState() => _SalesOrderPickerSheetState();
}

class _SalesOrderPickerSheetState extends State<_SalesOrderPickerSheet> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag handle ──
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Header ──
              Row(
                children: [
                  const Icon(
                    Icons.filter_alt_rounded,
                    color: AppColors.darkBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Filter by Sales Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                  // ── item count badge ──
                  BlocBuilder<SalesOrderList, SalesOrderState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        success: (items) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${items.length} items',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Urbanist',
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ),
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Search field ──
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (val) {
                    setState(() {}); 
                    
                    context.read<SalesOrderList>().request(val.trim());


                  },
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Urbanist',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search sales order...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                      fontFamily: 'Urbanist',
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: Colors.grey.shade400,
                    ),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              setState(() {});
                              context.read<SalesOrderList>().request(null);
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── List ──
              Expanded(
                child: BlocBuilder<SalesOrderList, SalesOrderState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const SizedBox(),
                      

                      // ── Loading ──
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.darkBlue,
                          strokeWidth: 2,
                        ),
                      ),

                      // ── Error ──
                      failure: (msg) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline,
                                size: 40, color: Colors.grey.shade300),
                            const SizedBox(height: 8),
                            Text(
                              msg.toString() ,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Data ──
                      success: (items) {
                        if (items.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.receipt_long_outlined,
                                    size: 40, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Text(
                                  'No sales orders found',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          controller: scrollController,
                          itemCount: items.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: Colors.grey.shade100,
                          ),
                          itemBuilder: (_, i) {
                            final so = items[i];

                            final soValue = so.name;
                            final isSelected = soValue == widget.selected;

                            return GestureDetector(
                              onTap: () => widget.onSelect(soValue.toString()),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 3),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.darkBlue
                                          .withValues(alpha: 0.07)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.darkBlue
                                            .withValues(alpha: 0.3)
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // ── Icon box ──
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.darkBlue
                                            : Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.receipt_long_rounded,
                                        size: 16,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // ── SO name ──
                                    Expanded(
                                      child: Text(
                                        soValue ?? '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Urbanist',
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? AppColors.darkBlue
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),

                                    // ── Check mark ──
                                    if (isSelected)
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          color: AppColors.darkBlue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check_rounded,
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}