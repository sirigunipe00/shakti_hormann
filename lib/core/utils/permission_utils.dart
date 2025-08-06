// permission_utils.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> ensureCameraPermission(BuildContext context) async {
  final status = await Permission.camera.request();
  if (status.isGranted) return true;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Camera permission is required.')),
  );

  if (status.isPermanentlyDenied) {
    await openAppSettings();
  }

  return false;
}
