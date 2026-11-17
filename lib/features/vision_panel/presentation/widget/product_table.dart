import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/create_vision_panel/create_vision_panel.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/widget/add_item_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/table_page_controls.dart';

class ProductSelectionTable extends StatefulWidget {
  const ProductSelectionTable({super.key});

  @override
  State<ProductSelectionTable> createState() => _ProductSelectionTableState();
}

class _ProductSelectionTableState extends State<ProductSelectionTable> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVisionPanelCubit, CreateVisionPanelState>(
      builder: (context, state) {
        final cubit = context.cubit<CreateVisionPanelCubit>();
        final items = state.items;
        final page = TablePageControls.clampPage(_page, items.length);
        if (page != _page) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _page = page);
          });
        }
        final start = page * TablePageControls.defaultPageSize;
        final pageItems = items
            .skip(start)
            .take(TablePageControls.defaultPageSize)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SectionHeader(
                title: 'Vision Panel Items',
                assetIcon: 'assets/images/vehicleinvoicicon.svg',
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECF4)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0E1446).withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    if (items.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No items yet. Tap Add Item to begin.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      )
                    else
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE8ECF4)),
                        ),
                        child: Table(
                          border: const TableBorder(
                            horizontalInside: BorderSide(
                              color: Color(0xFFE8ECF4),
                            ),
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(40),
                            1: FlexColumnWidth(2.2),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1.6),
                          },
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(
                                color: AppColors.darkBlue,
                              ),
                              children: [
                                _HeaderCell('#'),
                                _HeaderCell('Product Type'),
                                _HeaderCell('Boxes'),
                                _HeaderCell('Status'),
                              ],
                            ),
                            for (int index = 0; index < pageItems.length; index++)
                              TableRow(
                                decoration: BoxDecoration(
                                  color: (start + index).isEven
                                      ? Colors.white
                                      : const Color(0xFFF8FAFC),
                                ),
                                children: [
                                  _Cell(
                                    child: Text(
                                      (start + index + 1).toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF2957A4),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  _Cell(
                                    child: Text(
                                      pageItems[index].productType ?? '',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  _Cell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF4E4),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        pageItems[index].noOfBoxes?.toString() ??
                                            '—',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Color(0xFFC97800),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _Cell(
                                    child: _RowStatusCell(
                                      index: start + index,
                                      item: pageItems[index],
                                      cubit: cubit,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    TablePageControls(
                      page: page,
                      pageSize: TablePageControls.defaultPageSize,
                      totalCount: items.length,
                      onPrevious: () => setState(() => _page = page - 1),
                      onNext: () => setState(() => _page = page + 1),
                    ),
                    const SizedBox(height: 10),
                    if (state.form.docStatus != 1)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed:
                              cubit.canAddNewItem && !state.isLoading
                                  ? () => _openAddItemDialog(context, cubit)
                                  : null,
                          icon: state.isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Add Item'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.darkBlue,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openAddItemDialog(
    BuildContext context,
    CreateVisionPanelCubit cubit,
  ) async {
    final result = await showDialog<(String, int)>(
      context: context,
      builder:
          (_) => BlocProvider(
            create:
                (context) => VisionPanelBlocProvider.get().getProduct()..request(),
            child: const AddVisionItemDialog(),
          ),
    );

    if (result != null) {
      await cubit.addItemFromDialog(productType: result.$1, noOfBoxes: result.$2);
    }
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Center(child: child),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.fg,
    required this.bg,
    this.icon,
  });

  final String label;
  final Color fg;
  final Color bg;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _RowStatusCell extends StatelessWidget {
  const _RowStatusCell({
    required this.index,
    required this.item,
    required this.cubit,
  });

  final int index;
  final VisionItems item;
  final CreateVisionPanelCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = cubit.state;
    final isPrinted = item.printCheck == 1;
    final isSubmitted = state.form.docStatus == 1;
    final isFormSaved =
        state.form.name != null && state.form.name!.isNotEmpty;

    if (isSubmitted) {
      return const _StatusPill(
        label: 'Locked',
        fg: Color(0xFF64748B),
        bg: Color(0xFFF1F5F9),
      );
    }

    if (!isPrinted) {
      if (!isFormSaved) {
        return const Tooltip(
          message: 'Save the form to enable printing',
          child: _StatusPill(
            label: 'Save first',
            fg: Color(0xFF9A6700),
            bg: Color(0xFFFFF7E0),
          ),
        );
      }

      return SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed:
              state.isPrintLoading ? null : () => cubit.printItemSticker(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child:
              state.isPrintLoading
                  ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text('Print', style: TextStyle(fontSize: 11)),
        ),
      );
    }

    return const _StatusPill(
      label: 'Printed',
      fg: Color(0xFF16A34A),
      bg: Color(0xFFECFDF5),
      icon: Icons.check_circle_rounded,
    );
  }
}