import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/create_frame_cubit.dart/create_frame_cubit.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/create/frame_scan_page.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/widget/frame_lines_widget.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/widget/border_painter.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';

class FrameFormWidget extends StatefulWidget {
  const FrameFormWidget({super.key});

  @override
  State<FrameFormWidget> createState() => __FrameFormWidgetState();
}

class __FrameFormWidgetState extends State<FrameFormWidget> {
  final ScrollController _scrollController = ScrollController();
  SalesOrderForm? invoiceform;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<CreateFrameCubit>().state;
    final isCompleted = formState.view == FrameView.completed;
    final newform = formState.form;
    // final status = newform.docStatus;

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateFrameCubit, CreateFrameState>(
          listenWhen:
              (previous, current) =>
                  previous.error?.status != current.error?.status,
          listener: (_, state) async {},
        ),
        BlocListener<FrameLinesCubit, FrameLinesCubitState>(
          listener: (_, state) {
            state.maybeWhen(
              orElse: () {},
              success: context.cubit<CreateFrameCubit>().addAllLines,
            );
          },
        ),
      ],
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SectionHeader(
            //   title: 'SO Details',
            //   assetIcon: 'assets/images/palleticon.svg',
            // ),
            // Container(
            //     padding: const EdgeInsets.only( left: 12, right: 12,bottom: 8,top: 8),
            //     width: MediaQuery.of(context).size.width,
            //     // margin: const EdgeInsets.symmetric(horizontal: 18),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(color: Colors.grey.shade300),
            //     ),
            // child: BlocBuilder<SalesOrderList, SalesOrderState>(
            //       builder: (_, state) {
            //         final allData = state.maybeWhen(
            //           orElse: () => <SalesOrderForm>[],
            //           success: (data) => data,
            //         );

            //         final names = allData.toList();

            //         return SearchDropDownList<SalesOrderForm>(
            //           title: 'Sales Order No.',
            //           hint: 'Select Order No',
            //           key: UniqueKey(),
            //           color: AppColors.black,
            //           items: names,
            //           readOnly: status == 1,
            //           defaultSelection: invoiceform,
            //           isloading: state.isLoading,
            //           futureRequest: (query) async {
            //             if (query.isEmpty) return names;

            //             return names.where((item) {
            //               final orderNo = item.name?.toLowerCase() ?? '';
            //               final customer =
            //                   item.customerName?.toLowerCase() ?? '';
            //               final search = query.toLowerCase();

            //               return orderNo.contains(search) ||
            //                   customer.contains(search);
            //             }).toList();
            //           },
            //           headerBuilder:
            //               (_, item, __) => Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     item.name ?? '',
            //                     style: const TextStyle(
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //           listItemBuilder:
            //               (_, item, __, ___) => Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     'Sales Invoice No: ${item.name ?? ''}',
            //                     style: const TextStyle(
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                   // if (item.customerName != null)
            //                   //   Text('Customer Name : ${item.customerName}'),
            //                   // Text('Order Date: ${(item.orderDate ?? '')} '),

            //                   // const Divider(height: 8),
            //                 ],
            //               ),
            //           onSelected: (selected) {
            //             setState(() {
            //               invoiceform = selected;
            //             });
            //             context.cubit<CreateFrameCubit>().onValueChanged(
            //               // salesInvoice: selected.name,
            //               // plantName: selected.plantName,
            //               // salesInvoiceDate: selected.orderDate,
            //               // customerName: selected.customerName,
            //             );
            //           },

            //           focusNode: FocusNode(),
            //         );
            //       },
            //     )
            // ),
            // const SizedBox(height: 10,),

            if(!isCompleted)...[
            Row(
              children: [
                Expanded(
                  child: _ScanCard(
                    icon: Icons.qr_code_scanner,
                    label: 'Scan Frame\nSticker',
                    onTap: () => _onScanSticker(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ScanCard(
                    icon: Icons.camera_alt_outlined,
                    label: 'Upload Frame\nImage',
                    onTap: () => _onUploadImage(context),
                  ),
                ),
              ],
            ),
            ],

            const SizedBox(height: 20),

            const SectionHeader(
              title: 'Pallet Details',
              assetIcon: 'assets/images/palleticon.svg',
            ),

            DashedBorderBox(
              borderRadius: 12,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Pallet No.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        newform.palletNo ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    NewUploadPhotoWidget(
                      fileName: 'camera.png',
                      imageUrl: newform.palletPhoto,
                      title: 'Pallet Image',
                      isRequired: true,
                      isReadOnly: newform.palletQrPrinted != 1 || isCompleted,
                      onFileCapture: (file) {
                        if (newform.palletQrPrinted != 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please print the pallet QR before capturing the pallet image.',
                              ),
                            ),
                          );
                          return;
                        }

                        context.cubit<CreateFrameCubit>().onValueChanged(
                          palletPhoto: file,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const SectionHeader(
              title: 'Frame Details',
              assetIcon: 'assets/images/palleticon.svg',
            ),

            const SizedBox(height: 10),

            const FrameLinesWidget(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _onScanSticker(BuildContext context) async {
    final raw = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const ScanFramePage()));

    if (raw == null || !context.mounted) return;
    context.cubit<CreateFrameCubit>().onQrScanned(raw);
  }

  Future<void> _onUploadImage(BuildContext context) async {
    final result = await captureAndDecode();

    if (!context.mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not read sticker. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.cubit<CreateFrameCubit>().onQrScanned(
      result['qr']!,
      imagePath: result['imagePath'],
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DashedBorderBox(
        borderRadius: 16,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 14),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
