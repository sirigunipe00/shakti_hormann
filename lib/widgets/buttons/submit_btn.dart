import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/text_styles.dart';

class SubmitBtn extends StatefulWidget {
  const SubmitBtn({
    super.key,
    this.margin,
    required this.label,
    this.bgColor = const Color.fromARGB(255, 184, 40, 100),
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
  State<SubmitBtn> createState() => _SubmitBtnState();
}

class _SubmitBtnState extends State<SubmitBtn> {
  void _onPressed() {
    if (widget.onPressed == null || widget.isLoading) return;
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.bgColor,
          disabledBackgroundColor: AppColors.chimneySweep,
          fixedSize: const Size(100, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color:
                  widget.onPressed == null
                      ? AppColors.chimneySweep
                      : widget.bgColor,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
        ),
        onPressed: widget.isLoading ? null : _onPressed,
        icon: widget.icon,
        label: Text(
          widget.label,
          style: (widget.textStyle ?? TextStyles.btnTextStyle(context))
              .copyWith(
                color: widget.onPressed.isNull ? AppColors.grey : null,
              ),
        ),
      ),
    );
  }
}
