import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';

enum DocNoAlignment { vertical, horizontal }

class TitleStatusAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleStatusAppBar({
    super.key,
    this.title = '',
    required this.status,
    required this.textColor,
    this.alignment = DocNoAlignment.horizontal,
    required this.onSubmit,
    required this.onReject,
  });

  final String title;
  final String status;
  final Color textColor;
  final DocNoAlignment alignment;

  final VoidCallback onSubmit;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45.0),
      child: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 8, bottom: 8),

          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
                topRight: Radius.circular(20.0)
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
                  child: IconButton(
                    onPressed: context.close,
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColors.liteyellow,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
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
                Row(
                  children: [
                    _buildActionButton(
                      'Submit',
                      onSubmit,
                      status == 'Submitted' ? Colors.grey : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      'Reject',
                      onReject,
                      status == 'Rejected' ? Colors.grey : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(80, 40),
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


