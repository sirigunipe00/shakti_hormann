import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';

enum DocNoAlignment { vertical, horizontal }

enum PageMode2 {
  gateentry('Gate Entry'),
  gateexit('Gate Exit'),
  logisticRequest('Logistic Request'),
  transportConfirmation('Transport Confirmation'),
  vehicleReporting('Vehicle Reporting Entry'),
  loadingConfirmation('Dispatch Loading'),
  proofOfDelivery('Proof of Delivery'),
  gateManagement('Gate Management'),
  storagePacking('Storage Allocation'),
  hardwarePacking('HardWare Packing'),
  zoneTransfer('Zone Transfer'),
  shutterPacking('Shutter Packing'),
  framePacking('Frame Packing'),
  palletCreation('Pallet Creation'),
  visionPanel('Vision Panel'),
  installation('Installation Entry');

  const PageMode2(this.name);

  final String name;
}

class TitleStatusAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleStatusAppBar({
    super.key,
    this.title = '',
    required this.status,
    required this.textColor,
    this.alignment = DocNoAlignment.horizontal,
    required this.pageMode,
    this.showRejectButton = true,
    this.actionButton,
    this.isSubmitting = false,
    this.isRejecting = false,
    required this.onSubmit,
    required this.onReject,
    this.dropdown,
    this.showScanner = false,
    this.onScan,
  });

  final String title;
  final String status;
  final Color textColor;
  final DocNoAlignment alignment;
  final PageMode2 pageMode;
  final dynamic showRejectButton;
  final Widget? actionButton;
  final Widget? dropdown;
  final bool showScanner;
  final VoidCallback? onScan;

  final bool isSubmitting;
  final bool isRejecting;

  final VoidCallback onSubmit;
  final VoidCallback onReject;

  /// Content height below the status bar.
  /// Scaffold already adds `MediaQuery.padding.top` for primary app bars,
  /// so do not bake status-bar padding into [preferredSize].
  static const double _contentHeight = 84;
  static const double _vehicleActionsExtraHeight = 62;
  static const double _dropdownExtraHeight = 96;

  bool get _isVehicleReporting => pageMode == PageMode2.vehicleReporting;

  bool get _showsInlineActions =>
      actionButton == null &&
      status != 'Submitted' &&
      status != 'Reported' &&
      status != 'Rejected';

  /// VRE Accept/Reject sit on a second row so they stay large (no FittedBox shrink).
  bool get _usesVehicleActionRow =>
      _isVehicleReporting && _showsInlineActions;

  @override
  Size get preferredSize {
    var height = _contentHeight;
    if (_usesVehicleActionRow) height += _vehicleActionsExtraHeight;
    if (dropdown != null) height += _dropdownExtraHeight;
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    final cleanedStatus = status.trim().toLowerCase();

    final String submitLabel = pageMode == PageMode2.logisticRequest
        ? 'Send for Approval'
        : pageMode == PageMode2.transportConfirmation
            ? 'Accept'
            : pageMode == PageMode2.vehicleReporting
                ? 'Accept Vehicle'
                : 'Submit';

    // Scaffold allocates preferredSize.height + status-bar inset for primary
    // app bars. Pad with the status inset here (do not also inflate preferredSize).
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildBackButton(context),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleLarge(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (actionButton != null) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: actionButton!,
                      ),
                    ),
                  ),
                ] else if (_showsInlineActions && !_usesVehicleActionRow) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: _buildDefaultButtons(
                          cleanedStatus,
                          submitLabel,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (_usesVehicleActionRow) ...[
              const SizedBox(height: 10),
              _buildDefaultButtons(cleanedStatus, submitLabel),
            ],
            if (dropdown != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: dropdown!),
                  if (showScanner) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onScan,
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultButtons(String cleanedStatus, String submitLabel) {
    String? buttonLabel;
    IconData? submitIcon;

    if (pageMode == PageMode2.logisticRequest && cleanedStatus != 'draft') {
      buttonLabel = 'Send for Approval';
      submitIcon = Icons.send_rounded;
    } else if (pageMode == PageMode2.transportConfirmation) {
      buttonLabel = 'Approve';
      submitIcon = Icons.check_circle_outline;
    } else if (pageMode == PageMode2.vehicleReporting) {
      buttonLabel = 'Accept Vehicle';
      // Text-only for VRE — larger tap targets without icons.
      submitIcon = null;
    }

    final isVehicle = pageMode == PageMode2.vehicleReporting;

    final accept = buttonLabel == null
        ? null
        : _buildActionButton(
            buttonLabel,
            onSubmit,
            status == 'submitted' ? Colors.grey : const Color(0xFF16A34A),
            isLoading: isSubmitting,
            icon: submitIcon,
            prominent: isVehicle,
            expand: isVehicle,
          );

    final reject = (showRejectButton &&
            pageMode != PageMode2.logisticRequest &&
            pageMode != PageMode2.gateentry &&
            pageMode != PageMode2.gateManagement &&
            pageMode != PageMode2.gateexit)
        ? _buildActionButton(
            pageMode == PageMode2.vehicleReporting
                ? 'Reject Vehicle'
                : 'Reject',
            onReject,
            const Color(0xFFDC2626),
            isLoading: isRejecting,
            // No icon on VRE reject — keep Transport Confirm / others as-is.
            icon: isVehicle ? null : Icons.cancel_outlined,
            prominent: isVehicle,
            expand: isVehicle,
          )
        : null;

    if (isVehicle) {
      return Row(
        children: [
          if (accept != null) Expanded(child: accept),
          if (accept != null && reject != null) const SizedBox(width: 12),
          if (reject != null) Expanded(child: reject),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (accept != null) ...[
          accept,
          const SizedBox(width: 8),
        ],
        if (reject != null) reject,
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    VoidCallback onPressed,
    Color color, {
    bool isLoading = false,
    IconData? icon,
    bool prominent = false,
    bool expand = false,
  }) {
    final label = Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: prominent ? 15.5 : 12,
        fontWeight: FontWeight.w800,
        fontFamily: 'Urbanist',
        height: 1.1,
      ),
    );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: color.withValues(alpha: 0.55),
        elevation: prominent ? 3 : 0,
        shadowColor: color.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(prominent ? 14 : 8),
        ),
        minimumSize: Size(
          prominent ? 140 : 0,
          prominent ? 52 : 36,
        ),
        tapTargetSize: prominent
            ? MaterialTapTargetSize.padded
            : MaterialTapTargetSize.shrinkWrap,
        visualDensity:
            prominent ? VisualDensity.standard : VisualDensity.compact,
        padding: EdgeInsets.symmetric(
          horizontal: prominent ? 16 : 10,
          vertical: prominent ? 14 : 8,
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: prominent ? 22 : 18,
              height: prominent ? 22 : 18,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : icon == null
              ? label
              : Row(
                  mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: prominent ? 20 : 14,
                      color: Colors.white,
                    ),
                    SizedBox(width: prominent ? 8 : 6),
                    Flexible(child: label),
                  ],
                ),
    );

    return expand ? SizedBox(height: 52, child: button) : button;
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: IconButton(
        onPressed: context.close,
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: AppColors.liteyellow,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
