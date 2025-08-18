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
    this.height,
    this.width,
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
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,

          disabledBackgroundColor: AppColors.chimneySweep,
          fixedSize: Size(width ?? 120, height ?? 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: onPressed == null ? AppColors.chimneySweep : bgColor,
            ),
          ),
          padding: const EdgeInsets.all(4.0),
        ),
        onPressed: isLoading ? null : onPressed,
        icon: icon,
        label:
            (isLoading && loadingText.doesNotHaveValue)
                ? const LoadingIndicator(color: AppColors.white)
                : Text(
                  isLoading ? loadingText.valueOrEmpty : label,
                  style: (textStyle ?? TextStyles.btnTextStyle(context))
                      .copyWith(
                        color: onPressed.isNull ? AppColors.grey : null,
                      ),
                ),
      ),
    );
  }
}
