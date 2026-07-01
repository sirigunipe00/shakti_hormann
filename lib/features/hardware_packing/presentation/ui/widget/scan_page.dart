import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanHardWarePage extends StatefulWidget {
  const ScanHardWarePage({super.key});

  @override
  State<ScanHardWarePage> createState() => _ScanHardWarePageState();
}

class _ScanHardWarePageState extends State<ScanHardWarePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureImage();
    });
  }

  Future<void> _captureImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );

    if (picked == null) {
      if (mounted) Navigator.pop(context);
      return;
    }
    if (mounted) {
  Navigator.pop(context, File(picked.path));
}
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
