import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleAppBar({
    super.key,
    required this.title,
    this.isLoading = false,
    this.dropdown,
    this.onPressed,
    this.textStyle,
    required this.actionButton,
  });

  final String title;
  final Widget? dropdown;
  final VoidCallback? onPressed;
  final bool isLoading;
  final TextStyle? textStyle;
  final Widget? actionButton;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0, bottom: 0),
      child: Container(
        height: 185,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(20.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.only(left: 2),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.liteyellow,
                    ),
                    onPressed: context.close,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                if (actionButton != null) ...[
                  const SizedBox(height: 12),
                  actionButton!,
                ],
              ],
            ),
            if (dropdown != null) ...[const SizedBox(height: 12), dropdown!],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(250);
}
