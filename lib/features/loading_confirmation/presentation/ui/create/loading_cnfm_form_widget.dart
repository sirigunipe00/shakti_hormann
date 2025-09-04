import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/create_loading_cubit/create_loading_cnfm_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_snack_bar_widget.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/loading_indicator.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class LoadingCnfmFormWidget extends StatefulWidget {
  const LoadingCnfmFormWidget({super.key});

  @override
  State<LoadingCnfmFormWidget> createState() => _LoadingCnfmFormWidget();
}

class _LoadingCnfmFormWidget extends State<LoadingCnfmFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final focusNodes = List.generate(40, (index) => FocusNode());
  LoadingCnfmForm? loadingCnfmForm;
  DateTime? selectedDate;
  bool? isRejectedMode = false;

  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreateLoadingCnfmCubit>().state;
    final newform = formState.form;

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateLoadingCnfmCubit, CreateLaodingCnfmState>(
          listenWhen: (previous, current) {
            final prevStatus = previous.error?.status;
            final currStatus = current.error?.status;
            return prevStatus != currStatus;
          },
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!.error)));
            }
          },
        ),
      ],
      child: Container(
        color: Colors.purple.shade100.withValues(alpha: 0.15),
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
                  title: 'vehicle Request Details',
                  assetIcon: 'assets/images/gateentryicon.png',
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
                          top: 20,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputField(
                              title: 'Plant Name',
                              hintText: 'Enter Plant Name',
                              readOnly: true,
                              isRequired: true,
                              borderColor: AppColors.grey,
                              initialValue: newform.plantName,
                              onChanged: (p0) {},
                            ),
                            const SizedBox(height: 12),
                            AppDateField(
                              title: 'Vehicle Reporting Date',
                              hintText: 'Select Date',
                              readOnly: true,
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.vehicleReportingEntryVreDate ?? '',
                              ),
                              onSelected: (DateTime date) {},
                              fillColor: Colors.grey[200],
                            ),
                            const SizedBox(height: 12),
                            InputField(
                              title: 'Transporter',
                              hintText: 'Transporter Name',
                              readOnly: true,
                              borderColor: AppColors.grey,
                              initialValue: newform.transporterName,
                              onChanged: (p0) {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Vehicle and Driver Details',
                  assetIcon: 'assets/images/vehicleinvoiceicon.png',
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppDateField(
                        title: 'Arrival Date and Time',
                        hintText: 'Select Date',
                        readOnly: true,
                        startDate: DateTime(2020),
                        endDate: DateTime(2030),
                        initialDate: DFU.ddMMyyyyFromStr(
                          newform.arrivalDateAndTime ?? '',
                        ),
                        onSelected: (DateTime date) {},
                        fillColor: Colors.grey[200],
                      ),

                      const SizedBox(height: 12),

                      InputField(
                        title: 'Vehicle Number',
                        hintText: 'Vehicle No',
                        readOnly: true,
                        borderColor: AppColors.grey,
                        initialValue: newform.vehicleNumber,
                        onChanged: (p0) {},
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Driver Contact No',
                        hintText: 'Enter Contact Number',
                        readOnly: true,
                        inputType: TextInputType.number,
                        borderColor: AppColors.grey,
                        initialValue: newform.driverContact,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (p0) {},
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Item Details',
                  assetIcon: 'assets/images/photoicon.png',
                ),
              ),
              BlocBuilder<GetLoadedList, GetLoadedState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const SizedBox(),
                    loading: () => const LoadingIndicator(),
                    success: (data) {
                      return ItemLoadedTable(
                        initialData: data,
                        docstatus: formState.form.docstatus,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemLoadedTable extends StatefulWidget {
  const ItemLoadedTable({
    super.key,
    required this.initialData,
    required this.docstatus,
  });
  final List<ItemModel> initialData;
  final int? docstatus;

  @override
  State<ItemLoadedTable> createState() => _ItemLoadedTableState();
}

class _ItemLoadedTableState extends State<ItemLoadedTable> {
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> rows = [];

  @override
  void initState() {
    super.initState();

    // Map ItemModel list into rows
    rows =
        widget.initialData.map((item) {
          final baseUrl = 'http://65.21.243.18:8000';

          return {
            'itemCode': item.itemCode,
            'itemName': item.itemName,
            'qty': item.qtyLoaded?.toString() ?? '',
            'uom': item.uom,
            'photo':
                item.loadedItemPhoto != null
                    ? "$baseUrl${item.loadedItemPhoto}"
                    : null,
          };
        }).toList();

    // 🔹 Push API-loaded records to cubit as well
    Future.microtask(() {
      for (final item in widget.initialData) {
        context.read<CreateLoadingCnfmCubit>().addInitialItem(item);
      }
    });
  }

  Future<void> _openCamera(int index) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        rows[index]['photo'] = photo.path;
      });
    }
  }

  Future<void> addRow({int? index}) async {
    final initial = index != null ? rows[index] : null;

    final result = await showDialog(
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create:
                  (_) => LoadingCnfmBlocProvider.get().itemList()..request(''),
            ),
            BlocProvider(
              create: (context) => context.read<CreateLoadingCnfmCubit>(),
              child: Container(),
            ),
          ],
          child: ItemDialogWidget(initialRow: initial),
        );
      },
    );

    if (result != null) {
      final row = result['row'] as Map<String, dynamic>;
      final lineItem = result['model'] as ItemModel;

      if (index != null) {
        // 🔹 Editing existing row
        setState(() {
          rows[index] = row;
        });
        context.read<CreateLoadingCnfmCubit>().updateItem(index, lineItem);
      } else {
        // 🔹 Adding new row
        setState(() {
          rows.add(row);
        });
        context.read<CreateLoadingCnfmCubit>().addItem(lineItem);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              border: TableBorder.all(color: Colors.grey.shade300),
              headingRowColor: MaterialStateProperty.all(AppColors.darkBlue),
              headingTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              columns: const [
                DataColumn(label: Text('Sl. No')),
                DataColumn(label: Text('Item Code')),
                DataColumn(label: Text('Item Name')),
                DataColumn(label: Text('Quantity Loaded')),
                DataColumn(label: Text('UOM')),
                DataColumn(label: Text('Loaded Item Photo')),
                DataColumn(label: Text('Edit')),
              ],
              rows: List.generate(rows.length, (index) {
                return DataRow(
                  cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(rows[index]['itemCode'] ?? '')),
                    DataCell(Text(rows[index]['itemName'] ?? '')),
                    DataCell(Text(rows[index]['qty'] ?? '')),
                    DataCell(Text(rows[index]['uom'] ?? '')),
                    DataCell(
                      Center(
                        child:
                            rows[index]['photo'] == null
                                ? IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      AppColors.darkBlue,
                                    ),
                                  ),
                                  onPressed: () => _openCamera(index),
                                )
                                : _buildImage(rows[index]['photo']),
                      ),
                    ),
                    DataCell(
                      TextButton.icon(
                        onPressed:
                            () => addRow(index: index), // 👈 open edit dialog
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        label: const Text('Edit'),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (widget.docstatus != 1) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () => addRow(),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

Widget _buildImage(String path) {
  final baseUrl = 'http://65.21.243.18:8000/'; // replace with your domain

  if (File(path).existsSync()) {
    return Image.file(File(path), width: 50, height: 50, fit: BoxFit.cover);
  }

  if (path.startsWith('/files/')) {
    return Image.network(
      "$baseUrl$path",
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  }

  if (path.startsWith('http')) {
    return Image.network(path, width: 50, height: 50, fit: BoxFit.cover);
  }

  return const Icon(Icons.broken_image);
}

class ItemDialogWidget extends StatefulWidget {
  const ItemDialogWidget({super.key, this.initialRow});
  final Map<String, dynamic>? initialRow;

  @override
  State<ItemDialogWidget> createState() => _ItemDialogWidgetState();
}

class _ItemDialogWidgetState extends State<ItemDialogWidget> {
  final ImagePicker _picker = ImagePicker();

  ItemModel? itemFrom;
  File? photoFile;

  late TextEditingController itemNameController;
  late TextEditingController uomController;
  late TextEditingController qtyController;

  String? selectedCode;
  String? photoPath;

  @override
  void initState() {
    super.initState();

    // initialize with existing row if editing
    selectedCode = widget.initialRow?['itemCode'];
    itemNameController = TextEditingController(
      text: widget.initialRow?['itemName'] ?? '',
    );
    uomController = TextEditingController(
      text: widget.initialRow?['uom'] ?? '',
    );
    qtyController = TextEditingController(
      text: widget.initialRow?['qty'] ?? '',
    );
    photoPath = widget.initialRow?['photo'];
    if (selectedCode != null) {
      itemFrom = ItemModel(
        name: selectedCode,
        itemName: widget.initialRow?['itemName'],
        stockUom: widget.initialRow?['uom'],
      );
    }
  }

  @override
  void dispose() {
    itemNameController.dispose();
    uomController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        photoPath = photo.path;
        photoFile = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add / Edit Item'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ItemList, ItemState>(
              builder: (_, state) {
                final allData = state.maybeWhen(
                  orElse: () => <ItemModel>[],
                  success: (data) => data,
                );

                return SearchDropDownList<ItemModel>(
                  key: UniqueKey(),
                  title: 'Item Code',
                  hint: 'Search Item Code',
                  color: AppColors.white,
                  items: allData,
                  defaultSelection: itemFrom,
                  isloading: state.isLoading,
                  futureRequest: (query) async {
                    if (query.isEmpty) return allData;

                    final lowerQuery = query.toLowerCase();

                    return allData.where((item) {
                      final code = item.name?.toLowerCase() ?? '';
                      final name = item.itemName?.toLowerCase() ?? '';
                      final uom = item.stockUom?.toLowerCase() ?? '';

                      return code.contains(lowerQuery) ||
                          name.contains(lowerQuery) ||
                          uom.contains(lowerQuery);
                    }).toList();
                  },
                  headerBuilder: (_, item, __) => Text(item.name ?? ''),
                  listItemBuilder:
                      (_, item, __, ___) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Code: ${item.name ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (item.itemName != null)
                            Text('Item Name : ${item.itemName}'),
                          Text('Sales UOM: ${item.stockUom ?? ''}'),
                          const Divider(height: 8),
                        ],
                      ),
                  onSelected: (selected) {
                    setState(() {
                      itemFrom = selected;
                      selectedCode = selected.name;
                      itemNameController.text = selected.itemName ?? '';
                      uomController.text = selected.stockUom ?? '';
                    });
                  },
                  focusNode: FocusNode(),
                );
              },
            ),

            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              controller: itemNameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),

            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              controller: uomController,
              decoration: const InputDecoration(labelText: 'UOM'),
            ),

            const SizedBox(height: 10),
            TextFormField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity Loaded'),
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                if (photoPath != null)
                  Stack(
                    children: [
                      // 👇 Instead of Image.file, use _buildImage helper
                      _buildImage(photoPath!),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              AppColors.darkBlue,
                            ),
                          ),
                          onPressed: _pickPhoto, // Retake image
                        ),
                      ),
                    ],
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _pickPhoto,
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 0, // remove shadow glow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          onPressed: () {
            if (qtyController.text.isEmpty) {
              context.showSnackbar(
                'Please enter Quantity loaded value',
                AppSnackBarType.error,
              );
            } else {
              final row = {
                'itemCode': selectedCode,
                'itemName': itemNameController.text,
                'uom': uomController.text,
                'qty': qtyController.text,
                'photo': photoPath,
              };

              final lineItem = ItemModel(
                itemCode: selectedCode,
                itemName: itemNameController.text,
                sampleQuantity: int.tryParse(qtyController.text),
                stockUom: uomController.text,
                imageFile: photoFile,
              );

              Navigator.pop(context, {'row': row, 'model': lineItem});
            }
          },
          child: const Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
