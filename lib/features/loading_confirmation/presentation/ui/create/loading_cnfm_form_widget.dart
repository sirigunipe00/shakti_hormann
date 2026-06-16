import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/logistic.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/create_loading_cubit/create_loading_cnfm_cubit.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/ui/create/sales_order_table.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_snack_bar_widget.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/inputs/time_picker.dart';
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
    $logger.devLog('.......$newform');

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
                  title: 'Vehicle Request Details',
                  assetIcon: 'assets/images/gateentryicon.svg',
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
                            InputField(
                              title: 'Linked Transporter No',
                              hintText: 'Linked Transporter No',
                              readOnly: true,
                              isRequired: true,
                              borderColor: AppColors.grey,
                              initialValue:
                                  newform.linkedTransporterConfirmation,

                              onChanged: (p0) {},
                            ),
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
                              title: 'Transporter Name',
                              readOnly: true,
                              borderColor: AppColors.grey,
                              initialValue: [
                                    newform.transporterName,
                                    newform.transporterName2,
                                  ]
                                  .where((e) => e != null && e.isNotEmpty)
                                  .join(' - '),
                              onChanged: (p0) => context,
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
                  title: 'Sales Orders',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<Logistic, LogisticState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        failure: (msg) => Center(child: Text('Error: $msg')),
                        success: (salesOrders) {
                          if (salesOrders.isNotEmpty) {
                            context.cubit<ItemList>().request(salesOrders);
                          }

                          return SalesOrderTables(
                            salesOrders: salesOrders,
                            widthFactor: 1.2,
                          );
                        },
                        orElse: () => const SizedBox(),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Vehicle and Driver Details',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppDateField(
                              title: 'Arrival Date',
                              hintText: 'Select Date',
                              isRequired: true,
                              readOnly: true,
                              key: ValueKey(newform.arrivalDate ?? ''),
                              startDate: DateTime.now(),
                              endDate: DateTime(2030),
                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.arrivalDate ?? '',
                              ),
                              onSelected: (DateTime date) {},
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TimePickerField(
                                  title: 'Arrival Time',
                                  readOnly: true,
                                  isRequired: true,
                                  key: UniqueKey(),
                                  hintText: 'Select Time',
                                  initialTime: formatTime(newform.arrivalTime),
                                  onTimeChanged: (selectedTime) {},
                                ),
                              ],
                            ),
                          ),
                        ],
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
                  title: 'Photo',
                  assetIcon: 'assets/images/photoicon.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                  ),
                  child: Center(
                    child: NewUploadPhotoWidget(
                      fileName: 'driverid',
                      imageUrl: newform.driverIdPhoto,
                      title: 'Driver ID Proof',
                      isReadOnly: true,
                      onFileCapture: (file) {
                        // context.cubit<CreateLoadingCnfmCubit>().onValueChanged(
                        //   driverIdPhoto: file,
                        // );
                      },
                      focusNode: focusNodes.elementAt(27),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Item Details',
                  assetIcon: 'assets/images/remarksicon.svg',
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

String? formatTime(String? backendTime) {
  if (backendTime == null || backendTime.isEmpty) return null;

  final parts = backendTime.split(':');
  if (parts.length < 2) return backendTime;

  return '${parts[0]}:${parts[1]}';
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

    rows =
        widget.initialData.map((item) {
          return {
            'itemCode': item.itemCode,
            'itemName': item.itemName,
            'qty': item.qtyLoaded?.toString() ?? '',
            'uom': item.uomValue,
            'photo': item.loadedItemPhoto ?? '',
          };
        }).toList();

    Future.microtask(() {
      for (final item in widget.initialData) {
        // print('itemm   ..:$item');
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

      final cubit = context.read<CreateLoadingCnfmCubit>();

      if (index < cubit.state.listitems.length) {
        final oldItem = cubit.state.listitems[index];

        final newItem = oldItem.copyWith(
          imageFile: File(photo.path),
          loadedItemPhoto: oldItem.loadedItemPhoto,
        );
        cubit.updateItem(index, newItem);
      }
    }
  }

  Future<void> addRow({int? index}) async {
    final initial = index != null ? rows[index] : null;
    final List<LogisticModel> salesorders = context
        .read<Logistic>()
        .state
        .maybeWhen(
          success: (orders) => orders,
          orElse: () => <LogisticModel>[],
        );

    final result = await showDialog(
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create:
                  (_) =>
                      LoadingCnfmBlocProvider.get().itemList()
                        ..request(salesorders),
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
        final cubit = context.read<CreateLoadingCnfmCubit>();
        final oldItem = cubit.state.listitems[index];

        final updatedItem = oldItem.copyWith(
          itemCode: lineItem.itemCode ?? oldItem.itemCode,
          itemName: lineItem.itemName ?? oldItem.itemName,
          uomValue: lineItem.uomValue ?? oldItem.uomValue,
          qtyLoaded: lineItem.qtyLoaded ?? oldItem.qtyLoaded,
          sampleQuantity: lineItem.sampleQuantity ?? oldItem.sampleQuantity,
          loadedItemPhoto: lineItem.loadedItemPhoto ?? oldItem.loadedItemPhoto,
          imageFile: lineItem.imageFile, 
        );

        setState(() {
          rows[index] = row;
        });

        cubit.updateItem(index, updatedItem);
      } else {

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
              columns: [
                const DataColumn(label: Text('Sl. No')),
                const DataColumn(label: Text('Item Code')),
                const DataColumn(label: Text('Item Name')),
                const DataColumn(label: Text('Quantity Loaded')),
                const DataColumn(label: Text('UOM')),
                const DataColumn(label: Text('Loaded Item Photo')),
                // DataColumn(label: Text('Edit')),
                if (widget.docstatus != 1)
                  const DataColumn(label: Text('Edit')),
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
                                : _buildImage(
                                  rows[index]['photo'],
                                  context: context,
                                ),
                      ),
                    ),
                    if (widget.docstatus !=
                        1) 
                      DataCell(
                        TextButton.icon(
                          onPressed: () => addRow(index: index),
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

Widget _buildImage(String path, {BuildContext? context}) {
  final baseUrl = Urls.baseUrl.replaceAll('/api', '');

  Widget imageWidget;

  if (File(path).existsSync()) {
    imageWidget = Image.file(
      File(path),
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  } else if (path.startsWith('/files/')) {
    imageWidget = Image.network(
      '$baseUrl$path',
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  } else if (path.startsWith('http')) {
    imageWidget = Image.network(
      path,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  } else {
    imageWidget = const Icon(Icons.broken_image);
  }


  return GestureDetector(
    onTap:
        context == null
            ? null
            : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageViewScreen(imagePath: path),
                ),
              );
            },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageWidget,
    ),
  );
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
        itemCode: selectedCode,
        itemName: widget.initialRow?['itemName'],
        uomValue: widget.initialRow?['uom'],
        qty: int.tryParse(widget.initialRow?['qty'] ?? '0'),
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
                      final uom = item.uomValue?.toLowerCase() ?? '';

                      return code.contains(lowerQuery) ||
                          name.contains(lowerQuery) ||
                          uom.contains(lowerQuery);
                    }).toList();
                  },
                  headerBuilder: (_, item, __) => Text(item.itemCode ?? ''),
                  listItemBuilder:
                      (_, item, __, ___) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Code: ${item.itemCode ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (item.itemName != null)
                            Text('Item Name : ${item.itemName}'),
                          Text('Sales UOM: ${item.uomValue ?? ''}'),
                          Text('Quantity: ${item.qty ?? ''}'),
                          const Divider(height: 8),
                        ],
                      ),
                  onSelected: (selected) {
                    setState(() {
                      itemFrom = selected;
                      selectedCode = selected.itemCode;
                      itemNameController.text = selected.itemName ?? '';
                      uomController.text = selected.uomValue ?? '';
                      qtyController.text = selected.qty.toString();
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
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'Item Name',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              controller: uomController,
              decoration: const InputDecoration(
                labelText: 'UOM',
                labelStyle: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),

            const SizedBox(height: 10),
            TextFormField(
              readOnly: false,
              controller: qtyController,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'Quantity Loaded',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                if (photoPath != null)
                  Stack(
                    children: [
                      _buildImage(photoPath!, context: context),
                      Center(
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              AppColors.darkBlue,
                            ),
                          ),
                          onPressed: _pickPhoto,
                        ),
                      ),
                    ],
                  )
                else
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _pickPhoto,
                    ),
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
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          onPressed: () {
            final qtyText = qtyController.text.trim();
            final qtyValue = double.tryParse(qtyText);

            if (qtyValue == null || qtyValue <= 0) {
              context.showSnackbar(
                'Quantity Loaded must be greater than 0',
                AppSnackBarType.error,
              );
              return;
            }

            final row = {
              'itemCode': selectedCode,
              'itemName': itemNameController.text,
              'uom': uomController.text,
              'qty': qtyValue.toString(),
              'photo': photoFile != null ? photoFile!.path : photoPath,
            };

            final lineItem = ItemModel(
              itemCode: selectedCode,
              itemName: itemNameController.text,
              sampleQuantity: qtyValue.toInt(),
              stockUom: uomController.text,
              imageFile: photoFile,
              loadedItemPhoto: photoFile != null ? null : photoPath,
            );

            Navigator.pop(context, {'row': row, 'model': lineItem});
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

class ImageViewScreen extends StatefulWidget {
  const ImageViewScreen({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  double rotationAngle = 0.0;

  void _rotateImage() {
    setState(() {
      rotationAngle += 90 * 3.1415926535 / 180;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = Urls.baseUrl.replaceAll('/api', '');

    Widget imageWidget;

    if (File(widget.imagePath).existsSync()) {
      imageWidget = Image.file(File(widget.imagePath), fit: BoxFit.contain);
    } else if (widget.imagePath.startsWith('/files/')) {
      imageWidget = Image.network(
        '$baseUrl${widget.imagePath}',
        fit: BoxFit.contain,
      );
    } else if (widget.imagePath.startsWith('http')) {
      imageWidget = Image.network(widget.imagePath, fit: BoxFit.contain);
    } else {
      imageWidget = const Icon(Icons.broken_image, size: 100);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Image Preview',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.1,
              maxScale: 5.0,
              clipBehavior: Clip.none,
              boundaryMargin: const EdgeInsets.all(100),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Transform.rotate(
                        angle: rotationAngle,
                        child: imageWidget,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _rotateImage,
              child: const Icon(Icons.rotate_right, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
