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

class PodPhotoWidget extends StatefulWidget {
  const PodPhotoWidget({
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
  State<PodPhotoWidget> createState() => _PodPhotoWidgetState();
}

class _PodPhotoWidgetState extends State<PodPhotoWidget>
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

  /// 🔥 NEW — Bottom sheet for Camera + Gallery
  Future<void> _showImagePickOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _capture(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _capture(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔥 UPDATED — Works for both camera & gallery
  Future<void> _capture(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final selectedImage = File(pickedFile.path);

        setState(() {
          _selectedImage = selectedImage;
          _photoState = PhotoState.view;
        });

        widget.onFileCapture(selectedImage);
      }
    } catch (e) {
      debugPrint('❌ Image pick error: $e');
    }
  }

  String getFullImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
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
            if (widget.isReadOnly) {
              if (_photoState == PhotoState.view) {
                context.goToPage(
                  ImagePreviewPage(
                    imageUrl: widget.imageUrl,
                    image: _selectedImage,
                    title: widget.title.valueOrEmpty,
                    isReadOnly: true,
                    onRetake: () {},
                    onDone: () => Navigator.pop(context),
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
                    _showImagePickOptions();
                  },
                  onDone: () => Navigator.pop(context),
                ),
              );
            } else {
              _showImagePickOptions();
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
                child: _photoState == PhotoState.capture
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
                                errorBuilder: (_, __, ___) => Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    'assets/images/${widget.fileName}.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
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
                child: Transform.rotate(
                  angle: rotationAngle,
                  child: imageWidget,
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
