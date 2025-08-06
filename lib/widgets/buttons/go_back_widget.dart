import 'package:shakti_hormann/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';


class GoBackWidget extends StatelessWidget {
  const GoBackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: context.close,
      child: const CircleAvatar(
        radius: 12,
        backgroundColor: AppColors.chimneySweep,
        child: Icon(Icons.arrow_back, color: AppColors.white, size: 16),
      ),
    );
  }
}
