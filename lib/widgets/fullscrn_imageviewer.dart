import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';


class FullScreenImageViewer extends StatelessWidget {
  const FullScreenImageViewer({
    super.key,
    this.imageFile,
    this.imageUrl,
    required this.onRetake,
    required this.isRetake,
  });

  final File? imageFile;
  final String? imageUrl;
  final VoidCallback onRetake;
  final bool isRetake;

  @override
  Widget build(BuildContext context) {
    print('imageUrl-----:$imageUrl');
    final bool hasImage = imageFile != null || imageUrl != null;

    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: AppColors.seaGrass,
      //   title: const Text('Image Preview'),
      //   actions: const [DrawerIconBtn()],
      //   toolbarHeight: 80,
      // ),
      // endDrawer: const AppEndDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.green, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: hasImage
                  ? imageFile != null
                      ? Image.file(
                          imageFile!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Failed to load image.');
                          },
                        )
                      : Image.network(
                          imageUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Failed to load image.');
                          },
                        )
                  : const Text('No image available'),
            ),
          ),
          const SizedBox(height: 24),
          if (isRetake)
            ElevatedButton(
              onPressed: onRetake,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Retake',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
