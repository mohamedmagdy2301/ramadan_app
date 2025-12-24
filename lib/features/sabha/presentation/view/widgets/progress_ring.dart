import 'dart:math';
import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final Color color;
  final double strokeWidth;
  final Widget? child;
  final bool showGlow;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.color,
    this.strokeWidth = 8,
    this.child,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ProgressRingPainter(
        progress: progress,
        color: color,
        strokeWidth: strokeWidth,
        showGlow: showGlow,
      ),
      child: child,
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final bool showGlow;

  ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.showGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final trackPaint = Paint()
      ..color = color.withAlpha(38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (progress > 0) {
      final sweepAngle = 2 * pi * progress;

      // Glow effect
      if (showGlow) {
        final glowPaint = Paint()
          ..color = color.withAlpha(77)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 8
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -pi / 2,
          sweepAngle,
          false,
          glowPaint,
        );
      }

      // Main progress arc with gradient
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        startAngle: -pi / 2,
        endAngle: -pi / 2 + sweepAngle,
        colors: [
          color.withAlpha(153),
          color,
          color,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(-pi / 2),
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );

      // End cap highlight
      final endAngle = -pi / 2 + sweepAngle;
      final endX = center.dx + radius * cos(endAngle);
      final endY = center.dy + radius * sin(endAngle);

      final endCapPaint = Paint()
        ..color = Colors.white.withAlpha(204)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(endX, endY), strokeWidth / 3, endCapPaint);
    }

    // Decorative dots around the ring
    _drawDecorationDots(canvas, center, radius + strokeWidth + 10, 12);
  }

  void _drawDecorationDots(
      Canvas canvas, Offset center, double radius, int count) {
    final dotPaint = Paint()
      ..color = color.withAlpha(51)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final angle = (2 * pi * i / count) - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      // Highlight dots that represent progress
      final dotProgress = i / count;
      if (dotProgress <= progress) {
        dotPaint.color = color.withAlpha(153);
      } else {
        dotPaint.color = color.withAlpha(38);
      }

      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressRingPainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}
