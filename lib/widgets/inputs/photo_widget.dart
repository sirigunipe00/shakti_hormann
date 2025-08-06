import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakti_hormann/widgets/inputs/image_preview%20scrn.dart';

class PhotoSelectionWidget extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final String? imagePath;
  final Function(File file)? onImageSelected;

  const PhotoSelectionWidget({
    Key? key,
    required this.label,
    this.imagePath,
    required this.backgroundColor,
    this.onImageSelected, String? initialValue,
  }) : super(key: key);

  @override
  State<PhotoSelectionWidget> createState() => _PhotoSelectionWidgetState();
}

class _PhotoSelectionWidgetState extends State<PhotoSelectionWidget> {
  File? _selectedImage;

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
      widget.onImageSelected?.call(_selectedImage!);
    }
  }

  void _onImageTap() {
    if (_selectedImage == null) {
      _openCamera();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ImagePreviewScreen(
            imageFile: _selectedImage!,
            onDone: () {},
            onRecapture: () async {
              Navigator.of(context).pop(); // Close preview
              await _openCamera();         // Reopen camera
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onImageTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                _selectedImage == null
                    ? (widget.imagePath != null
                        ? Image.asset(
                            widget.imagePath!,
                            width: 50,
                            height: 50,
                          )
                        : const Icon(Icons.image, size: 30))
                    : ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                if (_selectedImage != null)
                  const CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.check_circle, size: 16, color: Colors.green),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
