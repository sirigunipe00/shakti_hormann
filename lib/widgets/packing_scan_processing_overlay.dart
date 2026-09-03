import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shakti_hormann/widgets/door_loading_loop.dart';

class PackingScanProcessingOverlay extends StatelessWidget {
  const PackingScanProcessingOverlay({
    super.key,
    this.message = 'Reading sticker data...',
  });

  final String message;

  static const _animationWidth = 168.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AbsorbPointer(
        child: Material(
          color: Colors.black.withValues(alpha: 0.45),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1B2350),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Please wait...',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF8A8D9A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: DoorLoadingLoop(
                          width: _animationWidth,
                          fixedStatusLabel: 'Processing...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
