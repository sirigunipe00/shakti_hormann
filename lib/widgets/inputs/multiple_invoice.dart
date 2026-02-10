import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';


class MultipleImageUploadWidget extends StatefulWidget {
  const MultipleImageUploadWidget({
    super.key,
    required this.title,
    this.localFiles,
    this.serverUrls,
    this.isReadOnly = false,
    required this.onLocalFileAdded,
    required this.onLocalFileRemoved,
    required this.onServerFileRemoved,
    this.showAddButton = true,
  });

  final String title;
  final List<File>? localFiles;
  final bool showAddButton;
  final List<String>? serverUrls;
  final bool isReadOnly;
  final Function(File) onLocalFileAdded;
  final Function(int) onLocalFileRemoved;
  final Function(int) onServerFileRemoved;

  @override
  State<MultipleImageUploadWidget> createState() => _MultipleImageUploadWidgetState();
}

class _MultipleImageUploadWidgetState extends State<MultipleImageUploadWidget> {
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (image != null) {
      widget.onLocalFileAdded(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = widget.localFiles ?? [];
    final server = widget.serverUrls ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(widget.title, 
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Urbanist')),
        ),

        SizedBox(
          height: 110, 
          child: ListView(
            key: ValueKey(local.length + server.length),
            scrollDirection: Axis.horizontal,
            children: [
              if (!widget.isReadOnly && widget.showAddButton) _PlusAddTile(onTap: _pickImage),


              ...server.asMap().entries.map((e) => _Thumb(
                    image: NetworkImage(Urls.filepath(e.value)),
                    onTap: () => _openPreview(context, imageUrl: e.value, isReadOnly: true),
                    onRemove: widget.isReadOnly ? null : () => widget.onServerFileRemoved(e.key),
                  )),


              ...local.asMap().entries.map((e) => _Thumb(
                    image: FileImage(e.value),
                    onTap: () => _openPreview(context, imageFile: e.value, isReadOnly: false),
                    onRemove: widget.isReadOnly ? null : () => widget.onLocalFileRemoved(e.key),
                  )),
            ],
          ),
        ),
      ],
    );
  }


void _openPreview(BuildContext context, {File? imageFile, String? imageUrl, required bool isReadOnly}) {
  context.goToPage(PreviewPage(
    image: imageFile,      
    imageUrl: imageUrl,  
    title: widget.title,
    isReadOnly: isReadOnly,
    onRetake: () {}, 
    onDone: () => Navigator.pop(context),
  ));
}
}
class PreviewPage extends StatefulWidget {
  const PreviewPage({
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
  State<PreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<PreviewPage> {
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
            // if (!widget.isReadOnly) ...[
            //   Expanded(
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: AppColors.darkBlue,
            //       ),
            //       onPressed: widget.onRetake,
            //       child: const Text(
            //         'RETAKE',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            //   const SizedBox(width: 12),
            // ],
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

class _Thumb extends StatelessWidget {
  const _Thumb({required this.image, this.onTap, this.onRemove});
  final ImageProvider image;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [

          Container(
            width: 90,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: image, fit: BoxFit.cover),
            ),
          ),
          

          Positioned.fill(
            child: Material(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility, color: Colors.white, size: 20),
                      Text('View', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),


          if (onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.red, size: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
class _PlusAddTile extends StatelessWidget {
  const _PlusAddTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 100,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.grey.shade100,
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 36,
            color: Colors.pink,
          ),
        ),
      ),
    );
  }
}
