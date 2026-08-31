import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/drop_down_optn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_items.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/create_pallet_cubit.dart/create_pallet_cubit.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_size.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/text_styles.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/compact_listtile.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class PalletFormWidget extends StatefulWidget {
  const PalletFormWidget({super.key});

  @override
  State<PalletFormWidget> createState() => __PalletFormWidgetState();
}

class __PalletFormWidgetState extends State<PalletFormWidget> {
  SalesOrderForm? invoiceform;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  DateTime? selectedDate;

  final focusNodes = List.generate(40, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<CreatePalletCubit>().state;
    final isCompleted = formState.view == PalletView.completed;
    final lines = formState.lines;

    final newform = formState.form;
    final status = newform.docStatus;
    final palletSizeState = context.watch<PalletSizeCubit>().state;
    final palletSizeNames =
        palletSizeState
            .maybeWhen(orElse: () => <PalletSize>[], success: (data) => data)
            .map((e) => e.name)
            .whereType<String>()
            .where((n) => n.isNotEmpty)
            .toList();

    return MultiBlocListener(
      listeners: [
        BlocListener<CreatePalletCubit, CreatePalletState>(
          listenWhen: (previous, current) {
            final prevStatus = previous.error?.status;
            final currStatus = current.error?.status;
            return prevStatus != currStatus;
          },
          listener: (_, state) async {},
        ),
        BlocListener<PalletItemCubit, PalletItemState>(
          listener: (_, state) {
            state.maybeWhen(
              orElse: () {},
              success: context.cubit<CreatePalletCubit>().addAllLines,
            );
          },
        ),
      ],
      child: Container(
        color: Colors.purple.shade100.withValues(alpha: 0.15),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.all(5.0),
            defaultHeight: 0,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0,top: 0),
                child: SectionHeader(
                  title: 'Pallet Details',
                  assetIcon: 'assets/images/palleticon.svg',
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Color(0xFFE8ECF4),
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.only(
                          top: 15,
                          left: 16,
                          right: 16,
                          bottom: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<PalletSales, PalletSalesState>(
                              builder: (_, state) {
                                final allData = state.maybeWhen(
                                  orElse: () => <SalesOrderForm>[],
                                  success: (data) => data,
                                );

                                final names = allData.toList();
                                if (invoiceform == null &&
                                    newform.salesOrder != null &&
                                    names.isNotEmpty) {
                                  invoiceform = names.firstWhere(
                                    (item) => item.name == newform.salesOrder,
                                  );
                                }

                                return SearchDropDownList<SalesOrderForm>(
                                  title: 'Sales Order No.',
                                  hint: 'Select Order No',
                                  isRequired: true,
                                  key: const ValueKey('sales_order_dropdown'),
                                  color: AppColors.black,
                                  items: names,
                                  readOnly: status == 0 || status == 1,
                                  defaultSelection: invoiceform,
                                  isloading: state.isLoading,
                                  futureRequest: (query) async {
                                    if (query.isEmpty) return names;

                                    return names.where((item) {
                                      final orderNo =
                                          item.name?.toLowerCase() ?? '';
                                      final customer =
                                          item.customerName?.toLowerCase() ??
                                          '';
                                      final search = query.toLowerCase();

                                      return orderNo.contains(search) ||
                                          customer.contains(search);
                                    }).toList();
                                  },
                                  headerBuilder:
                                      (_, item, __) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                  listItemBuilder:
                                      (_, item, __, ___) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sales Order: ${item.name ?? ''}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (item.customerName != null)
                                            Text(
                                              'Customer Name : ${item.customerName}',
                                            ),
                                          Text(
                                            'Order Date: ${DFU.ddMMyyyyFromStr(item.orderDate ?? '')} ',
                                          ),
                                        ],
                                      ),
                                  onSelected: (selected) {
                                    setState(() {
                                      invoiceform = selected;
                                    });
                                    context
                                        .cubit<CreatePalletCubit>()
                                        .onValueChanged(
                                          salesOrder: selected.name,
                                        );
                                  },
                                  focusNode: FocusNode(),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            InputField(
                              title: 'No of Pallets',
                              hintText: 'pallets',
                              readOnly: true,
                              isRequired: true,
                              initialValue:
                                  newform.noofPallets?.toString() ?? '0',
                              controller: remarks,
                              borderColor: AppColors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Preview Details header + Add Item button (same row) ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: SectionHeader(
                        title: 'Pallet Items Details',
                        assetIcon: 'assets/images/palleticon.svg',
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed:
                          isCompleted
                              ? null
                              : () async {
                                final entry = await _showPalletDetailsDialog(
                                  context,
                                  null,
                                  palletSizes: palletSizeNames,
                                  productTypes: Dropdownoptions.productType,
                                );
                                if (entry == null) return;
                                context
                                    .cubit<CreatePalletCubit>()
                                    .addPalletItem(entry);
                              },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Add Item',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: _PalletPreviewTable(
                  lines: lines,
                  readOnly: status == 1,
                  onEditTap: (index) async {
                    final updated = await _showPalletDetailsDialog(
                      context,
                      lines[index].productType.toString(),
                      existingItem: lines[index],
                      palletSizes: palletSizeNames,
                      productTypes: Dropdownoptions.productType,
                    );
                    if (updated != null) {
                      context.cubit<CreatePalletCubit>().updatePalletItemAt(
                        index,
                        updated,
                      );
                    }
                  },
                  onDeleteTap: (index) async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder:
                          (dialogContext) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Delete Item'),
                            content: const Text(
                              'Are you sure you want to remove this item?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.pop(dialogContext, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.pop(dialogContext, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );
                    if (confirmed == true) {
                      context.cubit<CreatePalletCubit>().removeLineAt(index);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PalletPreviewTable extends StatelessWidget {
  const _PalletPreviewTable({
    required this.lines,
    required this.onEditTap,
    required this.onDeleteTap,
    this.readOnly = false,
  });

  final List<PalletItems> lines;
  final void Function(int index) onEditTap;
  final void Function(int index) onDeleteTap;
  final bool readOnly;

  static const List<int> _flexesWithActions = [1, 3, 4, 3, 2, 3];
  static const List<int> _flexesWithoutActions = [2, 4, 3, 3];
  static const Color _lineColor = Color(0xFFE8ECF4);

  List<int> get _flexes =>
      readOnly ? _flexesWithoutActions : _flexesWithActions;

  @override
  Widget build(BuildContext context) {
    final headerCells = [
      '#',
      'Product\nType',
      'Size (mm)',
      'No. of\nPallets',
      if (!readOnly) 'Edit',
      if (!readOnly) 'Delete',
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _lineColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(cells: headerCells, isHeader: true),
          if (lines.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No items added yet',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
              ),
            )
          else
            for (var i = 0; i < lines.length; i++)
              _buildRow(
                cells: [
                  (i + 1).toString().padLeft(2, '0'),
                  lines[i].productType.toString(),
                  lines[i].size.toString(),
                  // '${lines[i].size}',
                  lines[i].noOfPallets.toString().padLeft(2, '0'),
                  if (!readOnly) '',
                  if (!readOnly) '',
                ],
                isHeader: false,
                isLastRow: i == lines.length - 1,
                rowIndex: readOnly ? null : i,
              ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required List<String> cells,
    required bool isHeader,
    bool isLastRow = false,
    int? rowIndex,
  }) {
    final headerStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 13,
    );
    const cellStyle = TextStyle(color: Colors.black87, fontSize: 13);

    final editColIndex = cells.length - 2;
    final deleteColIndex = cells.length - 1;

    return Container(
      decoration: BoxDecoration(
        color: isHeader ? AppColors.darkBlue : Colors.white,
        border:
            isLastRow
                ? null
                : const Border(bottom: BorderSide(color: _lineColor, width: 1)),
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
                    horizontal: 5,
                    vertical: 10                                                      ,
                  ),
                  child: _buildCell(
                    col: col,
                    cells: cells,
                    isHeader: isHeader,
                    rowIndex: rowIndex,
                    editColIndex: editColIndex,
                    deleteColIndex: deleteColIndex,
                    headerStyle: headerStyle,
                    cellStyle: cellStyle,
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

  Widget _buildCell({
    required int col,
    required List<String> cells,
    required bool isHeader,
    required int? rowIndex,
    required int editColIndex,
    required int deleteColIndex,
    required TextStyle headerStyle,
    required TextStyle cellStyle,
  }) {
    final hasActions = cells.length > 4;

    if (!isHeader && hasActions && col == editColIndex) {
      return Center(
        child: GestureDetector(
          onTap: rowIndex != null ? () => onEditTap(rowIndex) : null,
          child: const Icon(Icons.edit, color: Colors.blue, size: 20),
        ),
      );
    }

    if (!isHeader && hasActions && col == deleteColIndex) {
      return Center(
        child: GestureDetector(
          onTap: rowIndex != null ? () => onDeleteTap(rowIndex) : null,
          child: const Icon(Icons.delete, color: Colors.red, size: 20),
        ),
      );
    }

    return Text(
      cells[col],
      style: isHeader ? headerStyle : cellStyle,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }
}

InputDecoration _greyFieldDecoration({
  required String hint,
  String? errorText,
}) {
  final greyBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey.shade400),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 16),
    filled: true,
    fillColor: const Color(0xFFF5F6FA),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    border: greyBorder,
    enabledBorder: greyBorder,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red),
    ),
    errorStyle: const TextStyle(fontSize: 13),
    errorText: errorText,
  );
}

Future<PalletItems?> _showPalletDetailsDialog(
  BuildContext context,
  String? productType, {
  PalletItems? existingItem,
  required List<String> palletSizes,
  required List<String> productTypes,
}) {
  final palletNoController = TextEditingController(
    text: existingItem?.noOfPallets.toString() ?? '',
  );
  final existingSize = existingItem?.size;
  final isExistingOthers =
      existingSize != null && !palletSizes.contains(existingSize);

  String? selectedSize = isExistingOthers ? 'Others' : existingSize;
  String? selectedProductType = existingItem?.productType ?? productType;

  final widthController = TextEditingController(
    text: isExistingOthers ? existingSize.split('*').first.trim() : '',
  );
  final lengthController = TextEditingController(
    text: isExistingOthers ? existingSize.split('*').last.trim() : '',
  );

  String? errorText;
  String? sizeErrorText;
  String? productTypeErrorText;

  final allSizeOptions = [...palletSizes, 'Others'];

  return showDialog<PalletItems>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedProductType != null
                          ? '$selectedProductType Selected'
                          : 'Add Item',
                      style: TextStyles.titleSmall(context, size: 22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add below details to continue',
                      style: TextStyles.labelMedium(
                        context,
                      )?.copyWith(fontSize: 15, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 20),
                    SearchDropDownList<String>(
                      title: 'Product Type',
                      hint: 'Search product type',
                      isRequired: true,
                      color: AppColors.black,
                      items: productTypes,
                      defaultSelection: selectedProductType,
                      headerBuilder:
                          (_, item, __) => Text(
                            item,
                            style:
                                TextStyles.labelMedium(context)?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ) ??
                                const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                      listItemBuilder:
                          (_, item, __, ___) => CompactListTile(title: item),
                      futureRequest: (searchText) async {
                        if (searchText.trim().isEmpty) return productTypes;
                        final q = searchText.trim().toLowerCase();
                        return productTypes
                            .where((item) => item.toLowerCase().contains(q))
                            .toList();
                      },
                      onSelected: (selected) {
                        setDialogState(() {
                          selectedProductType = selected;
                          productTypeErrorText = null;
                        });
                      },
                      focusNode: FocusNode(),
                    ),
                    if (productTypeErrorText != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        productTypeErrorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style:
                              TextStyles.labelLarge(context)?.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ) ??
                              const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                          children: const [
                            TextSpan(text: 'No. Of Pallet '),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: palletNoController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 18),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: _greyFieldDecoration(
                        hint: 'Enter Pallet no.',
                        errorText: errorText,
                      ),
                      onChanged: (_) {
                        if (errorText != null) {
                          setDialogState(() => errorText = null);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    SearchDropDownList<String>(
                      title: 'Pallet Size (mm)',
                      hint: 'Search pallet size',
                      isRequired: true,
                      color: AppColors.black,
                      items: allSizeOptions,
                      defaultSelection: selectedSize,
                      headerBuilder:
                          (_, item, __) => Text(
                            item,
                            style:
                                TextStyles.labelMedium(context)?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ) ??
                                const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                      listItemBuilder:
                          (_, item, __, ___) => CompactListTile(title: item),
                      futureRequest: (searchText) async {
                        if (searchText.trim().isEmpty) return allSizeOptions;
                        final q = searchText.trim().toLowerCase();
                        return allSizeOptions
                            .where((item) => item.toLowerCase().contains(q))
                            .toList();
                      },
                      onSelected: (selected) {
                        setDialogState(() {
                          selectedSize = selected;
                          sizeErrorText = null;
                          if (selected != 'Others') {
                            widthController.clear();
                            lengthController.clear();
                          }
                        });
                      },
                      focusNode: FocusNode(),
                    ),
                    if (selectedSize == 'Others') ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: widthController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 18),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: _greyFieldDecoration(hint: 'Width'),
                              onChanged: (_) {
                                if (sizeErrorText != null) {
                                  setDialogState(() => sizeErrorText = null);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: lengthController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 18),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: _greyFieldDecoration(hint: 'Length'),
                              onChanged: (_) {
                                if (sizeErrorText != null) {
                                  setDialogState(() => sizeErrorText = null);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      if (sizeErrorText != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          sizeErrorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedSize != null
                                  ? AppColors.darkBlue
                                  : Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          if (selectedProductType == null) {
                            setDialogState(
                              () =>
                                  productTypeErrorText =
                                      'Please select product type',
                            );
                            return;
                          }
                          final noOfPallets = int.tryParse(
                            palletNoController.text.trim(),
                          );
                          if (noOfPallets == null || noOfPallets <= 0) {
                            setDialogState(
                              () => errorText = 'Enter a valid pallet number',
                            );
                            return;
                          }
                          if (noOfPallets > 100) {
                            setDialogState(
                              () =>
                                  errorText = 'Pallet number cannot exceed 100',
                            );
                            return;
                          }
                          if (selectedSize == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select pallet size'),
                              ),
                            );
                            return;
                          }
                          String finalSize;
                          if (selectedSize == 'Others') {
                            final width = widthController.text.trim();
                            final length = lengthController.text.trim();
                            if (width.isEmpty || length.isEmpty) {
                              setDialogState(
                                () =>
                                    sizeErrorText =
                                        'Enter both width and length',
                              );
                              return;
                            }
                            finalSize = '$width * $length';
                          } else {
                            finalSize = selectedSize!;
                          }

                          Navigator.pop(
                            dialogContext,
                            PalletItems(
                              productType: selectedProductType!,
                              size: finalSize,
                              noOfPallets: noOfPallets,
                            ),
                          );
                        },
                        child: Text(
                          'Continue',
                          style: TextStyles.btnTextStyle(context).copyWith(
                            color:
                                selectedSize != null
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
