import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/core/app_router/app_route.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/auth/presentation/ui/authentication_scrn.dart';
import 'package:shakti_hormann/styles/app_color.dart';


class AppSplashScrn extends StatefulWidget {
  const AppSplashScrn({super.key});

  @override
  State<AppSplashScrn> createState() => _AppSplashScrnState();
}

class _AppSplashScrnState extends State<AppSplashScrn> {

    @override
  void initState() {
    super.initState();

    Timer(const Duration(), () {
      if(!mounted) return;
      final loggedInUser = $sl.isRegistered<LoggedInUser>()
          ? $sl<LoggedInUser>()
          : null;

      if (loggedInUser != null) {
        context.go(AppRoute.home.path);
      } else {

        context.go(AppRoute.login.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFd2baaa), Color.fromARGB(255, 167, 161, 151)],
                  ),
                ),
                child: Image.asset(
                  // 'assets/logo/doorlady-1 1 (1).png',
                  'assets/logo/doorlady.png',
                  fit: BoxFit.contain,
                ),
              ),
          
              const SizedBox(height: 12),
          

          
              const SizedBox(height: 24),
          
              SizedBox(
                width: 320,
                child: SvgPicture.asset(
                  'assets/images/hormann_logo.svg',
                  fit: BoxFit.contain,
                ),
              ),
          
              const SizedBox(height: 32),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF163A6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScrnWidget(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
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

class Dot extends StatelessWidget {
  const Dot({super.key, this.active = false});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 20 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? Colors.grey[700] : Colors.grey[400],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
