import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class PackingStickerPreviewImage extends StatelessWidget {
  const PackingStickerPreviewImage({
    super.key,
    required this.path,
    this.fit = BoxFit.contain,
  });

  final String path;
  final BoxFit fit;

  bool get _isNetwork => path.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      return Image.network(
        path,
        fit: fit,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return const _ImageLoadingIndicator();
        },
        errorBuilder: (_, __, ___) => const _BrokenImagePreview(),
      );
    }

    return Image.file(
      File(path),
      fit: fit,
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return const _ImageLoadingIndicator();
      },
      errorBuilder: (_, __, ___) => const _BrokenImagePreview(),
    );
  }
}

class PackingStickerGalleryPage extends StatefulWidget {
  const PackingStickerGalleryPage({
    super.key,
    required this.photoUrls,
    this.initialIndex = 0,
  });

  final List<String> photoUrls;
  final int initialIndex;

  @override
  State<PackingStickerGalleryPage> createState() =>
      _PackingStickerGalleryPageState();
}

class _PackingStickerGalleryPageState extends State<PackingStickerGalleryPage> {
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
          return Center(
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: PackingStickerPreviewImage(path: widget.photoUrls[i]),
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
}

class _ImageLoadingIndicator extends StatelessWidget {
  const _ImageLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 36,
        height: 36,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: AppColors.darkBlue,
        ),
      ),
    );
  }
}

class _BrokenImagePreview extends StatelessWidget {
  const _BrokenImagePreview();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, size: 80, color: Colors.grey),
        SizedBox(height: 12),
        Text('Failed to load image', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
