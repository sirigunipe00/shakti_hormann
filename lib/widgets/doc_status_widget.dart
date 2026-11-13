import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';

class DocStatusWidget extends StatelessWidget {
  const DocStatusWidget({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 56, minHeight: 22),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: toColor(),
        border: Border.all(color: toColor()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: AppTextStyles.labelLarge(context).copyWith(
          color: toTextColor(),
          fontSize: 11,
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w700,
          height: 1.15,
        ),
      ),
    );
  }

  String get _normalized => status.trim().toLowerCase();

  Color toColor() => switch (_normalized) {
    'submitted' || 'completed' || 'reported' || 'transporter confirmed' =>
      const Color(0xFFEAFFF6),
    'draft' => const Color(0xFFE3F2FE),
    'rejected' || 'cancelled' || 'transporter rejected' =>
      const Color(0xFFC16D67),
    'pending from transporter' => const Color(0xFFFFF4E5),
    String() => const Color.fromARGB(255, 254, 254, 254),
  };

  Color toTextColor() => switch (_normalized) {
    'submitted' || 'completed' || 'transporter confirmed' =>
      const Color(0xFF35C285),
    'draft' || 'reported' => const Color(0xFF0087FF),
    'rejected' || 'cancelled' || 'transporter rejected' =>
      const Color(0xFFFFE2DA),
    'pending from transporter' => const Color(0xFFE67E22),
    String() => AppColors.black,
  };
}
