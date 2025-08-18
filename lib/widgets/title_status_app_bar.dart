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
  loadingConfirmation('Laoding Confirmation');

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
    required this.onSubmit,
    required this.onReject,
    required this.pageMode,
    this.showRejectButton = true,
  });

  final String title;
  final String status;
  final Color textColor;
  final DocNoAlignment alignment;
  final PageMode2 pageMode;

  final VoidCallback onSubmit;
  final VoidCallback onReject;

  final dynamic showRejectButton;

  @override
  Widget build(BuildContext context) {
    final cleanedStatus = status.trim().toLowerCase();

    final String submitLabel =
        pageMode == PageMode2.logisticRequest ? 'Send for\nApproval' : 'Submit';

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
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: IconButton(
                  onPressed: context.close,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: AppColors.liteyellow,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleLarge(
                  context,
                ).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),

            if (status != 'Submitted') ...[
              Row(
                children: [
                  if (pageMode == PageMode2.logisticRequest ||
                      cleanedStatus == 'draft') ...[
                    _buildActionButton(
                      submitLabel,

                      onSubmit,
                      status == 'submitted' ? Colors.grey : Colors.green,
                    ),
                    const SizedBox(width: 8), 
                    if (showRejectButton &&
                        pageMode != PageMode2.logisticRequest &&
                        pageMode != PageMode2.gateentry &&
                        pageMode != PageMode2.gateexit)
                      _buildActionButton('Reject', onReject, Colors.red),
                  ] else ...[
                    _buildActionButton(
                      submitLabel,
                      onReject,
                      status == 'Transporter Rejected'
                          ? Colors.grey
                          : Colors.red,
                    ),
                    if (showRejectButton &&
                        pageMode != PageMode2.logisticRequest)
                      _buildActionButton('Reject', onReject, Colors.red),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(80, 34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.zero,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86);
}
