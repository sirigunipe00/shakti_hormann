import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File imageFile;
  final VoidCallback onDone;
  final VoidCallback onRecapture;

  const ImagePreviewScreen({
    Key? key,
    required this.imageFile,
    required this.onDone,
    required this.onRecapture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Preview'),
        backgroundColor: Colors.black,
      ),

      body: Container(
        
        child: Column(
          children: [
            Expanded(child: Center(child: Image.file(imageFile))),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        onDone();
                        Navigator.pop(context);
                      },
                      // icon: const Icon(Icons.check),
                      label: const Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
        
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onRecapture,
                      // icon: const Icon(Icons.camera_alt),
                      label: const Text(
                        'Recapture',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
