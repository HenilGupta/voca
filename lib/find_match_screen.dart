import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FindMatchScreen extends StatefulWidget {
  const FindMatchScreen({super.key});

  @override
  State<FindMatchScreen> createState() => _FindMatchScreenState();
}

class _FindMatchScreenState extends State<FindMatchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Radar circle button
            GestureDetector(
              onTap: () => context.goNamed('profile'),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated radar rings
                  AnimatedBuilder(
                    animation: _radarController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(260, 260),
                        painter: RadarPainter(
                          animationValue: _radarController.value,
                        ),
                      );
                    },
                  ),

                  // Main circle button
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B2FFF).withOpacity(0.6),
                          blurRadius: 32,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Text below button
            const Text(
              'Finding Your Perfect Match',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Radar Painter
// ---------------------------------------------------------------------------

class RadarPainter extends CustomPainter {
  final double animationValue;

  RadarPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = 80.0;

    // Outer rings
    for (int i = 1; i <= 3; i++) {
      final radius = baseRadius * i / 3;
      final paint = Paint()
        ..color = const Color(0xFF7A3FD4).withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      canvas.drawCircle(center, radius, paint);
    }

    // Animated sweeping radar line
    final sweepPaint = Paint()
      ..color = const Color(0xFF9B4DFF).withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final angle = animationValue * 2 * 3.14159;
    final endPoint = Offset(
      center.dx + (baseRadius * math.cos(angle)),
      center.dy + (baseRadius * math.sin(angle)),
    );

    canvas.drawLine(center, endPoint, sweepPaint);

    // Glow effect around sweep
    final glowPaint = Paint()
      ..color = const Color(0xFF9B4DFF).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawLine(center, endPoint, glowPaint);
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

