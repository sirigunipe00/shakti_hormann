import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_popup_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// Blocking update gate when ERP reports a newer required app version.
///
/// What it does:
/// 1. On Home, app calls `easy_common.api.get_app_version`
/// 2. Compares server `app_version` to this install's version
/// 3. If the phone is older → shows this dialog (cannot dismiss / back out)
/// 4. "Open Play Store" (or browser APK link) so the operator must update
///    before continuing — keeps mobile client in sync with ERP API changes
class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({
    required this.appName,
    required this.packageName,
    super.key,
  });

  final String appName;
  final String packageName;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AppPopupCard(
        title: 'Update Required',
        icon: Icons.system_update_rounded,
        iconBackground: const Color(0xFFE8F0FE),
        iconColor: AppColors.darkBlue,
        showClose: false,
        body: Text(
          'ERP requires a newer $appName build.\n\n'
          'This update includes API / workflow changes. '
          'Please update now to keep using the app.',
          textAlign: TextAlign.center,
        ),
        singleAction: true,
        confirmText: Platform.isAndroid ? 'Open Play Store' : 'Update',
        confirmIcon: Icons.open_in_new_rounded,
        confirmColor: AppColors.darkBlue,
        onConfirm: () => launchPlayStore(packageName),
      ),
    );
  }

  Future<void> launchPlayStore(String appId) async {
    final market = Uri.parse('market://details?id=$appId');
    final web = Uri.parse(
      'https://play.google.com/store/apps/details?id=$appId&hl=en',
    );

    try {
      if (await canLaunchUrl(market)) {
        await launchUrl(market, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (await canLaunchUrl(web)) {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    }
  }
}
