import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/text_styles.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class AppFailureWidget extends StatelessWidget {
  const AppFailureWidget({
    super.key,
    required this.message,
    this.btnText = 'Retry',
    this.onPress,
  });

  final String message;
  final String btnText;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.grey),
        ),
        child: SpacedColumn(
          margin: const EdgeInsets.all(12),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(AppIcons.bubbleTeaSorry.path, height: 64, width: 64),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.titleSmall(
                context,
              ).copyWith(color: AppColors.black),
            ),
            AppButton(label: btnText.toUpperCase(), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
