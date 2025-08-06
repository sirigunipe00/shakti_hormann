import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:shakti_hormann/features/auth/presentation/ui/authentication_scrn.dart';
import 'package:shakti_hormann/styles/app_color.dart';


class AppSplashScrn extends StatefulWidget {
  const AppSplashScrn({super.key});

  @override
  State<AppSplashScrn> createState() => _AppSplashScrnState();
}

class _AppSplashScrnState extends State<AppSplashScrn> {
//   @override
//   void initState (){
//     super.initState();
   
//  Timer(const Duration(minutes: 1), () {
//   if (!mounted) return; 
//   context.read<AuthCubit>().authCheckRequested();
// });
//   }
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
                  'assets/logo/doorlady-1 1.png',
                  fit: BoxFit.contain,
                ),
              ),
          
              const SizedBox(height: 12),
          
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Dot(active: true),
                  Dot(active: false),
                  Dot(active: false),
                ],
              ),
          
              const SizedBox(height: 24),
          
              SizedBox(
                width: 220,
                child: Image.asset(
                  'assets/logo/hormann-logo-new-1 1.png',
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
                          builder: (context) => LoginScrnWidget(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
          
              const SizedBox(height: 100),

                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/logo/easycloud 245x132 1.png',
                          width: 78,
                          height: 40,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Powered by EasyCloud",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
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
  final bool active;
  const Dot({super.key, this.active = false});

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
