import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/attachment_selection_mixin.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

enum PhotoState { capture, view }

class NewUploadPhotoWidget extends StatefulWidget {
  const NewUploadPhotoWidget({
    super.key,
    this.title,
    this.isRequired = false,
    this.isReadOnly = false,
    this.imageUrl,
    this.defaultValue,
    required this.onFileCapture,
    this.focusNode,
    required this.fileName,
    this.isWarning,
  });

  final String? title;
  final String fileName;
  final bool isRequired;
  final String? imageUrl;
  final File? defaultValue;
  final Function(File? file) onFileCapture;
  final bool isReadOnly;
  final FocusNode? focusNode;
  final bool? isWarning;

  @override
  State<NewUploadPhotoWidget> createState() => _NewUploadPhotoWidgetState();
}

class _NewUploadPhotoWidgetState extends State<NewUploadPhotoWidget>
    with AttahcmentSelectionMixin {
  File? _selectedImage;
  PhotoState _photoState = PhotoState.capture;

  @override
  void initState() {
    super.initState();
    if (widget.defaultValue.isNotNull) {
      _selectedImage = widget.defaultValue;
      _photoState = PhotoState.view;
    }
    if (widget.imageUrl.isNotNull) {
      _selectedImage = null;
      _photoState = PhotoState.view;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _capture() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final selectedImage = File(pickedFile.path);
        debugPrint('🖼️ Image picked from camera: ${selectedImage.path}');

        setState(() {
          _selectedImage = selectedImage;
          _photoState = PhotoState.view;
        });
        widget.onFileCapture(selectedImage);
      } else {
        debugPrint('❌ No image selected');
      }
    } catch (e) {
      debugPrint('❌ Error while picking image: $e');
    }
  }

  String getFullImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    final base = Urls.baseUrl.replaceAll('/api', '');
    return '$base$url';
  }

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.center,
      defaultHeight: 6,
      margin: EdgeInsets.zero,
      children: [
        GestureDetector(
          onTap: () {
            // View-only mode
            if (widget.isReadOnly) {
              if (_photoState == PhotoState.view) {
                context.goToPage(
                  ImagePreviewPage(
                    imageUrl: widget.imageUrl,
                    image: _selectedImage,
                    title: widget.title.valueOrEmpty,
                    isReadOnly: true,
                    onRetake: () {},
                    onDone: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              }
              return;
            }

            if (_photoState == PhotoState.view) {
              context.goToPage(
                ImagePreviewPage(
                  imageUrl: widget.imageUrl,
                  image: _selectedImage,
                  title: widget.title.valueOrEmpty,
                  isReadOnly: false,
                  onRetake: () async {
                    Navigator.pop(context);
                    await _capture();
                  },
                  onDone: () {
                    Navigator.pop(context);
                  },
                ),
              );
            } else {
              _capture();
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getBgColor(widget.fileName),
              ),
              child: ClipOval(
                child:
                    _photoState == PhotoState.capture
                        ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            'assets/images/${widget.fileName}.svg',
                            fit: BoxFit.contain,
                          ),
                        )
                        : (_selectedImage != null
                            ? Image.file(_selectedImage!, fit: BoxFit.cover)
                            : (widget.imageUrl != null
                                ? Image.network(
                                  getFullImageUrl(widget.imageUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: SvgPicture.asset(
                                        'assets/images/${widget.fileName}.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  },
                                )
                                : Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    'assets/images/${widget.fileName}.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ))),
              ),
            ),
          ),
        ),
        if (widget.title != null && widget.title!.isNotEmpty)
          CaptionText(title: widget.title!, isRequired: widget.isRequired),
      ],
    );
  }
}

class ImagePreviewPage extends StatefulWidget {
  const ImagePreviewPage({
    super.key,
    required this.image,
    required this.imageUrl,
    required this.title,
    required this.onRetake,
    required this.onDone,
    required this.isReadOnly,
  });

  final String title;
  final File? image;
  final String? imageUrl;
  final VoidCallback onRetake;
  final VoidCallback onDone;
  final bool isReadOnly;

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  double rotationAngle = 0.0;

  void _rotateImage() {
    setState(() {
      rotationAngle += 90 * 3.1415926535 / 180;
    });
  }

  String getFullImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final base = Urls.baseUrl.replaceAll('/api', '');
    return '$base$url';
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (widget.image != null) {
      imageWidget = Image.file(widget.image!, fit: BoxFit.contain);
    } else if (widget.imageUrl.containsValidValue) {
      imageWidget = Image.network(
        getFullImageUrl(widget.imageUrl),
        fit: BoxFit.contain,
      );
    } else {
      imageWidget = const Icon(Icons.broken_image, size: 100);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.1,
                maxScale: 5.0,
                clipBehavior: Clip.none,
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (!widget.isReadOnly) ...[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlue,
                  ),
                  onPressed: widget.onRetake,
                  child: const Text(
                    'RETAKE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                ),
                onPressed: widget.onDone,
                child: const Text(
                  'DONE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getBgColor(String fileName) {
  switch (fileName) {
    case 'vehiclefront':
      return Colors.teal.shade50;
    case 'vehicleback':
      return Colors.orange.shade50;
    case 'vehicleinvoice':
      return const Color(0xFFf2eeff);
    case 'driverid':
      return const Color(0xFF3681F2).withValues(alpha: 0.15);
    default:
      return Colors.grey.shade200;
  }
}
