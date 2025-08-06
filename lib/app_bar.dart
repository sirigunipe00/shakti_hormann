import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback? onBack;

  const CustomAppBar({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( top: 20, right: 16, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onBack ?? () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.liteyellow),
            ),
          ),
          const SizedBox(width: 60),
          Image.asset(
            'assets/logo/hormann-logo-new-1 1.png',
            width: 180,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
