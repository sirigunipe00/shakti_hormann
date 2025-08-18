import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/app/presentation/widgets/drop_down_optn.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';

mixin StatusModeSelectionMixin {
  Future<String?> showOptions(
    BuildContext context, {
    String? defaultValue,
    List<String>? options, 
  }) async {
    final filters = options ?? Dropdownoptions.filters;

    return await showModalBottomSheet<String>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: filters
                  .map((filter) => _StatusListTile(
                        mode: filter,
                        value: defaultValue,
                        onTap: () => context.pop(filter),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          // AppButton(
          //   bgColor: Colors.white,
          //   margin: const EdgeInsets.symmetric(horizontal: 12.0),
          //   onPressed: () => context.pop(),
          //   textStyle: const TextStyle(color: AppColors.red, fontWeight: FontWeight.bold),
          //   label: 'CLOSE',
          // ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _StatusListTile extends StatelessWidget {
  const _StatusListTile({
    required this.mode,
    required this.value,
    this.onTap,
  });

  final String mode;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value == mode,
      onChanged: (_) => onTap?.call(),
      checkColor: AppColors.white,
      activeColor: AppColors.green,
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity: const VisualDensity(vertical: -3),
      contentPadding: EdgeInsets.zero,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      title: Text(
        mode,
        style:const  TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
