import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/installation/model/installation_line_items.dart';
import 'package:shakti_hormann/features/installation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/installation/presentation/bloc/create_installation_entry_cubit/create_installation_entry_cubit.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vision_panel/model/product_type.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class InstallationEntryFormWidget extends StatefulWidget {
  const InstallationEntryFormWidget({super.key});

  @override
  State<InstallationEntryFormWidget> createState() =>
      _InstallationEntryFormWidgetState();
}

class _InstallationEntryFormWidgetState
    extends State<InstallationEntryFormWidget> {
  SalesOrderForm? invoiceform;
  ProductType? productType;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController nobox = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateInstallationEntryCubit, CreateInstallationState>(
          listenWhen:
              (previous, current) =>
                  previous.error?.status != current.error?.status,
          listener: (_, state) async {},
        ),
        BlocListener<InstallationLinesCubit, InstallationLinesState>(
          listener: (_, state) {
            state.maybeWhen(
              orElse: () {},
              success:
                  context.cubit<CreateInstallationEntryCubit>().addAllLines,
            );
          },
        ),
      ],
      child: BlocConsumer<
        CreateInstallationEntryCubit,
        CreateInstallationState
      >(
        listenWhen:
            (previous, current) =>
                previous.error?.status != current.error?.status,
        listener: (_, state) async {},
        builder: (context, formState) {
          final cubit = context.cubit<CreateInstallationEntryCubit>();
          final newform = formState.form;
          $logger.devLog('newform$newform');
          final status = newform.docStatus;
          final printed = newform.isStickerPrinted == 1;
          final isSubmitted = status == 1;
          final isCreated = newform.name != null && newform.name!.isNotEmpty;
          final boxCount = newform.noOfBoxes ?? 0;
          if (formState.lines.isEmpty && printed && boxCount > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              cubit.ensureLinePlaceholders(boxCount);
            });
          }
          final displayLines = formState.lines;

          return Scaffold(
            backgroundColor: Colors.purple.shade100.withValues(alpha: 0.15),
            body: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: SpacedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                defaultHeight: 0,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: SectionHeader(
                      title: 'SO Details',
                      assetIcon: 'assets/images/vehicleinvoicicon.svg',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: SpacedColumn(
                      defaultHeight: 12,
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
                                newform.salesOrderNo != null &&
                                names.isNotEmpty) {
                              invoiceform = names.firstWhere(
                                (item) => item.name == newform.salesOrderNo,
                              );
                            }

                            return SearchDropDownList<SalesOrderForm>(
                              title: 'Sales Order No.',
                              hint: 'Select Order No',
                              key: const ValueKey('sales_order_dropdown'),
                              color: AppColors.black,
                              items: names,
                              isRequired: true,
                              readOnly: isCreated || printed || isSubmitted,
                              defaultSelection: invoiceform,
                              isloading: state.isLoading,
                              futureRequest: (query) async {
                                if (query.isEmpty) return names;

                                return names.where((item) {
                                  final orderNo =
                                      item.name?.toLowerCase() ?? '';
                                  final customer =
                                      item.customerName?.toLowerCase() ?? '';
                                  final search = query.toLowerCase();

                                  return orderNo.contains(search) ||
                                      customer.contains(search);
                                }).toList();
                              },
                              headerBuilder:
                                  (_, item, __) => Text(
                                    item.name ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                cubit.onValueChanged(
                                  salesOrderNo: selected.name,
                                );
                              },
                              focusNode: FocusNode(),
                            );
                          },
                        ),
                        InputField(
                          readOnly: isCreated || printed || isSubmitted,
                          isRequired: true,
                          title: 'No of Boxes',
                          controller: nobox,
                          hintText: 'Enter no of boxes',
                          borderColor: AppColors.grey,
                          inputType: TextInputType.number,
                          initialValue: newform.noOfBoxes?.toString() ?? '',
                          onChanged: (p0) {
                            final trimmed = p0.trim();
                            if (trimmed.isEmpty) {
                              cubit.clearNoOfBoxes();
                              return;
                            }
                            final parsed = int.tryParse(trimmed);
                            if (parsed != null) {
                              cubit.onValueChanged(noOfBoxes: parsed);
                            }
                          },
                        ),
                        const Text('**Please Save the Sales Order & No Of Boxes before Printing the stickers**'),
                        if (!isSubmitted)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  (isCreated &&
                                          !formState.isPrintLoading &&
                                          !printed)
                                      ? () => _confirmPrint(
                                        context,
                                        formState,
                                        cubit,
                                      )
                                      : null,
                              icon: Icon(
                                printed ? Icons.check_circle : Icons.print,
                                color: Colors.green,
                              ),
                              label:
                                  formState
                                          .isPrintLoading 
                                      ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        printed
                                            ? 'Sticker Printed'
                                            : 'Print Sticker',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                        ),
                                      ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    printed
                                        ? Colors.grey.shade400
                                        : isCreated
                                        ? const Color(0xFF5CB88F)
                                        : Colors.grey.shade400,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Box Details Table Section Only (No inline Submit button)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: SpacedColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      defaultHeight: 6,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4.0, top: 12),
                          child: SectionHeader(
                            title: 'Box Details',
                            assetIcon: 'assets/images/vehicleinvoicicon.svg',
                          ),
                        ),
                        _BoxDetailsTable(
                          lines: displayLines,
                          printed: printed,
                          isSubmitted: isSubmitted,
                          isUpdating:
                              formState.isLoading &&
                              cubit.allBoxesCaptured &&
                              !formState.isUpdated,
                          onCapture:
                              (index) =>
                                  _captureBoxPhoto(context, cubit, index),
                          onBoxNoChanged: cubit.onBoxNoChanged,
                          onViewImage:
                              (index, line) => _previewImage(
                                context,
                                cubit,
                                index,
                                line,
                                isSubmitted: isSubmitted,
                                isUpdated: formState.isUpdated,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _captureBoxPhoto(
    BuildContext context,
    CreateInstallationEntryCubit cubit,
    int index,
  ) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
      imageQuality: 70,
    );
    if (picked != null) {
      await cubit.onBoxPhotoCaptured(index, File(picked.path));
    }
  }

  Future<void> _previewImage(
    BuildContext context,
    CreateInstallationEntryCubit cubit,
    int index,
    InstallationLineItems line, {
    required bool isSubmitted,
    required bool isUpdated,
  }) async {
    final localFile = line.installtionPhotoImg;
    final remoteUrl = line.image;
    final hasUploadedImage = remoteUrl != null && remoteUrl.isNotEmpty;

    final String? resolvedUrl =
        hasUploadedImage ? _resolveImageUrl(remoteUrl) : null;

    final canRetake = !isSubmitted && !isUpdated && !hasUploadedImage;

    final shouldRetake = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder:
            (_) => _ImageViewerPage(
              localFile: localFile,
              imageUrl: resolvedUrl,
              canRetake: canRetake,
              boxLabel: 'Box No: ${line.boxNo}',
            ),
      ),
    );

    if (shouldRetake == true && context.mounted) {
      await _captureBoxPhoto(context, cubit, index);
    }
  }

  String _resolveImageUrl(String raw) {
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    final uri = Uri.parse(Urls.baseUrl);
    final base =
        '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    return raw.startsWith('/') ? '$base$raw' : '$base/$raw';
  }

  void _confirmPrint(
    BuildContext context,
    CreateInstallationState state,
    CreateInstallationEntryCubit cubit,
  ) {
    final boxCount = (state.form.noOfBoxes ?? 0).toString().padLeft(2, '0');
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.priority_high, color: Colors.red),
                ),
                const SizedBox(height: 12),
                const Text('Print Stickers?'),
              ],
            ),
            content: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: 'Note: Do you want to print $boxCount stickers for ',
                  ),
                  TextSpan(
                    text: state.form.salesOrderNo ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.red.shade50,
                  side: BorderSide(color: Colors.red.shade200),
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  cubit.printSticker();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                ),
                child: const Text(
                  'Print',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}

