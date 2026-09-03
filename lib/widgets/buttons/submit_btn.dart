import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/text_styles.dart';
import 'package:shakti_hormann/widgets/form_submit_loading_overlay.dart';

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
  bool _actionStarted = false;
  bool _overlayShownByThis = false;

  @override
  void didUpdateWidget(covariant SubmitBtn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading && !widget.isLoading && _overlayShownByThis) {
      _hideOverlay();
      _actionStarted = false;
    }
  }

  void _showOverlay() {
    if (_overlayShownByThis || !mounted) return;
    FormLoadingOverlay.show(
      context,
      message: formLoadingMessageForLabel(
        widget.label,
        loadingText: widget.loadingText,
      ),
      statusLabel: 'Processing...',
    );
    _overlayShownByThis = true;
  }

  void _hideOverlay() {
    if (!_overlayShownByThis) return;
    FormLoadingOverlay.hide();
    _overlayShownByThis = false;
  }

  void _onPressed() {
    if (widget.onPressed == null || widget.isLoading) return;

    _actionStarted = true;
    _showOverlay();
    widget.onPressed!();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_actionStarted && !widget.isLoading && _overlayShownByThis) {
        _hideOverlay();
        _actionStarted = false;
      }
    });
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
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
