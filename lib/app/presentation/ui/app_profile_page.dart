import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'dart:math' as math;
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';

class AppProfilePage extends StatelessWidget {
  const AppProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFDCB27),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Image.asset(
                    'assets/logo/hormann-logo-new-1 1.png',
                    height: 40,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFDCB27),
                                width: 2,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Color(0xFFFDCB27),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.user.username ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 15,),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.darkBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              context.user.email.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  _infoRow(
                    'Company',
                    const Text(
                      'Shakti Hormann Private Limited',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  _infoRow(
                    'App Version',
                    FutureBuilder<String>(
                      future: _appversion(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
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

                  const SizedBox(height:40),

                  Center(
                    child: AppButton(
                      label: 'Logout',
                      width: 500,
                      icon: Transform.rotate(
                        angle: 180 * math.pi / 180,
                        child: const Icon(
                          Icons.logout_outlined,
                          color: AppColors.white,
                        ),
                      ),
                      onPressed: context.cubit<AuthCubit>().signOut,
                      bgColor: AppColors.darkBlue,
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                    ),
                  ),

                  const SizedBox(height: 65),

                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/logo/EasyCloud Logo 150 x 80.svg',
                        height: 40,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Powered by EasyCloud',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _infoRow(String label, Widget value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
            ),
          ),
          value,
        ],
      ),
    );
  }
}

Future<String> _appversion() async {
  final pinfo = await PackageInfo.fromPlatform();
  final version = pinfo.version;
  final buildNumber = pinfo.buildNumber;
  return '$version ($buildNumber)';
}
