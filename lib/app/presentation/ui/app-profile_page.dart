import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';

class AppProfilePage extends StatelessWidget {
  const AppProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.darkBlue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle("User Info"),
            _InfoCard(
              icon: Icons.person_2_rounded,
              label: 'Name',
              value: context.user.name,
            ),
            _InfoCard(
              icon: Icons.business,
              label: 'Organization',
              value: 'Shakti Hormann',
            ),
            FutureBuilder(
              future: _appversion(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final version = snapshot.data!;
                  return _InfoCard(
                    icon: Icons.phone_iphone_outlined,
                    label: 'App Version',
                    value: version,
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: AppButton(
                label: 'Logout',
                icon: Transform.rotate(
                  angle: 180 * math.pi / 180,
                  child: const Icon(Icons.logout_outlined, color: AppColors.white),
                ),
                onPressed: context.cubit<AuthCubit>().signOut,
                bgColor: AppColors.liteyellow,
                margin: const EdgeInsets.symmetric(horizontal: 32),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> _appversion() async {
    final pinfo = await PackageInfo.fromPlatform();
    return '${pinfo.version} (${pinfo.buildNumber})';
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.liteyellow.withOpacity(0.2),
          child: Icon(icon, color: AppColors.liteyellow),
        ),
        title: Text(label,
            style: AppTextStyles.titleMedium(context ,Colors.black).copyWith(fontWeight: FontWeight.w600,fontSize: 15)),
        subtitle: Text(value,
            style: AppTextStyles.titleMedium(context,Colors.black).copyWith(color: AppColors.grey)),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: AppTextStyles.titleLarge(context)
              .copyWith(fontWeight: FontWeight.bold, color: AppColors.black,fontSize: 20)),
    );
  }
}