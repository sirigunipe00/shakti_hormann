import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shakti_hormann/app/presentation/bloc/app_update_bloc_provider.dart';
import 'package:shakti_hormann/app/presentation/widgets/dashboard_item.dart';
import 'package:shakti_hormann/app/presentation/widgets/greeting_widget.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/utils/notification_usecase.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/styles/app_icons.dart';
import 'package:shakti_hormann/widgets/app_update_dailog.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  @override
  void initState() {
    super.initState();
    $sl.get<NotificationUsecase>().updateOSDetails();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  final List<DashboardItem> dashboardItems = [
    DashboardItem(
      title: 'Gate Entry',
      icon: AppIcons.gateeEntry,
      iconSize: const Size(140, 80),
      onTap: (context) {
        AppRoute.gateEntry.push<bool?>(context);
      },
      permissionSelector: (roleStatus) => roleStatus?.showGateEntry,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Gate Exit',
      icon: AppIcons.gateExit,
      iconSize: const Size(140, 80),
      onTap: (context) {
        AppRoute.gatexit.push<bool?>(context);
      },
      permissionSelector: (roleStatus) => roleStatus?.showGateExit,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Logistic Request',
      icon: AppIcons.logisticRequest,
      iconSize: const Size(120, 70),
      onTap: (context) {
        AppRoute.logisticRequest.push<bool?>(context);
      },
      permissionSelector: (roleStatus) => roleStatus?.showLogisticRequest,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Transport\nConfirmation',
      icon: AppIcons.transportrterConfirmation,
      onTap: (context) {
        AppRoute.transportConfirmation.push<bool?>(context);
      },
      permissionSelector:
          (roleStatus) => roleStatus?.showTransporterConfirmation,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Vehicle Reporting\nEntry',
      icon: AppIcons.vehicleReporting,
      onTap: (context) {
        AppRoute.vehcileReporting.push<bool?>(context);
      },
      permissionSelector: (roleStatus) => roleStatus?.showVehicleReporting,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Dispatch\nLoading',
      icon: AppIcons.loadingConfirmation,
      onTap: (context) {
        AppRoute.loadingConfirmation.push<bool?>(context);
      },
      permissionSelector: (roleStatus) => roleStatus?.showLoadingConfirmation,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Proof Of Delivery',
      icon: AppIcons.pod,
      onTap: (context) {
        AppRoute.proofOfDelivery.push<bool?>(context);
      },
      permissionSelector: (roleStatus) => roleStatus?.showpod,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Gate Management',
      icon: AppIcons.gatemanagement,
      iconSize: const Size(150, 100),
      onTap: (context) {
        AppRoute.gateManagement.push<bool?>(context);
      },
      permissionSelector: (roleStatus) => roleStatus?.showgateManagement,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Pallet Creation',
      icon: AppIcons.pallet,
      iconSize: const Size(130, 80),
      onTap: (context) {
        AppRoute.palletCreation.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showPallet,
    ),
    DashboardItem(
      title: 'Shutter Packaging',
      icon: AppIcons.shutter,
      permissionSelector: (roleStatus) => roleStatus?.showShutter,
      iconSize: const Size(150, 100),
      onTap: (context) {
        AppRoute.shutterPackaging.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
    ),
    DashboardItem(
      title: 'Frame Packaging',
      icon: AppIcons.frame,
      iconSize: const Size(150, 100),
      onTap: (context) {
        AppRoute.framePackaging.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showFrame,
    ),
    DashboardItem(
      title: 'Storage / Zone',
      icon: AppIcons.storage,
      iconSize: const Size(140, 80),
      onTap: (context) {
        AppRoute.storageAllocation.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showStorage,
    ),
    // DashboardItem(
    //   title: 'Zone Transfer',
    //   icon: AppIcons.zone,
    //   iconSize: const Size(140, 80),
    //   onTap: (context) {
    //     AppRoute.zoneTransfer.push<bool?>(context);
    //   },
    //   permissionSelector: (roleStatus) => roleStatus?.showgateManagement,
    // ),
    DashboardItem(
      title: 'Installation Packing',
      icon: AppIcons.installation,
      iconSize: const Size(150, 100),
      onTap: (context) {
        AppRoute.installation.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showInstalltion,
    ),
    DashboardItem(
      title: 'Accessories Packing',
      icon: AppIcons.accessories,
      iconSize: const Size(150, 100),
      onTap: (context) {
        AppRoute.visionPanel.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showVision,
    ),

    DashboardItem(
      title: 'Hardware Packaging',
      icon: AppIcons.hardware,
      iconSize: const Size(150, 100),
      onTap: (context) {
        AppRoute.hardwarePackaging.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showHardware,
    ),
  ];

void _showHardwareStickerPreview() {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.transparent,
        child: Container(
          width: (screenWidth - 40).clamp(0, 380).toDouble(),
          constraints: BoxConstraints(
            maxHeight: (screenHeight * 0.85).clamp(0, 640).toDouble(),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header band
              Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A3C6B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'MES Sticker Sample',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                      tooltip: 'Close',
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8FA),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8ECF4)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            AppIcons.mesSticker.path,
                            fit: BoxFit.contain,
                            height: 200,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 18,
                              color: Color(0xFF1A3C6B),
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Capture this sticker while creating hardware packing:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                                color: Color(0xFF0E1446),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const _StickerFieldChip(label: 'Sales Order No'),
                      const _StickerFieldChip(label: 'Box Count'),
                      const _StickerFieldChip(label: 'MES System No'),
                      const _StickerFieldChip(label: 'Item / Material details'),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3C6B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  Widget buildDashboardCard(DashboardItem item) {
    final isHardwarePackaging = item.title == 'Hardware Packaging';

    return GestureDetector(
      onTap: () => item.onTap(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE8ECF4), width: 2),
          boxShadow: [
            const BoxShadow(
              color: Color(0xFFFFFFFF),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
  clipBehavior: Clip.none,
  children: [
    Positioned.fill(                   
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            item.icon.toWidget(
              height: item.iconSize?.height ?? 60,
              width: item.iconSize?.width ?? 100,
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'Urbanist',
                color: Color(0xFF0E1446),
              ),
            ),
          ],
        ),
      ),
    ),                                
    if (isHardwarePackaging)
      Positioned(
        top: 8,
        right: 8,
        child: GestureDetector(
          onTap: () {
            _showHardwareStickerPreview();
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF1A3C6B).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: Color(0xFF1A3C6B),
            ),
          ),
        ),
      ),
  ],
),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser? user;
    try {
      user = $sl<LoggedInUser>();
    } catch (_) {
      user = null;
    }
    final roleStatus = user?.roleStatus;
    final hasPackingSupervisorRole =
      user?.roleProfileName?.trim() == 'Packing Supervisor-SH' ||
      user?.roles?.any(
          (role) => role.role?.trim() == 'Packing Supervisor-SH',
        ) ==
        true;
    final visibleItems =
      dashboardItems
        .where(
          (item) =>
            item.canShow(roleStatus) ||
            (hasPackingSupervisorRole &&
              item.section == DashboardSection.scanningPackaging),
        )
        .toList();
    final logisticsItems =
        visibleItems
            .where((e) => e.section == DashboardSection.logistics)
            .toList();

    final scanningItems =
        visibleItems
            .where((e) => e.section == DashboardSection.scanningPackaging)
            .toList();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<AppVersionCubit, AppVersionCubitState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  success: (data) {
                    if (data) {
                      showDialog(
                        context: context,
                        builder:
                            (ctx) => const AppUpdateDialog(
                              appName: 'ShaktiHormann',
                              packageName: 'in.easycloud.shakti_hormann',
                            ),
                        barrierDismissible: false,
                      );
                    }
                  },
                );
              },
            ),
            // BlocListener<GeoPermissionHandler, GeoPermissionState>(
            //   listenWhen: (previous, current) => previous != current,
            //   listener: (_, state) async {
            //     final routerCtxt = AppRouterConfig.context;

            //     log('state..:$state');
            //     if (state is GeoLocationServiceDisabled) {
            //       print('true...:');
            //       showDialog(
            //         context: context,
            //         barrierDismissible: false,
            //         builder:
            //             (_) => AlertDialog(
            //               title: const Text('Location Disabled'),
            //               content: const Text(
            //                 'Please enable location to continue.',
            //               ),
            //               actions: [
            //                 TextButton(
            //                   onPressed: () async {
            //                     await Geolocator.openLocationSettings();
            //                     context
            //                         .read<GeoPermissionHandler>()
            //                         .checkPermission();
            //                   },
            //                   child: const Text('Enable'),
            //                 ),
            //               ],
            //             ),
            //       );
            //     }
            //     if (state is GeoLocationDenied) {
            //       Geolocator.requestPermission().then((_) {
            //         routerCtxt.cubit<GeoPermissionHandler>().checkPermission();
            //       });
            //       return;
            //     }
            //     if (state is GeoLocationDeniedForever ||
            //         state is LocationPermissionPermDenied) {
            //       AppDialog.showErrorDialog<bool?>(
            //         routerCtxt,
            //         barrierDismissible: false,
            //         title: 'Grant Location Permission',
            //         content: 'Shakti Hormann needs your location permission',
            //         buttonText: 'Allow',
            //         onTapDismiss: () => routerCtxt.exit(true),
            //       ).then((value) async {
            //         if (value!.isTrue) {
            //           _shouldRequestPermission = true;
            //           await Geolocator.openAppSettings();
            //         }
            //       });
            //     }
            //   },
            // ),
          ],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const GreetingHeader(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () => AppRoute.notifications.push(context),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Center(
                                child: SvgPicture.asset(
                                  'assets/images/notification.svg',
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                              Positioned(
                                top: -2,
                                right: -2,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: logisticsItems.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemBuilder: (context, index) {
                            return buildDashboardCard(logisticsItems[index]);
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Scanning & Packaging',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E1446),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: scanningItems.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemBuilder: (context, index) {
                            return buildDashboardCard(scanningItems[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _StickerFieldChip extends StatelessWidget {
  const _StickerFieldChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF1A3C6B),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ),
    );
  }
}