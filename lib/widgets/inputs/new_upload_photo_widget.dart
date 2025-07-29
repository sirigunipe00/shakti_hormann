import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/consts/urls.dart';
import 'package:shakti_hormann/core/utils/attachment_selection_mixin.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';
import 'package:shakti_hormann/widgets/fullscrn_imageviewer.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';


class NewUploadPhotoWidget extends StatefulWidget {
  const NewUploadPhotoWidget({
    super.key,
    this.title,
    this.defaultValue,
    this.imageUrl,
    this.readOnly = false,
    required this.onFileCapture,
    required this.isretake,
    this.isRequired = false,
    required this.onGetUpi,
  });

  final String? title;
  final String? imageUrl;
  final String? defaultValue;
  final bool readOnly;
  final bool isretake;
  final bool isRequired;
  final Function(File? file) onFileCapture;
  final Function(String? file) onGetUpi;

  @override
  State<NewUploadPhotoWidget> createState() => _NewUploadPhotoWidgetState();
}

class _NewUploadPhotoWidgetState extends State<NewUploadPhotoWidget>
    with AttahcmentSelectionMixin {
  File? capturedFile;
  String? networkImageUrl;

  @override
  void initState() {
    super.initState();

    if (widget.defaultValue != null) {
      // Check if it's a base64 string or a URL
      if (widget.defaultValue!.startsWith('/files/')) {
        final baseUrl = getbaseUrl();
        print('baseUrl----:$baseUrl');
        networkImageUrl = '$baseUrl${widget.defaultValue}';

        print('networkImageUrl---:$networkImageUrl');
      } else {
        try {
          final bytes = base64Decode(widget.defaultValue!);
          final tempFile = File('${Directory.systemTemp.path}/temp_img.jpg')
            ..writeAsBytesSync(bytes);
          capturedFile = tempFile;
        } catch (_) {
          // Not a valid base64 string, ignore
        }
      }
    }
  }

  String getbaseUrl() {
    String baseUrl;
    if (Urls.isTest) {
      baseUrl = 'https://m11ucouat.easycloud.co.in/';
    } else {
      baseUrl = 'https://rucoprd.sunpure.in/';
    }
    return baseUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title!.isNotEmpty)
          CaptionText(
            title: widget.title ?? '',
            isRequired: widget.isRequired,
          ),
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.green),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: widget.readOnly
                ? const Text('Read-only')
                : capturedFile == null && networkImageUrl == null
                    ? IconButton(
                        icon: const Icon(Icons.add_a_photo,
                            size: 38, color: AppColors.green),
                        onPressed: _captureImage,
                      )
                    : TextButton(
                        onPressed: _viewImage,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
          ),
        ),
      ],
    );
  }

  // Future<void> _captureImage() async {
  //   final file = await captureImage();
  //   if (file != null) {
  //     setState(() => capturedFile = file);
  //     widget.onFileCapture(file);
  //   }
  // }

  Future<void> _captureImage() async {
    final file = await captureImage();
    if (file != null) {
      setState(() => capturedFile = file);
      widget.onFileCapture(file);
      final upiId = await extractUpiIdFromImage(file);
      if (upiId != null) {
        print('Extracted UPI ID: $upiId');
        widget.onGetUpi(upiId);
      } else {
        widget.onGetUpi('');
        print('No UPI ID found in QR');
      }
    }
  }

  // Future<String?> _extractUpiIdFromImage(File imageFile) async {
  //   final inputImage = InputImage.fromFile(imageFile);
  //   final barcodeScanner = GoogleMlKit.vision.barcodeScanner([
  //     BarcodeFormat.qrCode,
  //   ]);

  //   final barcodes = await barcodeScanner.processImage(inputImage);
  //   await barcodeScanner.close();

  //   print('barcodes--:$barcodes');

  //   for (final barcode in barcodes) {
  //     final rawValue = barcode.rawValue ?? '';
  //     if (rawValue.startsWith('upi://')) {
  //       final uri = Uri.tryParse(rawValue);
  //       return uri?.queryParameters['pa']; // UPI ID
  //     }
  //   }
  //   return null;
  // }


  Future<String?> extractUpiIdFromImage(File imageFile) async {
  final inputImage = InputImage.fromFile(imageFile);

  // Only scanning for QR codes
  final barcodeScanner = BarcodeScanner(
    formats: [BarcodeFormat.qrCode],
  );

  final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
  await barcodeScanner.close();

  for (final barcode in barcodes) {
    final rawValue = barcode.rawValue ?? '';

    if (rawValue.startsWith('upi://')) {
      final uri = Uri.tryParse(rawValue);
      return uri?.queryParameters['pa']; // pa = Payee Address (UPI ID)
    }
  }

  return null;
}



  void _viewImage() {
    if (capturedFile == null && networkImageUrl == null) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FullScreenImageViewer(
        isRetake: widget.isretake,
        imageFile: capturedFile,
        imageUrl: networkImageUrl,
        onRetake: () async {
          print('on retake');
          final file = await captureImage();
          print('file---:$file');
          if (file != null) {
            print(' ------- file:---:$file');
            setState(() {
              capturedFile = file;
              widget.onFileCapture(capturedFile);
            });

            final upiId = await extractUpiIdFromImage(file);
            if (upiId != null) {
              widget.onGetUpi(upiId);
            } else {
              widget.onGetUpi(''); 
            }
          }
          Navigator.of(context).pop();
        },
      ),
    ));
  }
}