class _ImageViewerPage extends StatelessWidget {
  const _ImageViewerPage({
    this.localFile,
    this.imageUrl,
    this.canRetake = false,
    required this.boxLabel,
  });

  final File? localFile;
  final String? imageUrl;
  final bool canRetake;
  final String boxLabel;

  @override
  Widget build(BuildContext context) {
    final String? url = imageUrl;

    Widget content;
    if (localFile != null) {
      content = Image.file(localFile!);
    } else if (url != null && url.isNotEmpty) {
      content = Image.network(
        url,
        loadingBuilder:
            (_, child, progress) =>
                progress == null
                    ? child
                    : const CircularProgressIndicator(color: Colors.white),
        errorBuilder:
            (_, __, ___) => const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Unable to load image',
                style: TextStyle(color: Colors.white),
              ),
            ),
      );
    } else {
      content = const Text(
        'No image available',
        style: TextStyle(color: Colors.white),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(boxLabel, style: const TextStyle(color: Colors.white)),
        actions:
            canRetake
                ? [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text(
                      'Retake',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
                : null,
      ),
      body: Center(
        child: InteractiveViewer(minScale: 0.8, maxScale: 5, child: content),
      ),
    );
  }
}

class _BoxDetailsTable extends StatelessWidget {
  const _BoxDetailsTable({
    required this.lines,
    required this.printed,
    required this.isSubmitted,
    required this.isUpdating,
    required this.onCapture,
    required this.onBoxNoChanged,
    required this.onViewImage,
  });

  final List<InstallationLineItems> lines;
  final bool printed;
  final bool isSubmitted;
  final bool isUpdating;
  final void Function(int index) onCapture;
  final void Function(int index, String boxNo) onBoxNoChanged;
  final void Function(int index, InstallationLineItems line) onViewImage;

  bool _hasPhoto(InstallationLineItems line) =>
      line.installtionPhotoImg != null ||
      (line.image != null && line.image!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < lines.length; i++) {
      print("$i -> ${lines[i].installtionPhotoImg?.path} | ${lines[i].image}");
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade400),
        columnWidths: const {
          0: FixedColumnWidth(44),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1.6),
        },
        children: [
          const TableRow(
            decoration: BoxDecoration(color: AppColors.darkBlue),
            children: [
              _HeaderCell('#'),
              _HeaderCell('Box No.'),
              _HeaderCell('Photo'),
            ],
          ),
          for (var i = 0; i < lines.length; i++)
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFF3F4F8)),
              children: [
                _Cell(
                  child: Text(
                    (i + 1).toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C4A9E),
                    ),
                  ),
                ),
                _Cell(
                  child: Text(
                    lines[i].boxNo ?? 'B-${(i + 1).toString().padLeft(2, '0')}',
                  ),
                ),
                _Cell(
                  child:
                      _hasPhoto(lines[i])
                          ? InkWell(
                            onTap: () => onViewImage(i, lines[i]),
                            child: Container(
                              width: double.infinity,
                              color: const Color(0xFF5CB88F),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              child: const Text(
                                'View Image',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          : isSubmitted
                          ? const SizedBox()
                          : IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color:
                                  printed
                                      ? AppColors.black
                                      : Colors.grey.shade400,
                            ),
                            onPressed:
                                printed && !isUpdating
                                    ? () => onCapture(i)
                                    : null,
                          ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Urbanist',
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
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
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Center(child: child),
    );
  }
}
