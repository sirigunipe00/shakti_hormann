import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  loadingConfirmation('Dispatch Loading');

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
  });

  final String title;
  final String status;
  final Color textColor;
  final DocNoAlignment alignment;
  final PageMode2 pageMode;
  final dynamic showRejectButton;
  final Widget? actionButton;

  final bool isSubmitting;
  final bool isRejecting;

  final VoidCallback onSubmit;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final cleanedStatus = status.trim().toLowerCase();

    final String submitLabel =
        pageMode == PageMode2.logisticRequest
            ? 'Send for\nApproval'
            : pageMode == PageMode2.transportConfirmation
                ? 'Accept'
                : 'Submit';

    return Padding(
      padding: const EdgeInsets.only(top: 45.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: const BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            topRight: Radius.circular(20.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _buildBackButton(context),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleLarge(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (actionButton != null) ...[
              const SizedBox(width: 8),
              actionButton!,
            ] else if (status != 'Submitted' &&
                status != 'Reported' &&
                status != 'Rejected') ...[
              _buildDefaultButtons(cleanedStatus, submitLabel),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultButtons(String cleanedStatus, String submitLabel) {
    String? buttonLabel;

    if (pageMode == PageMode2.logisticRequest && cleanedStatus != 'draft') {
      buttonLabel = 'Send for\nApproval';
    } else if (pageMode == PageMode2.transportConfirmation) {
      buttonLabel = 'Approve';
    } else if (pageMode == PageMode2.vehicleReporting) {
      buttonLabel = 'Accept\nVehicle';
    }

    return Row(
      children: [
        if (buttonLabel != null) ...[
          _buildActionButton(
            buttonLabel,
            onSubmit,
            status == 'submitted' ? Colors.grey : Colors.green,
            isLoading: isSubmitting, // ✅ only submit button shows
          ),
          const SizedBox(width: 8),
        ],
        if (showRejectButton &&
            pageMode != PageMode2.logisticRequest &&
            pageMode != PageMode2.gateentry &&
            pageMode != PageMode2.gateexit)
          _buildActionButton(
            pageMode == PageMode2.vehicleReporting ? 'Reject\nVehicle' : 'Reject',
            onReject,
            Colors.red,
            isLoading: isRejecting, // ✅ only reject button shows
          ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    VoidCallback onPressed,
    Color color, {
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.grey),
        ),
        minimumSize: const Size(100, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
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

  @override
  Size get preferredSize => const Size.fromHeight(86);
}




class SubmitCubit extends Cubit<bool> {
  SubmitCubit() : super(false); // false = not loading

  Future<void> submitRequest() async {
    emit(true); // show loading
    await Future.delayed(const Duration(seconds: 2)); // simulate API
    emit(false); // hide loading
  }

  Future<void> rejectRequest() async {
    emit(true);
    await Future.delayed(const Duration(seconds: 2));
    emit(false);
  }
}