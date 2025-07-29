import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_icons.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';


class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({
    super.key,
    required this.emptyText,
    this.title = 'Refresh',
    this.onRefresh,
  });

  final String emptyText;
  final String title;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SpacedColumn(
          mainAxisSize: MainAxisSize.min,
          margin: const EdgeInsets.all(12.0),
          defaultHeight: 18.0,
          children: [
            SvgPicture.asset(AppIcons.bubbles.path, height: 120, width: 120),
            Text(emptyText.trim(), style: context.textTheme.titleMedium, textAlign: TextAlign.center),
            if(onRefresh.isNotNull)...[
              AppButton(
                label: title,
                onPressed: onRefresh,
                textStyle: context.textTheme.titleLarge,
                bgColor: AppColors.bleachedSilk,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
