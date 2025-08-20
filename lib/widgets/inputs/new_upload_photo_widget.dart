import 'dart:io';
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
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final selectedImage = File(pickedFile.path);
        debugPrint('🖼️ Image picked from gallery: ${selectedImage.path}');

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
    return 'http://65.21.243.18:8000$url';
  }

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      defaultHeight: 4,
      margin: EdgeInsets.zero,
      children: [
        GestureDetector(
          onTap: () {
            if (widget.isReadOnly) return;

            if (_photoState == PhotoState.view) {
              context.goToPage(
                ImagePreviewPage(
                  imageUrl: widget.imageUrl,
                  image: _selectedImage,
                  title: widget.title.valueOrEmpty,
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
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              height: 80,
              width: 90,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.0),
                child:
                    _photoState == PhotoState.capture
                        ? Image.asset(
                          'assets/images/${widget.fileName}.png',
                          fit: BoxFit.fill,
                        )
                        : (_selectedImage != null
                            ? Image.file(_selectedImage!, fit: BoxFit.cover)
                            : (widget.imageUrl != null
                                ? Image.network(
                                  getFullImageUrl(widget.imageUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/${widget.fileName}.png', 
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                                : Image.asset(
                                  'assets/images/${widget.fileName}.png',
                                  fit: BoxFit.fill,
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

class ImagePreviewPage extends StatelessWidget {
  const ImagePreviewPage({
    super.key,
    required this.image,
    required this.imageUrl,
    required this.title,
    required this.onRetake,
    required this.onDone,
  });

  final String title;
  final File? image;
  final String? imageUrl;
  final VoidCallback onRetake;
  final VoidCallback onDone;

  String getFullImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return 'http://65.21.243.18:8000$url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          if (image != null) ...[
            SizedBox(
              height: 400,
              width: context.sizeOfWidth,
              child: Card(
                shape: Border.all(color: AppColors.green),
                child: Image.file(image!, fit: BoxFit.fill),
              ),
            ),
          ] else if (imageUrl.containsValidValue) ...[
            SizedBox(
              height: 400,
              width: context.sizeOfWidth,
              child: Card(
                shape: Border.all(color: AppColors.green),
                child: Image.network(
                  getFullImageUrl(imageUrl), // ✅ Use helper
                  fit: BoxFit.fill,
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.grey,
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                    ),
                    onPressed: onRetake,
                    child: const Text(
                      'RETAKE',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                    ),
                    onPressed: onDone,
                    child: const Text(
                      'DONE',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
