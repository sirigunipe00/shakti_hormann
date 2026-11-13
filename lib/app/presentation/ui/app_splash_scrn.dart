import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/app/presentation/widgets/greeting_widget.dart';
import 'package:shakti_hormann/core/app_router/app_route.dart';
import 'package:shakti_hormann/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:shakti_hormann/features/auth/presentation/ui/authentication_scrn.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/door_loading_loop.dart';
import 'package:shakti_hormann/widgets/hormann_loading_controller.dart';

/// Cold-start gate: rectangular Home logo + the same door loader used by
/// Where Is My Material, then either Home or the welcome/login landing.
class AppSplashScrn extends StatefulWidget {
  const AppSplashScrn({super.key});

  @override
  State<AppSplashScrn> createState() => _AppSplashScrnState();
}

class _AppSplashScrnState extends State<AppSplashScrn> {
  final HormannLoadingController _progress = HormannLoadingController();

  var _showWelcome = false;
  var _finishing = false;
  var _navigatedHome = false;
  DateTime? _startedAt;

  static const _minLoaderVisible = Duration(milliseconds: 1400);

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _progress
      ..setStage(0.14, label: 'Fitting the frame')
      ..startIdleCreep(ceiling: 0.88);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _onAuth(context.read<AuthCubit>().state);
    });
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  Future<void> _onAuth(AuthState state) async {
    await state.maybeWhen(
      authenticated: () => _finishLoading(goHome: true),
      unAuthenticated: () => _finishLoading(goHome: false),
      orElse: () async {},
    );
  }

  Future<void> _finishLoading({required bool goHome}) async {
    if (_finishing || _showWelcome || _navigatedHome) return;
    _finishing = true;

    final started = _startedAt ?? DateTime.now();
    final elapsed = DateTime.now().difference(started);
    final remaining = _minLoaderVisible - elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    if (!mounted) return;

    _progress.setStage(0.94, label: 'Almost ready');
    await _progress.complete();
    if (!mounted) return;

    if (goHome) {
      _navigatedHome = true;
      context.go(AppRoute.home.path);
      return;
    }

    setState(() => _showWelcome = true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, next) => prev != next,
      listener: (context, state) => _onAuth(state),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: _showWelcome
            ? const _WelcomeLanding(key: ValueKey('welcome'))
            : _BootLoader(
                key: const ValueKey('boot'),
                progress: _progress,
              ),
      ),
    );
  }
}

class _BootLoader extends StatelessWidget {
  const _BootLoader({super.key, required this.progress});

  final HormannLoadingController progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 28),
            const HormannLogoMark(height: 36),
            Expanded(
              child: DoorLoadingLoop(
                expand: true,
                width: 220,
                progressController: progress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pre-login marketing landing (door hero + rectangular brand + Login CTA).
class _WelcomeLanding extends StatelessWidget {
  const _WelcomeLanding({super.key});

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
                    colors: [
                      Color(0xFFd2baaa),
                      Color.fromARGB(255, 167, 161, 151),
                    ],
                  ),
                ),
                child: Image.asset(
                  'assets/logo/doorlady.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 36),
              const HormannLogoMark(height: 48),
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
