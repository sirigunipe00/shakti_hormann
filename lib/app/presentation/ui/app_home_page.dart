import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/bloc/app_update_bloc_provider.dart';
import 'package:shakti_hormann/app/presentation/widgets/dashboard_item.dart';
import 'package:shakti_hormann/app/presentation/widgets/greeting_widget.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/utils/notification_usecase.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/forklift/data/forklift_repo.dart';
import 'package:shakti_hormann/styles/app_icons.dart';
import 'package:shakti_hormann/widgets/app_update_dailog.dart';
import 'package:shakti_hormann/widgets/feature_card_icon.dart';

class _InfoContent {
  const _InfoContent({
    required this.title,
    this.icon = Icons.qr_code_2_rounded,
    this.stickerAsset,
    this.stickerCaption,
    this.stickerFields = const [],
    this.stepsTitle = 'Process',
    this.steps = const [],
  });

  final String title;
  final IconData icon;
  final String? stickerAsset;
  final String? stickerCaption;
  final List<String> stickerFields;
  final String stepsTitle;
  final List<String> steps;
}

final Map<String, _InfoContent> _cardInfo = {
  'Hardware Packaging': _InfoContent(
    title: 'MES Sticker Sample',
    stickerAsset: AppIcons.mesSticker.path,
    stickerCaption: 'Capture this sticker while creating hardware packing:',
    stickerFields: const [
      'Sales Order No (from OR. on sticker)',
      'Box Count / page details',
      'MES System / barcode number',
      'Item lines (SAP, Qty, UOM)',
    ],
  ),
  'Shutter Packaging': const _InfoContent(
    title: 'Shutter Packing Sticker',
    stickerAsset: 'assets/images/shutter_sticker.jpeg',
    stickerCaption: 'Capture this sticker while creating shutter packing:',
    stickerFields: [
      'Sales Order No (SO)',
      'Pallet Type',
      'Save',
      'Scan the Items/Upload a Sticker Item',
      'Freeze the Qty',
      'Print the Sticker',
      'Take a Shutter Image',
      'Save',
    ],
  ),
  'Frame Packaging': const _InfoContent(
    title: 'Frame Packing Sticker',
    stickerAsset: 'assets/images/frame_sticker.jpeg',
    stickerCaption: 'Capture this sticker while creating frame packing:',
    stickerFields: [
      'Sales Order No (SO)',
      'Pallet Type',
      'Save',
      'Scan the Items/Upload a Sticker Item',
      'Freeze the Qty',
      'Print the Sticker',
      'Take a Frame Image',
      'Save',
    ],
  ),
  'Accessories Packaging': const _InfoContent(
    title: 'Accessories Packaging Sticker',
    stickerAsset: 'assets/images/vision_sticker.jpeg',
    stickerCaption: 'Capture this sticker while creating accessories packaging:',
    stickerFields: [
      'Sales Order No (SO)',
      'Add At least one Item To Save the Record',
      'Take a Accessories Image',
      'Repeat the Process for all the Items',
      'Submit',
    ],
  ),
  'Installation Packaging': const _InfoContent(
    title: 'Installation Packaging Sticker',
    stickerAsset: 'assets/images/installation_sticker.jpeg',
    stickerCaption:
        'Capture this sticker while creating installation packaging:',
    stickerFields: [
      'Sales Order No (SO)',
      'Enter No of Boxes',
      'Save the Box Information',
      'Print the Sticker',
      'Take a Installation Images',
      'Submit',
    ],
  ),
  'Pallet Creation': const _InfoContent(
    title: 'Pallet Creation Process',
    icon: Icons.inventory_2_rounded,
    stepsTitle: 'How to create a pallet',
    steps: [
      'Select the Sales Order.',
      'Tap "Add Item".',
      'Select the Product Type.',
      'Select the product Width and Height.',
      'Add at least one item. A record can only be saved or created with one item or more.',
      'Save / Create the pallet record.',
      'After saving, you can edit the pallets or Submit.',
    ],
  ),
  'Storage Allocation': const _InfoContent(
    title: 'Storage Allocation Process',
    icon: Icons.warehouse_rounded,
    stepsTitle: 'How to allocate storage',
    steps: [
      'Scan the Pallet or Box.',
      'Scan the Zone you want to allocate.',
      'Capture the image of the allocated zone.',
      'Save.',
    ],
  ),
  'Gate Entry': const _InfoContent(
    title: 'Gate Entry Process',
    icon: Icons.login_rounded,
    stepsTitle: 'How to create a Gate Entry',
    steps: [
      'Open New Gate Entry.',
      'Select one or more Purchase Order numbers.',
      'Enter Vendor Invoice No and Vendor Invoice Date.',
      'Enter the Vehicle Number.',
      'Capture Vehicle Front Photo.',
      'Capture Vehicle Back Photo.',
      'Capture Vendor Invoice Photo.',
      'Tap Create / Save to draft the entry.',
      'Review the details, then Submit when ready.',
    ],
  ),
  'Gate Exit': const _InfoContent(
    title: 'Gate Exit Process',
    icon: Icons.logout_rounded,
    stepsTitle: 'How to create a Gate Exit',
    steps: [
      'Open New Gate Exit.',
      'Confirm Plant Name is filled.',
      'Select the Sales Invoice number(s).',
      'Enter / confirm the Vehicle Number.',
      'Capture Vehicle Front Photo.',
      'Capture Vehicle Back Photo.',
      'Tap Create / Save to draft the exit.',
      'Review the details, then Submit when ready.',
    ],
  ),
  'Logistic Request': const _InfoContent(
    title: 'Logistic Request Process',
    icon: Icons.local_shipping_rounded,
    stepsTitle: 'How to create a Logistic Request',
    steps: [
      'Open New Logistic Request.',
      'Search and select the Sales Order No.',
      'Select Transporter Type and Dispatch Type.',
      'Select the Transporter.',
      'Select Preferred Vehicle Type.',
      'Enter Requested Delivery Date and Time.',
      'Add any special instructions if needed.',
      'Tap Create / Save to draft the request.',
      'Review, then Submit when ready (status moves to transporter confirmation).',
    ],
  ),
  'Transport Confirmation': const _InfoContent(
    title: 'Transport Confirmation Process',
    icon: Icons.handshake_rounded,
    stepsTitle: 'How to confirm transport',
    steps: [
      'Open the pending Transport Confirmation from the list.',
      'Enter Driver Name.',
      'Enter Vehicle Number.',
      'Enter a valid 10-digit Driver Mobile No (starts with 6–9).',
      'Enter Estimated Arrival Date and Time.',
      'Add transporter remarks if needed.',
      'Tap Save / Confirm to accept the request.',
      'Use Reject only when needed, and enter a reject reason.',
    ],
  ),
  'Vehicle Reporting Entry': const _InfoContent(
    title: 'Vehicle Reporting Process',
    icon: Icons.directions_car_filled_rounded,
    stepsTitle: 'How to report a vehicle',
    steps: [
      'Open New Vehicle Reporting Entry.',
      'Select the linked Logistic Request / Transporter Confirmation No.',
      'Confirm Plant Name is filled.',
      'Enter Arrival Date and Arrival Time.',
      'Capture Driver ID Photo.',
      'Tap Create / Save to draft the reporting entry.',
      'Review, then Accept or Reject the vehicle reporting entry.',
    ],
  ),
  'Dispatch Loading': const _InfoContent(
    title: 'Dispatch Loading Process',
    icon: Icons.inventory_2_rounded,
    stepsTitle: 'How to complete Dispatch Loading',
    steps: [
      'Open the Vehicle Reporting / Dispatch Loading record.',
      'Confirm item lines are available for loading.',
      'Use Multi-Scan to scan Pallet / Box QR codes.',
      'Capture a photo for each scanned item.',
      'Capture the Loaded Vehicle Photo.',
      'Save progress as needed.',
      'Submit when all scanned items have photos and loading is complete.',
    ],
  ),
  'Proof Of Delivery': const _InfoContent(
    title: 'Proof Of Delivery Process',
    icon: Icons.fact_check_rounded,
    stepsTitle: 'How to create Proof of Delivery',
    steps: [
      'Open New Proof Of Delivery.',
      'Select the Invoice No.',
      'Capture POD Photo (signed delivery proof).',
      'Capture Unloading Photo.',
      'Add remarks if needed.',
      'Tap Create / Save to draft the POD.',
      'Review, then Submit to complete delivery confirmation.',
    ],
  ),
  'Gate Management': const _InfoContent(
    title: 'Gate Management Process',
    icon: Icons.apartment_rounded,
    stepsTitle: 'How to manage gate movement',
    steps: [
      'Open New Gate Management.',
      'Select Request Type if applicable (e.g. Amazon / Swiggy special flow).',
      'Capture Vehicle Front Photo.',
      'Capture Vehicle Back Photo.',
      'Capture Document / Invoice Photo (optional).',
      'Tap Create / Save to draft the gate movement.',
      'Before final Submit (non-special flow), enter Gate Exit Date and Gate Exit Time.',
      'Submit when the vehicle has exited.',
    ],
  ),
  'Forklift Operator': const _InfoContent(
    title: 'Forklift Operator Process',
    icon: Icons.forklift,
    stepsTitle: 'How to log in / log out of a forklift',
    steps: [
      'Open Forklift Operator.',
      'Tap New / Scan and scan the QR sticker on the forklift (or enter the code).',
      'If the forklift is free, confirm Login to start your session.',
      'If you are still logged in on another forklift, log out from that session first.',
      'Use the forklift while your session is active.',
      'To log out, open the active session and scan the same forklift QR again.',
      'Logout without scanning the QR is not allowed.',
    ],
  ),
};

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  /// From [get_forklift_home_summary]; null until loaded / on failure.
  int? _apiShowForkliftOperator;

  @override
  void initState() {
    super.initState();
    $sl.get<NotificationUsecase>().updateOSDetails();
    _loadForkliftHomeFlags();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _loadForkliftHomeFlags() async {
    if (!$sl.isRegistered<ForkliftRepo>()) return;
    final result = await $sl.get<ForkliftRepo>().getHomeSummary();
    if (!mounted) return;
    result.fold((_) {}, (summary) {
      setState(() {
        _apiShowForkliftOperator = summary.showForkliftOperator;
      });
    });
  }

  late final List<DashboardItem> dashboardItems = [
    DashboardItem(
      title: 'Gate Entry',
      icon: AppIcons.gateeEntry,
      onTap: (context) {
        AppRoute.gateEntry.push<bool?>(context);
      },
      permissionSelector: (roleStatus) => roleStatus?.showGateEntry,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Gate Exit',
      icon: AppIcons.gateExit,
      onTap: (context) {
        AppRoute.gatexit.push<bool?>(context);
      },
      permissionSelector: (roleStatus) => roleStatus?.showGateExit,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Logistic Request',
      icon: AppIcons.logisticRequest,
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
      onTap: (context) {
        AppRoute.gateManagement.push<bool?>(context);
      },
      permissionSelector: (roleStatus) => roleStatus?.showgateManagement,
      section: DashboardSection.logistics,
    ),
    DashboardItem(
      title: 'Pallet Creation',
      icon: AppIcons.pallet,
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
      onTap: (context) {
        AppRoute.shutterPackaging.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
    ),
    DashboardItem(
      title: 'Frame Packaging',
      icon: AppIcons.frame,
      onTap: (context) {
        AppRoute.framePackaging.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showFrame,
    ),
    DashboardItem(
      title: 'Storage Allocation',
      icon: AppIcons.storage,
      onTap: (context) {
        AppRoute.storageAllocation.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showStorage,
    ),
    DashboardItem(
      title: 'Installation Packaging',
      icon: AppIcons.installation,
      onTap: (context) {
        AppRoute.installation.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showInstalltion,
    ),
    DashboardItem(
      title: 'Accessories Packaging',
      icon: AppIcons.accessories,
      onTap: (context) {
        AppRoute.visionPanel.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showVision,
    ),
    DashboardItem(
      title: 'Hardware Packaging',
      icon: AppIcons.hardware,
      onTap: (context) {
        AppRoute.hardwarePackaging.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showHardware,
    ),
    DashboardItem(
      title: 'Where Is My\nMaterial?',
      icon: AppIcons.whereismymaterial,
      onTap: (context) {
        AppRoute.whereIsMyMaterial.push(context);
      },
      section: DashboardSection.scanningPackaging,
      permissionSelector: (roleStatus) => roleStatus?.showWhereIsMyMaterial,
    ),
    DashboardItem(
      title: 'Forklift Operator',
      icon: AppIcons.forkliftScanning,
      onTap: (context) {
        AppRoute.forkliftOperator.push<bool?>(context);
      },
      section: DashboardSection.scanningPackaging,
      // Show unless Role Status explicitly turns it off (0).
      // Null = backend field not shipped yet → still show.
      // Status opens from the Forklift Operator app bar icon (not a home card).
      permissionSelector: (roleStatus) => roleStatus?.showForkliftOperator,
    ),
  ];

  EdgeInsets _homeGridPadding(
    BuildContext context, {
    double top = 0,
    double bottom = 0,
  }) {
    final base = Responsive.pagePadding(context);
    final inset = Responsive.homeGridSideInset(context);
    return EdgeInsets.fromLTRB(
      base.left + inset,
      top,
      base.right + inset,
      bottom,
    );
  }

  void _showInfoDialog(_InfoContent info) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          backgroundColor: Colors.transparent,
          child: Container(
            width: (screenWidth - 36).clamp(0, 400).toDouble(),
            constraints: BoxConstraints(
              maxHeight: (screenHeight * 0.88).clamp(0, 720).toDouble(),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0E2A5C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAC12F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          info.stickerAsset != null
                              ? Icons.document_scanner_rounded
                              : info.icon,
                          color: const Color(0xFF0E2A5C),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          info.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (info.stickerAsset != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2F7),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFCBD5E1),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0E1446)
                                            .withValues(alpha: 0.08),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: AspectRatio(
                                    aspectRatio: 0.72,
                                    child: InteractiveViewer(
                                      minScale: 1,
                                      maxScale: 3.5,
                                      child: Image.asset(
                                        info.stickerAsset!,
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                        errorBuilder: (_, __, ___) =>
                                            const Center(
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFD7DCE6),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.pinch_outlined,
                                        size: 14,
                                        color: Color(0xFF64748B),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Pinch to zoom · Sample scan',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF64748B),
                                          fontFamily: 'Urbanist',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          if (info.stickerCaption != null)
                            Text(
                              info.stickerCaption!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                height: 1.35,
                                color: Color(0xFF0E1446),
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          const SizedBox(height: 10),
                          for (var i = 0; i < info.stickerFields.length; i++)
                            _StickerFieldChip(
                              label: info.stickerFields[i],
                              index: i + 1,
                            ),
                        ],
                        if (info.steps.isNotEmpty) ...[
                          if (info.stickerAsset != null)
                            const SizedBox(height: 8),
                          Text(
                            info.stepsTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0E1446),
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          const SizedBox(height: 12),
                          for (var i = 0; i < info.steps.length; i++)
                            _ProcessStepTile(
                              number: i + 1,
                              text: info.steps[i],
                              isLast: i == info.steps.length - 1,
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF0E2A5C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Got it',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Urbanist',
                          fontSize: 15,
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
    // Info map keys use the unwrapped title (no forced line breaks).
    final info = _cardInfo[item.title.replaceAll('\n', ' ')];
    // One square slot for every card — keeps GIF/illustrations aligned.
    final iconExtent = Responsive.homeCardIconExtent(context);
    final infoSize = Responsive.isTablet(context) ? 28.0 : 24.0;
    final cardPad = Responsive.isTablet(context) ? 10.0 : 8.0;

    return GestureDetector(
      onTap: () => item.onTap(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Responsive.isTablet(context) ? 16 : 14,
          ),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE8ECF4), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0E1446).withValues(alpha: 0.06),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  cardPad,
                  cardPad,
                  cardPad,
                  Responsive.isTablet(context) ? 10 : 8,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: iconExtent,
                          height: iconExtent,
                          child: FeatureCardIcon(
                            icon: item.icon,
                            width: iconExtent,
                            height: iconExtent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.homeCardTitleSize(context),
                        height: 1.05,
                        fontFamily: 'Urbanist',
                        color: const Color(0xFF0E1446),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (info != null)
              Positioned(
                top: 6,
                right: 6,
                child: Tooltip(
                  message: 'How this works',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showInfoDialog(info),
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: infoSize,
                        height: infoSize,
                        child: Center(
                          child: Container(
                            width: infoSize - 6,
                            height: infoSize - 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFD6E4FF),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2957A4)
                                      .withValues(alpha: 0.18),
                                  blurRadius: 10,
                                  spreadRadius: 0.5,
                                  offset: const Offset(0, 3),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'i',
                              style: TextStyle(
                                fontSize: infoSize * 0.42,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Georgia',
                                height: 1,
                                color: const Color(0xFF0E2A5C),
                              ),
                            ),
                          ),
                        ),
                      ),
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
    final roleNames = <String>{
      if (user?.roleProfileName?.trim().isNotEmpty == true)
        user!.roleProfileName!.trim(),
      ...?user?.roles
          ?.map((r) => r.role?.trim())
          .whereType<String>()
          .where((r) => r.isNotEmpty),
    };
    bool hasRole(String name) =>
        roleNames.any((r) => r.toLowerCase() == name.toLowerCase());

    final hasPackingSupervisorRole = hasRole('Packing Supervisor-SH');
    // UAT often grants Frappe role before Role Status checkboxes exist.
    final hasForkliftOperatorRole =
        hasRole('Forklift Operator') || hasRole('Forklift Supervisor');

    final visibleItems =
        dashboardItems
            .where((item) {
              // Forklift: Role Status "Show Forklift Operator in Mobile App"
              // is source of truth. Explicit 0 must always hide — Packing
              // Supervisor / Frappe role / get_forklift_home_summary must NOT
              // override it (that was why keerthi still saw the card at 0).
              if (item.title == 'Forklift Operator') {
                final flag = roleStatus?.showForkliftOperator;
                if (flag == 0) return false;
                if (flag == 1) return true;
                return hasForkliftOperatorRole ||
                    _apiShowForkliftOperator == 1;
              }
              if (item.canShow(roleStatus)) return true;
              if (hasPackingSupervisorRole &&
                  item.section == DashboardSection.scanningPackaging) {
                return true;
              }
              return false;
            })
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
        bottom: false,
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
                        useRootNavigator: true,
                        barrierDismissible: false,
                        builder:
                            (ctx) => const AppUpdateDialog(
                              appName: 'ShaktiHormann',
                              packageName: 'in.easycloud.shakti_hormann',
                            ),
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
          child: ScrollConfiguration(
            // Disable Android stretch-overscroll that elongates home tiles.
            behavior: const ScrollBehavior().copyWith(
              overscroll: false,
              physics: const ClampingScrollPhysics(),
            ),
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: HomeHeaderDelegate(
                    expandedHeight: Responsive.homeHeaderExpanded(context),
                    collapsedHeight: Responsive.homeHeaderCollapsed(context),
                    onNotificationTap: () =>
                        AppRoute.notifications.push(context),
                  ),
                ),
                if (logisticsItems.isNotEmpty)
                  SliverPadding(
                    padding: _homeGridPadding(context, top: 2),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            Responsive.gridCrossAxisCount(context),
                        mainAxisExtent:
                            Responsive.gridTileHeight(context),
                        crossAxisSpacing:
                            Responsive.gridCrossAxisSpacing(context),
                        mainAxisSpacing:
                            Responsive.gridMainAxisSpacing(context),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            buildDashboardCard(logisticsItems[index]),
                        childCount: logisticsItems.length,
                      ),
                    ),
                  ),
                if (scanningItems.isNotEmpty) ...[
                  // Match Dashboard section rhythm: clear gap above + below title.
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: _homeGridPadding(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: logisticsItems.isNotEmpty
                                ? Responsive.homeSectionTitleGap(context)
                                : 12,
                          ),
                          Text(
                            'Scanning & Packaging',
                            style: TextStyle(
                              fontSize:
                                  Responsive.homeSectionTitleSize(context),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              height: 1.1,
                              color: const Color(0xFF0E1446),
                            ),
                          ),
                          SizedBox(
                            height:
                                Responsive.homeSectionTitleBottomGap(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: _homeGridPadding(context),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            Responsive.gridCrossAxisCount(context),
                        mainAxisExtent:
                            Responsive.gridTileHeight(context),
                        crossAxisSpacing:
                            Responsive.gridCrossAxisSpacing(context),
                        mainAxisSpacing:
                            Responsive.gridMainAxisSpacing(context),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            buildDashboardCard(scanningItems[index]),
                        childCount: scanningItems.length,
                      ),
                    ),
                  ),
                ],
                // Clearance for floating transparent bottom nav.
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Responsive.homeBottomClearance(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StickerFieldChip extends StatelessWidget {
  const _StickerFieldChip({
    required this.label,
    this.index,
  });

  final String label;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6E4FF)),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF0E2A5C),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              index != null ? '$index' : '•',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessStepTile extends StatelessWidget {
  const _ProcessStepTile({
    required this.number,
    required this.text,
    required this.isLast,
  });

  final int number;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A3C6B),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: const Color(0xFFE8ECF4)),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16, top: 3),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF334155),
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
