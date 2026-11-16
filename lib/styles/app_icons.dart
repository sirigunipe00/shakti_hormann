import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';

class AppIcons {
  static const basePath = 'assets';
  static const imagesPath = '$basePath/images';
  static const iconsPath = '$basePath/logo';
  static const shaktiHormannLogo = AppIcon('$iconsPath/hormann-logo-new-1 1.png');
  // static const bubbles = AppIcon('$imagesPath/bubbles.svg');
  static const gateeEntry = AppIcon(
    '$imagesPath/gate_entry_loop.gif',
    stillPath: '$imagesPath/entry.png',
  );
  static const gateExit = AppIcon(
    '$imagesPath/gate_exit_loop.gif',
    stillPath: '$imagesPath/exit.png',
  );
  static const logisticRequest = AppIcon(
    '$imagesPath/logistic_request_loop.gif',
    stillPath: '$imagesPath/Logistics-pana 1.svg',
  );
  static const transportrterConfirmation = AppIcon(
    '$imagesPath/transport_confirmation_loop.gif',
    stillPath: '$imagesPath/transportconfirmation.svg',
  );
  static const mesSticker = AppIcon('assets/images/mes_sticker.jpeg');
  static const vehicleReporting = AppIcon(
    '$imagesPath/vehicle_reporting_loop.gif',
    stillPath: '$imagesPath/vehiclereportings.svg',
  );
  static const pod = AppIcon(
    '$imagesPath/proof_of_delivery_loop.gif',
    stillPath: '$imagesPath/loadingconfirmation.svg',
  );
  static const loadingConfirmation = AppIcon(
    '$imagesPath/dispatch_loading_loop.gif',
    stillPath: '$imagesPath/pod.svg',
  );
  static const gatemanagement = AppIcon(
    '$imagesPath/gate_management_loop.gif',
    stillPath: '$imagesPath/gate_management.png',
  );
  static const storage = AppIcon(
    '$imagesPath/storage_allocation_loop.gif',
    stillPath: '$imagesPath/storage_allocations.png',
  );
  static const zone = AppIcon('$imagesPath/zone.png');
  static const shutter = AppIcon(
    '$imagesPath/shutter_packaging_loop.gif',
    stillPath: '$imagesPath/shutter_packings.png',
  );
  static const frame = AppIcon(
    '$imagesPath/frame_packaging_loop.gif',
    stillPath: '$imagesPath/frame_pack.png',
  );
  static const hardware = AppIcon(
    '$imagesPath/hardware_packaging_loop.gif',
    stillPath: '$imagesPath/hardware.png',
  );
  static const whereismymaterial = AppIcon(
    '$imagesPath/where_is_my_material_loop.gif',
    stillPath: '$imagesPath/whereismymaterial.png',
  );
  static const pallet = AppIcon(
    '$imagesPath/pallet_creation_hammering.gif',
    stillPath: '$imagesPath/pallet_creation.png',
  );
  static const installation = AppIcon(
    '$imagesPath/installation_packaging_loop.gif',
    stillPath: '$imagesPath/installation_packing.png',
  );
  static const accessories = AppIcon(
    '$imagesPath/accessories_packaging_loop.gif',
    stillPath: '$imagesPath/vision_panel.png',
  );
  static const forkliftScanning = AppIcon(
    '$imagesPath/forklift_scanning_loop.gif',
    stillPath: '$imagesPath/forklift_scanning.png',
  );
}

class AppIcon {
  const AppIcon(this.path, {this.stillPath});

  final String path;
  /// Static fallback for reduced-motion / decode errors.
  final String? stillPath;

  Widget toWidget({
    double width = 60,
    double height = 30,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    final fileextension = extension(path).toLowerCase();
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
    final isAnimated = fileextension == '.gif' || fileextension == '.webp';
    return Image.asset(
      path,
      width: width,
      height: height,
      // Color filter freezes animated GIFs — only tint static assets.
      color: isAnimated ? null : color,
      fit: fit,
      gaplessPlayback: true,
      filterQuality: isAnimated ? FilterQuality.low : FilterQuality.medium,
      errorBuilder: stillPath == null
          ? null
          : (_, __, ___) {
              final stillExt = extension(stillPath!).toLowerCase();
              if (stillExt == '.svg') {
                return SvgPicture.asset(
                  stillPath!,
                  width: width,
                  height: height,
                  fit: fit,
                );
              }
              return Image.asset(
                stillPath!,
                width: width,
                height: height,
                fit: fit,
              );
            },
    );
  }
}
