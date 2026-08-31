import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/create_vision_panel/create_vision_panel.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/widget/add_item_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';

class ProductSelectionTable extends StatelessWidget {
  const ProductSelectionTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVisionPanelCubit, CreateVisionPanelState>(
      builder: (context, state) {
        final cubit = context.cubit<CreateVisionPanelCubit>();
        final items = state.items;

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
            Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Table(
                        border: TableBorder(
                          horizontalInside:
                              BorderSide(color: Colors.grey.shade300),
                          verticalInside:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                        columnWidths: const {
                          0: FixedColumnWidth(44),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1.4),
                          3: FlexColumnWidth(1.8),
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
                          for (int index = 0; index < items.length; index++)
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F4F8),
                              ),
                              children: [
                                _Cell(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkBlue,
                                    ),
                                  ),
                                ),
                                _Cell(
                                  child: Text(
                                    items[index].productType ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                _Cell(
                                  child: Text(
                                    items[index].noOfBoxes?.toString() ?? '',
                                  ),
                                ),
                                _Cell(
                                  child: _RowStatusCell(
                                    index: index,
                                    item: items[index],
                                    cubit: cubit,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (state.form.docStatus != 1)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
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
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.add),
                          label: const Text('Add Item'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkBlue,
                            foregroundColor: Colors.white,
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
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Center(child: child),
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
      return const Text(
        'Locked',
        style: TextStyle(fontSize: 11, color: Colors.grey),
      );
    }

    if (!isPrinted) {
      if (!isFormSaved) {
        return const Tooltip(
          message: 'Save the form to enable printing',
          child: Text(
            'Save first',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        );
      }

      return SizedBox(
        height: 34,
        child: ElevatedButton(
          onPressed:
              state.isPrintLoading ? null : () => cubit.printItemSticker(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child:
              state.isPrintLoading
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text('Print', style: TextStyle(fontSize: 12)),
        ),
      );
    }

    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 16),
        SizedBox(width: 4),
        Text(
          'Printed',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}