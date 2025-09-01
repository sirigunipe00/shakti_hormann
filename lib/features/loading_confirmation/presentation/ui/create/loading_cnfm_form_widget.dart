import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/create_loading_cubit/create_loading_cnfm_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class LoadingCnfmFormWidget extends StatefulWidget {
  const LoadingCnfmFormWidget({super.key});

  @override
  State<LoadingCnfmFormWidget> createState() =>
      _LoadingCnfmFormWidget();
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
    // final isCompleted = formState.view == LoadingView.completed;

    final newform = formState.form;
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateLoadingCnfmCubit,CreateLaodingCnfmState >(
          listenWhen: (previous, current) {
            final prevStatus = previous.error?.status;
            final currStatus = current.error?.status;
            return prevStatus != currStatus;
          },
          listener: (_, state) async {
          }
        ),
      ],
      child: Container(
        color: Colors.purple.shade100.withValues(alpha:0.15),
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

                              onChanged:
                                  (p0) => context
                                      .cubit<CreateLoadingCnfmCubit>()
                                      .onValueChanged(plantName: p0),
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
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateLoadingCnfmCubit>()
                                      .onValueChanged(
                                        vehicleReportingEntryVreDate:
                                            DateFormat(
                                              'dd-MM-yyyy',
                                            ).format(date),
                                      );
                                });
                              },
                              fillColor: Colors.grey[200],
                            ),
                            const SizedBox(height: 12),
                            InputField(
                              title: 'Transporter',
                              hintText: 'Transporter Name',
                              readOnly: true,
                              borderColor: AppColors.grey,
                              initialValue: newform.transporterName,

                              onChanged:
                                  (p0) => context
                                      .cubit<CreateLoadingCnfmCubit>()
                                      .onValueChanged(transporterName: p0),
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
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateLoadingCnfmCubit>()
                                      .onValueChanged(
                                        arrivalDateAndTime: DateFormat(
                                          'dd-MM-yyyy',
                                        ).format(date),
                                      );
                                      
                                });
                              },
                              fillColor: Colors.grey[200],
                            ),

                      const SizedBox(height: 12),
                   
                      InputField(
                        title: 'Vehicle Number',
                        hintText: 'Vehicle No',
                        readOnly: true,
                        borderColor: AppColors.grey,

                        initialValue: newform.vehicleNumber,
                        onChanged:
                            (value) => context
                                .cubit<CreateLoadingCnfmCubit>()
                                .onValueChanged(vehicleNo: value),
                        inputFormatters: [UpperCaseTextFormatter()],
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
                        onChanged: (p0) {
                          context.cubit<CreateLoadingCnfmCubit>().onValueChanged(
                            driverContact: p0,
                          );
                        },
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
                  assetIcon: 'assets/images/photoicon.png',
                ),
              ),
              const ItemLoadedTable(),
              
            ],
          ),
        ),
      ),
    );
  }
}





class ItemLoadedTable extends StatefulWidget {
  const ItemLoadedTable({super.key});

  @override
  State<ItemLoadedTable> createState() => _ItemLoadedTableState();
}

class _ItemLoadedTableState extends State<ItemLoadedTable> {
  final ImagePicker _picker = ImagePicker();
ItemModel? itemFrom;
  List<Map<String, dynamic>> rows = [
    {'itemName': '', 'qty': '', 'uom': '', 'photo': null}
  ];

  void _addRow() {
     openItemForm();
  }

  Future<void> _openCamera(int index) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        rows[index]['photo'] = photo.path; 
      });
    }
  }
  Future<void> openItemForm({int? index}) async {
  String? selectedCode = index != null ? rows[index]['itemCode'] : null;
  String itemName = index != null ? rows[index]['itemName'] : '';
  String uom = index != null ? rows[index]['uom'] : '';
  String qty = index != null ? rows[index]['qty'] : '';
  String? photoPath = index != null ? rows[index]['photo'] : null;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Add / Edit Item'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Item Code Dropdown
                 BlocBuilder<ItemList, ItemState>(
                  builder: (_, state) {
                    final allData = state.maybeWhen(
                      orElse: () => <ItemModel>[],
                      success: (data) => data,
                    );

                    final names = allData.toList();

                    return SearchDropDownList<ItemModel>(
                      title: 'Invoice No',
                      hint: 'Search Invoice No',
                      key: UniqueKey(),
                      color: AppColors.white,
                      items: names,
                      
                      defaultSelection: itemFrom,
                      isloading: state.isLoading,
                      futureRequest: (query) async {
                        return names.toList();
                      },
                      headerBuilder:
                          (_, item, __) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                 Text(
                                'Item Code: ${item.name ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item.itemName != null)
                                Text(
                                  'Item Name : ${item.itemName}' 
                                ),
                              Text('Sales Uom: ${item.salesUom ?? ''} '),

                              const Divider(height: 8),
                            ],
                          ),
                      onSelected: (selected) {
                        setState(() {
                          itemFrom = selected;
                        });
                        // context.cubit<CreateLoadingCnfmCubit>().onValueChanged(
                        //   name: selected.name,
                        //   itemName: selected.itemName,
                        //   salesUom : selected.salesUom
                        // );
                      },

                      focusNode: FocusNode(),
                    );
                  },
                ),

                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                    initialValue: itemName,
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'UOM'),
                    initialValue: uom,
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Quantity Loaded'),
                    keyboardType: TextInputType.number,
                    initialValue: qty,
                    onChanged: (val) => qty = val,
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (photoPath != null)
                        Image.file(File(photoPath!), width: 60, height: 60, fit: BoxFit.cover),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () async {
                          final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                          if (photo != null) {
                            setStateDialog(() {
                              photoPath = photo.path;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (selectedCode != null && qty.isNotEmpty) {
                    setState(() {
                      if (index != null) {
                        rows[index] = {
                          'itemCode': selectedCode,
                          'itemName': itemName,
                          'uom': uom,
                          'qty': qty,
                          'photo': photoPath,
                        };
                      } else {
                        rows.add({
                          'itemCode': selectedCode,
                          'itemName': itemName,
                          'uom': uom,
                          'qty': qty,
                          'photo': photoPath,
                        });
                      }
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder.all(color: Colors.grey.shade300),
              headingRowColor:
                  MaterialStateProperty.all(AppColors.darkBlue),
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
              ],
              rows: List.generate(rows.length, (index) {
                return DataRow(
                  cells: [
                    DataCell(Text((index + 1).toString().padLeft(2, '0'))),
                    const DataCell(Text('')), // Item Code
                    DataCell(Text(rows[index]['itemName'] ?? '')),
                    DataCell(Text(rows[index]['qty'] ?? '')),
                    DataCell(Text(rows[index]['uom'] ?? '')),
                    DataCell(
                      Center(
                        child: rows[index]['photo'] == null
                            ? IconButton(
                                icon: const Icon(Icons.camera_alt,
                                    color: Colors.white),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(
                                    AppColors.darkBlue,
                                  ),
                                ),
                                onPressed: () => _openCamera(index),
                              )
                            : Image.file(
                                File(rows[index]['photo']),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _addRow,
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkBlue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}



