import 'package:flutter/material.dart';
import 'package:shakti_hormann/widgets/door_loading_loop.dart';

/// Full-screen wrapper — place parent branding around [DoorLoadingLoop] as needed.
class DoorLoadingScreen extends StatelessWidget {
  const DoorLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DoorLoadingLoop(expand: true),
    );
  }
}
