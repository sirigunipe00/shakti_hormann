import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';

class AppProfilePage extends StatelessWidget {
  const AppProfilePage({super.key});

  void _goHome(BuildContext context) {
    final shell = StatefulNavigationShell.maybeOf(context);
    if (shell != null) {
      shell.goBranch(0);
      return;
    }
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoute.home.path);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.user;
    final name = (user.firstName ?? '').trim().isEmpty
        ? 'User'
        : user.firstName!.trim();
    final email = user.email?.toString() ?? '';
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final shortest = media.size.shortestSide;

    // Scale logo + overlap for phones / large phones / tablets.
    final logoHeight = (shortest * 0.055).clamp(28.0, 40.0);
    final cardOverlap = (shortest * 0.09).clamp(48.0, 72.0);
    // Space under logo must exceed overlap so the card never covers it.
    final logoBottomGap = cardOverlap + 12;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: media.padding.bottom + 100,
        ),
        child: Column(
          children: [
            // Header grows with content — logo always reserved above overlap.
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF2A93E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    width * 0.04,
                    8,
                    width * 0.04,
                    0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            elevation: 1,
                            shadowColor: Colors.black26,
                            child: InkWell(
                              onTap: () => _goHome(context),
                              borderRadius: BorderRadius.circular(12),
                              child: const SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 18,
                                  color: Color(0xFF0E1446),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0E1446),
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: (height * 0.012).clamp(8.0, 16.0)),
                      // Explicit logo band — always visible on every Android size.
                      SizedBox(
                        height: logoHeight,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/hormann_brand_logo.svg',
                            height: logoHeight,
                            fit: BoxFit.contain,
                            placeholderBuilder: (_) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      SizedBox(height: logoBottomGap),
                    ],
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -cardOverlap),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.075),
                child: _ProfileCard(
                  name: name,
                  email: email,
                  width: width,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -cardOverlap + 12),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Column(
                  children: [
                    const _InfoCard(
                      icon: Icons.apartment_rounded,
                      label: 'Company',
                      value: 'Shakti Hormann Private Limited',
                    ),
                    const SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.layers_outlined,
                      label: 'App Version',
                      valueWidget: FutureBuilder<String>(
                        future: _appVersion(),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0E1446),
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          }
                          return const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: (height * 0.028).clamp(16.0, 28.0)),
                    AppButton(
                      label: 'Logout',
                      width: width * 0.88,
                      icon: Transform.rotate(
                        angle: math.pi,
                        child: const Icon(
                          Icons.logout_rounded,
                          color: AppColors.white,
                        ),
                      ),
                      onPressed: context.cubit<AuthCubit>().signOut,
                      bgColor: AppColors.darkBlue,
                      margin: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.email,
    required this.width,
  });

  final String name;
  final String email;
  final double width;

  @override
  Widget build(BuildContext context) {
    final avatarRadius = (width * 0.072).clamp(26.0, 34.0);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0E1446).withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF2A93E),
                        width: 3,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.darkBlue,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: const Color(0xFFE8EEF8),
                        child: Icon(
                          Icons.person_rounded,
                          size: avatarRadius * 1.25,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: (width * 0.055).clamp(18.0, 24.0),
                      color: const Color(0xFF0E1446),
                      fontFamily: 'Urbanist',
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (email.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFD6E4FF)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.mail_outline_rounded,
                            size: 16,
                            color: Color(0xFF2957A4),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF1E3A8A),
                                fontSize: (width * 0.032).clamp(12.0, 14.0),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Urbanist',
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              height: 8,
              width: double.infinity,
              color: AppColors.darkBlue,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1446).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2957A4), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                valueWidget ??
                    Text(
                      value ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0E1446),
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> _appVersion() async {
  final pinfo = await PackageInfo.fromPlatform();
  return '${pinfo.version} (${pinfo.buildNumber})';
}
