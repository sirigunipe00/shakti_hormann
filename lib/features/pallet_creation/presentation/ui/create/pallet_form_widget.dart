import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/drop_down_optn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_items.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/create_pallet_cubit.dart/create_pallet_cubit.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_size.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/styles/app_color.dart';
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

  int _productTypeResetKey = 0;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  DateTime? selectedDate;

  final focusNodes = List.generate(40, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    $logger.devLog('selected date.....$selectedDate');
    final formState = context.watch<CreatePalletCubit>().state;
    final isCompleted = formState.view == PalletView.completed;
    final lines = formState.lines;

    final newform = formState.form;
    final status = newform.docStatus;
    // final salesOrders = newform.salesOrder ?? [];
    $logger.devLog('oredrform.....$newform');
    final palletSizeState = context.watch<PalletSizeCubit>().state;
    final palletSizeNames =
        palletSizeState
            .maybeWhen(orElse: () => <PalletSize>[], success: (data) => data)
            .map((e) => e.name)
            .whereType<String>()
            .where((n) => n.isNotEmpty)
            .toList();
    $logger.devLog('resolved pallet size names.....$palletSizeNames');

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
            margin: const EdgeInsets.all(12.0),
            defaultHeight: 0,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Pallet Details',
                  assetIcon: 'assets/images/palleticon.svg',
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(2),
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
                                  invoiceform = names.firstWhereOrNull(
                                    (item) => item.name == newform.salesOrder,
                                  );
                                }

                                return SearchDropDownList<SalesOrderForm>(
                                  title: 'Sales Order No.',
                                  hint: 'Select Order No',
                                  key: const ValueKey('sales_order_dropdown'),
                                  color: AppColors.black,
                                  items: names,
                                  readOnly: status == 1,
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
                                            'Invoice No: ${item.name ?? ''}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
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
                            SearchDropDownList<String>(
                              title: 'Product Type',
                              hint: 'Select Product Type',
                              isRequired: true,
                              readOnly: isCompleted,
                              key: ValueKey(
                                _productTypeResetKey,
                              ), // resets selection after each add
                              color: AppColors.black,
                              items: Dropdownoptions.productType,
                              defaultSelection: null,
                              headerBuilder: (_, item, __) => Text(item),
                              listItemBuilder:
                                  (_, item, __, ___) =>
                                      CompactListTile(title: item),
                              futureRequest: (searchText) async {
                                final all = Dropdownoptions.productType;
                                if (searchText.trim().isEmpty) return all;
                                return all
                                    .where(
                                      (item) => item.toLowerCase().contains(
                                        searchText.trim().toLowerCase(),
                                      ),
                                    )
                                    .toList();
                              },
                              onSelected: (selected) async {
                                final entry = await _showPalletDetailsDialog(
                                  context,
                                  selected,
                                  palletSizes: palletSizeNames,
                                );
                                if (entry == null) return;
                                context
                                    .cubit<CreatePalletCubit>()
                                    .addPalletItem(entry);
                                setState(() => _productTypeResetKey++);
                              },
                              focusNode: focusNodes.elementAt(5),
                            ),
                            const SizedBox(height: 12),
                            InputField(
                              title: 'No of Pallets',
                              hintText: 'pallets',
                              readOnly: true,
                              initialValue: newform.noofPallets.toString(),
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
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Preview Details',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
              Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8ECF4)),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 28,
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        AppColors.darkBlue,
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      dataTextStyle: const TextStyle(color: Colors.black87),
                      columnSpacing: 24,
                      horizontalMargin: 12,
                      dividerThickness: 1,
                      columns: const [
                        DataColumn(label: Text('SI No.')),
                        DataColumn(label: Text('Product Type')),
                        DataColumn(label: Text('Size')),
                        DataColumn(label: Text('No. Of Pallets')),
                        DataColumn(label: Text('Edit')),
                      ],
                      rows: [
                        for (var i = 0; i < lines.length; i++)
                          DataRow(
                            cells: [
                              DataCell(
                                Text((i + 1).toString().padLeft(2, '0')),
                              ),
                              DataCell(Text(lines[i].productType.toString())),
                              DataCell(Text(lines[i].size.toString())),
                              DataCell(
                                Text(
                                  lines[i].noOfPallets.toString().padLeft(
                                    2,
                                    '0',
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    final updated =
                                        await _showPalletDetailsDialog(
                                          context,
                                          lines[i].productType.toString(),
                                          existingItem: lines[i],
                                          palletSizes: palletSizeNames,
                                        );
                                    if (updated != null) {
                                      context
                                          .cubit<CreatePalletCubit>()
                                          .updatePalletItemAt(i, updated);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
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

Future<String?> _showPalletSizeSheet(
  BuildContext context,
  String? selected,
  List<String> palletSizes,
) {
  final options = [...palletSizes, 'Others'];
  String? tempSelected = selected;

  return showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Text(
                    'Pallet Size',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  if (options.length == 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'No pallet sizes available. Choose "Others" to enter manually.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ...options.map((option) {
                    final isSelected = option == tempSelected;
                    return InkWell(
                      onTap: () => setSheetState(() => tempSelected = option),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFE8ECF4)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected ? Colors.blue : Colors.black,
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Colors.blue),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E2A5A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed:
                              tempSelected == null
                                  ? null
                                  : () =>
                                      Navigator.pop(sheetContext, tempSelected),
                          child: const Text(
                            'Select',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(sheetContext, null),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<PalletItems?> _showPalletDetailsDialog(
  BuildContext context,
  String productType, {
  PalletItems? existingItem,
  required List<String> palletSizes,
}) {
  final palletNoController = TextEditingController(
    text: existingItem?.noOfPallets.toString() ?? '',
  );
  final existingSize = existingItem?.size;
  final isExistingOthers =
      existingSize != null && !palletSizes.contains(existingSize);

  String? selectedSize = isExistingOthers ? 'Others' : existingSize;

  final widthController = TextEditingController(
    text: isExistingOthers ? existingSize.split('*').first.trim() : '',
  );
  final lengthController = TextEditingController(
    text: isExistingOthers ? existingSize.split('*').last.trim() : '',
  );

  String? errorText;
  String? sizeErrorText;

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
                  children: [
                    Text(
                      '$productType Selected',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add below details to continue',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            const TextSpan(text: 'No. Of Pallet '),
                            TextSpan(
                              text: '(max. up to 50)',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
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
                      decoration: InputDecoration(
                        hintText: 'Enter Pallet no.',
                        filled: true,
                        fillColor: const Color(0xFFF5F6FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        errorText: errorText,
                      ),
                      onChanged: (_) {
                        if (errorText != null) {
                          setDialogState(() => errorText = null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pallet Size',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final size = await _showPalletSizeSheet(
                          context,
                          selectedSize,
                          palletSizes,
                        );
                        if (size != null) {
                          setDialogState(() {
                            selectedSize = size;
                            sizeErrorText = null;
                            if (size != 'Others') {
                              widthController.clear();
                              lengthController.clear();
                            }
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedSize ?? 'Select Pallet Size',
                              style: TextStyle(
                                color:
                                    selectedSize == null
                                        ? Colors.grey.shade500
                                        : Colors.black,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                    if (selectedSize == 'Others') ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: widthController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Width',
                                filled: true,
                                fillColor: const Color(0xFFF5F6FA),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
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
                              decoration: InputDecoration(
                                hintText: 'Length',
                                filled: true,
                                fillColor: const Color(0xFFF5F6FA),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
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
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          final noOfPallets = int.tryParse(
                            palletNoController.text.trim(),
                          );
                          if (noOfPallets == null || noOfPallets <= 0) {
                            setDialogState(
                              () => errorText = 'Enter a valid pallet number',
                            );
                            return;
                          }
                          if (noOfPallets > 50) {
                            setDialogState(
                              () => errorText = 'Max up to 20 pallets allowed',
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
                              productType: productType,
                              size: finalSize,
                              noOfPallets: noOfPallets,
                            ),
                          );
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(color: Colors.black, fontSize: 16),
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