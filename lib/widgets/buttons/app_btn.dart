import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/text_styles.dart';
import 'package:shakti_hormann/widgets/form_submit_loading_overlay.dart';

class AppButton extends StatefulWidget {
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
    this.onReject,
    this.borderColor,
    this.icon = const SizedBox.shrink(),
    this.useRootLoadingOverlay = false,
  });

  final String label;
  final bool isLoading;
  final Color bgColor;
  final VoidCallback? onReject;
  final Widget icon;
  final EdgeInsets? margin;
  final String? loadingText;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final double? width;
  final Color? borderColor;
  final double? height;

  /// When true, opens the root overlay. Default is false — forms should
  /// use a page-level [FormPageLoadingStack] over the form instead.
  final bool useRootLoadingOverlay;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _actionStarted = false;
  bool _overlayShownByThis = false;

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // API finished → hide overlay immediately (no fixed delay / cycle wait).
    if (oldWidget.isLoading && !widget.isLoading && _overlayShownByThis) {
      _hideOverlay();
      _actionStarted = false;
    }
  }

  void _showOverlay() {
    if (!widget.useRootLoadingOverlay) return;
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
    if (widget.useRootLoadingOverlay) {
      _showOverlay();
    }
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
          fixedSize: Size(widget.width ?? 120, widget.height ?? 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color:
                  widget.borderColor ??
                  (widget.onPressed == null
                      ? AppColors.chimneySweep
                      : widget.bgColor),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(4.0),
        ),
        onPressed:
            (widget.isLoading || widget.onPressed == null) ? null : _onPressed,
        icon: widget.icon,
        label: Text(
          widget.label,
          style: (widget.textStyle ?? TextStyles.btnTextStyle(context)).copyWith(
            color: widget.onPressed.isNull ? AppColors.grey : null,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
