import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/app_spacer.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class SuccessContent extends StatelessWidget {
  const SuccessContent({
    super.key,
    this.title,
    required this.imagePath,
    required this.content,
    this.buttonText = 'Thank you',
    required this.onTapDismiss,
  });

  final String? title;
  final String content;
  final String imagePath;
  final String buttonText;
  final VoidCallback onTapDismiss;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 340),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
          ),
          child: SpacedColumn(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    imagePath, 
                    width: 64,
                    height: 64,
                  ),
                  const Icon(Icons.check, size: 32, color: Colors.white),
                ],
              ),

              const SizedBox(height: 16),
             if (title.containsValidValue)
                Text(
                  title.valueOrEmpty,
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),  // if (title.containsValidValue) ...[
              //   Text(title.valueOrEmpty, style: TextStyles.labelLarge(context)),
              // ],
              // Text(title.valueOrEmpty, style: TextStyles.labelLarge(context)),
              Text(
                content,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSpacer.p32(),
              ElevatedButton(
                onPressed: onTapDismiss,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
