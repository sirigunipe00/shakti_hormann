import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';

import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/text_styles.dart';
import 'package:shakti_hormann/widgets/loading_indicator.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.margin,
    required this.label,
    this.bgColor = AppColors.green,
    this.isLoading = false,
    this.onPressed,
    this.textStyle,
    this.loadingText,
    this.icon = const SizedBox.shrink(),
  });

  final String label;
  final bool isLoading;
  final Color bgColor;
  final Widget icon;
  final EdgeInsets? margin;
  final String? loadingText;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: AppColors.chimneySweep,
          fixedSize: Size.fromWidth(context.sizeOfWidth),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: bgColor),
          ),
          padding: const EdgeInsets.all(10.0),
        ),
        onPressed: isLoading ? null : onPressed,
        icon: icon,
        label: (isLoading && loadingText.doesNotHaveValue)
            ? const LoadingIndicator(color: AppColors.white)
            : Text(
                isLoading ? loadingText.valueOrEmpty : label,
                style: (textStyle ?? TextStyles.btnTextStyle(context)).copyWith(
                  color: onPressed.isNull ? AppColors.white : null,
                ),
              ),
      ),
    );
  }
}
