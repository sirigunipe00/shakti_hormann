import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';

class AppIcons {
  static const basePath = 'assets';
  static const imagesPath = '$basePath/images';
  static const iconsPath = '$basePath/logo';
  static const shaktiHormannLogo = AppIcon('$iconsPath/hormann-logo-new-1 1.png');
  // static const bubbles = AppIcon('$imagesPath/bubbles.svg');
  static const gateeEntry = AppIcon('$imagesPath/entry.png');
  static const gateExit = AppIcon('$imagesPath/exit.png');
  static const logisticRequest = AppIcon('$imagesPath/Logistics-pana 1.svg');
  static const transportrterConfirmation = AppIcon(
    '$imagesPath/transportconfirmation.svg',
  );
  static const mesSticker = AppIcon('assets/images/mes_sticker.jpeg');
  static const vehicleReporting = AppIcon('$imagesPath/vehiclereportings.svg');
  static const pod = AppIcon('$imagesPath/loadingconfirmation.svg');
  static const loadingConfirmation = AppIcon('$imagesPath/pod.svg');
  static const gatemanagement = AppIcon('$imagesPath/gate_management.png');
  static const storage = AppIcon('$imagesPath/storage_allocations.png');
  static const zone = AppIcon('$imagesPath/zone.png');
  static const shutter = AppIcon('$imagesPath/shutter_packings.png');
  static const frame = AppIcon('$imagesPath/frame_pack.png');
  static const hardware = AppIcon('$imagesPath/hardware.png');
  static const pallet = AppIcon('$imagesPath/pallet_creation.png');
  static const installation = AppIcon('$imagesPath/installation_packing.png');
  static const accessories = AppIcon('$imagesPath/vision_panel.png');
}

class AppIcon {
  const AppIcon(this.path);

  final String path;

  Widget toWidget({
    double width = 60,
    double height = 30,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    final fileextension = extension(path);
    if (fileextension == '.svg') {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        fit: fit,
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      color: color,
      fit: fit,
    );
  }
}
