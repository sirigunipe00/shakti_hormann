import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/consts/urls.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/create_frame_cubit.dart/create_frame_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class FrameLinesWidget extends StatefulWidget {
  const FrameLinesWidget({super.key});

  @override
  State<FrameLinesWidget> createState() => _FrameLinesWidgetState();
}

// class _FrameLinesWidgetState extends State<FrameLinesWidget> {
//   List<int> selectedRows = [];

//   @override
//   Widget build(BuildContext context) {
//     String resolvePhotoUrl(String? shutterPhoto, File? shutterPhotoImg) {
//       if (shutterPhotoImg != null) return shutterPhotoImg.path;
//       if (shutterPhoto == null || shutterPhoto.isEmpty) return '';
//       if (shutterPhoto.startsWith('http')) return shutterPhoto;

//       final base = Urls.baseUrl.replaceAll('/api', '');
//       return '$base$shutterPhoto';
//     }

//     final screenWidth = MediaQuery.of(context).size.width;

//     return BlocBuilder<CreateFrameCubit, CreateFrameState>(
//       builder: (_, state) {
//         final itemLines = state.lines.toList();

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minWidth: screenWidth - 32),
//                 child: DataTable(
//                   headingTextStyle: const TextStyle(
//                     fontSize: 12,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   dataTextStyle: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xFF1E293B),
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   border: TableBorder.all(
//                     color: const Color(0xFFE2E8F0),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   headingRowColor: WidgetStateProperty.all(
//                     const Color(0xFF1A3C6B),
//                   ),
//                   headingRowHeight: 44,
//                   dataRowMinHeight: 48,
//                   dataRowMaxHeight: 56,
//                   columnSpacing: 16,
//                   horizontalMargin: 12,
//                   columns: [
//                     const DataColumn(label: Text('Sl No.',style: TextStyle(fontSize: 18),)),
//                     const DataColumn(label: Text('SO No.',style: TextStyle(fontSize: 18))),
//                     const DataColumn(label: Text('Item Code',style: TextStyle(fontSize: 18))),
//                     const DataColumn(label: Text('Photo',style: TextStyle(fontSize: 18))),
//                     ],
//                   rows: List.generate(itemLines.length, (index) {
//                     final item = itemLines[index];
//                     final slNo = (index + 1).toString().padLeft(2, '0');
//                     final hasPhoto =
//                         (item.shutterPhoto != null &&
//                             item.shutterPhoto!.isNotEmpty) ||
//                         item.shutterPhotoImg != null;

//                     final photoDisplay = resolvePhotoUrl(
//                       item.shutterPhoto,
//                       item.shutterPhotoImg,
//                     );
//                     return DataRow(
//                       selected: selectedRows.contains(index),
//                       color: WidgetStateProperty.resolveWith((states) {
//                         if (states.contains(WidgetState.selected)) {
//                           return const Color(0xFFEFF6FF);
//                         }
//                         return index.isEven
//                             ? Colors.white
//                             : const Color(0xFFF8FAFC);
//                       }),
//                       cells: [
//                         DataCell(
//                           Text(
//                             slNo,
//                             style: const TextStyle(
//                               color: Color(0xFF2563EB),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),

//                         DataCell(Text(item.salesOrder ?? '—')),

//                         DataCell(Text(item.itemCode ?? '—')),

//                         DataCell(
//                           hasPhoto
//                               ? Center(
//                                 child: _ViewButton(
//                                   onTap:
//                                       () =>
//                                           _showPhotoDialog(context, photoDisplay),
//                                 ),
//                               )
//                               : const Center(
//                                 child: Text(
//                                   'N/A',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showPhotoDialog(BuildContext context, String photoUrl) {
//     Navigator.of(context).push(
//       MaterialPageRoute(builder: (_) => ImagePreviewPage(photoUrl: photoUrl)),
//     );
//   }
// }

// class ImagePreviewPage extends StatelessWidget {
//   const ImagePreviewPage({super.key, required this.photoUrl});

//   final String photoUrl;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A3C6B),
//         foregroundColor: Colors.white,
//         title: const Text('Photo Preview'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           panEnabled: true,
//           scaleEnabled: true,
//           minScale: 0.5,
//           maxScale: 4.0,
//           child:
//               photoUrl.startsWith('http')
//                   ? Image.network(
//                     photoUrl,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (_, child, progress) {
//                       if (progress == null) return child;
//                       return const Center(
//                         child: CircularProgressIndicator(color: Colors.white),
//                       );
//                     },
//                     errorBuilder:
//                         (_, __, ___) => const Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.broken_image,
//                               size: 80,
//                               color: Colors.white54,
//                             ),
//                             SizedBox(height: 12),
//                             Text(
//                               'Failed to load image',
//                               style: TextStyle(color: Colors.white54),
//                             ),
//                           ],
//                         ),
//                   )
//                   : Image.file(
//                     File(photoUrl),
//                     fit: BoxFit.cover,
//                     errorBuilder:
//                         (_, __, ___) => const Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.broken_image,
//                               size: 80,
//                               color: Colors.white54,
//                             ),
//                             SizedBox(height: 12),
//                             Text(
//                               'Failed to load image',
//                               style: TextStyle(color: Colors.white54),
//                             ),
//                           ],
//                         ),
//                   ),
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.darkBlue,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text(
//               'Close',
//               style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ViewButton extends StatelessWidget {
//   const _ViewButton({required this.onTap});
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//         decoration: BoxDecoration(
//           color: const Color(0xFF2563EB),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: const Text(
//           'View',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }
class _FrameLinesWidgetState extends State<FrameLinesWidget> {
  List<int> selectedRows = [];

  List<String> resolvePhotoUrls(
    List<String>? shutterPhoto,
    List<File>? shutterPhotoImg,
  ) {
    final urls = <String>[];

    if (shutterPhotoImg != null) {
      urls.addAll(shutterPhotoImg.map((f) => f.path));
    }

    if (shutterPhoto != null) {
      final base = Urls.baseUrl.replaceAll('/api', '');
      for (final photo in shutterPhoto) {
        if (photo.isEmpty) continue;
        urls.add(photo.startsWith('http') ? photo : '$base$photo');
      }
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<CreateFrameCubit, CreateFrameState>(
      builder: (_, state) {
        final itemLines = state.lines.toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: screenWidth - 32),
                child: DataTable(
                  headingTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFF1A3C6B),
                  ),
                  border: TableBorder(
                    top: BorderSide(color: Colors.grey.shade400),
                    bottom: BorderSide(color: Colors.grey.shade400),
                    left: BorderSide(color: Colors.grey.shade400),
                    right: BorderSide(color: Colors.grey.shade400),
                    horizontalInside: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    verticalInside: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  columnSpacing: 20,
                  horizontalMargin: 12,
                  headingRowHeight: 50,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 56,
                  columns: const [
                    DataColumn(
                      label: Center(
                        child: Text('Sl No.', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text('SO No.', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Item Code',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text('Photos', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                  rows: List.generate(itemLines.length, (index) {
                    final item = itemLines[index];
                    final slNo = (index + 1).toString().padLeft(2, '0');

                    final photoUrls = resolvePhotoUrls(
                      item.shutterPhoto,
                      item.shutterPhotoImg,
                    );
                    final hasPhoto = photoUrls.isNotEmpty;

                    return DataRow(
                      selected: selectedRows.contains(index),
                      color: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(0xFFEFF6FF);
                        }
                        return index.isEven
                            ? Colors.white
                            : const Color(0xFFF8FAFC);
                      }),
                      cells: [
                        DataCell(
                          Text(
                            slNo,
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(Text(item.salesOrder ?? '—')),
                        DataCell(Text(item.itemCode ?? '—')),
                        DataCell(
                          hasPhoto
                              ? Center(
                                child: _ViewButton(
                                  count: photoUrls.length,
                                  onTap:
                                      () =>
                                          _showPhotoDialog(context, photoUrls),
                                ),
                              )
                              : const Center(
                                child: Text(
                                  'N/A',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPhotoDialog(BuildContext context, List<String> photoUrls) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImageGalleryPreviewPage(photoUrls: photoUrls),
      ),
    );
  }
}

/// Gallery version of the old single-image ImagePreviewPage.
class ImageGalleryPreviewPage extends StatefulWidget {
  const ImageGalleryPreviewPage({
    super.key,
    required this.photoUrls,
    this.initialIndex = 0,
  });

  final List<String> photoUrls;
  final int initialIndex;

  @override
  State<ImageGalleryPreviewPage> createState() =>
      _ImageGalleryPreviewPageState();
}

class _ImageGalleryPreviewPageState extends State<ImageGalleryPreviewPage> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  late int _currentIndex = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3C6B),
        foregroundColor: Colors.white,
        title: Text('Photo ${_currentIndex + 1} of ${widget.photoUrls.length}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.photoUrls.length,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        itemBuilder: (_, i) {
          final photoUrl = widget.photoUrls[i];
          return Center(
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child:
                  photoUrl.startsWith('http')
                      ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => _brokenImage(),
                      )
                      : Image.file(
                        File(photoUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _brokenImage(),
                      ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _brokenImage() => const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.broken_image, size: 80, color: Colors.white54),
      SizedBox(height: 12),
      Text('Failed to load image', style: TextStyle(color: Colors.white54)),
    ],
  );
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({required this.onTap, required this.count});
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          count > 1 ? 'View ($count)' : 'View',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}