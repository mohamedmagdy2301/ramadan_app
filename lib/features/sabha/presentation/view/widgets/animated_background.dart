import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Color primaryColor;
  final Widget child;
  final bool isDark;

  const AnimatedBackground({
    super.key,
    required this.primaryColor,
    required this.child,
    required this.isDark,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particles = List.generate(20, (_) => _createParticle());
  }

  Particle _createParticle() {
    return Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 4 + 2,
      speed: _random.nextDouble() * 0.5 + 0.2,
      opacity: _random.nextDouble() * 0.5 + 0.1,
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDark
        ? const Color(0xFF0D1117)
        : const Color(0xFFF8F9FA);

    final gradientColors = widget.isDark
        ? [
            backgroundColor,
            widget.primaryColor.withAlpha(26),
            backgroundColor,
          ]
        : [
            backgroundColor,
            widget.primaryColor.withAlpha(13),
            backgroundColor,
          ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlePainter(
              particles: _particles,
              animation: _particleController.value,
              color: widget.primaryColor,
              isDark: widget.isDark,
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final Color color;
  final bool isDark;

  ParticlePainter({
    required this.particles,
    required this.animation,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      // Calculate animated position
      final animatedY = (particle.y + animation * particle.speed) % 1.0;
      final x = particle.x * size.width;
      final y = animatedY * size.height;

      // Fade in/out based on position
      final fadeOpacity = sin(animatedY * pi) * particle.opacity;

      paint.color = color.withAlpha((fadeOpacity.clamp(0.0, 1.0) * 255).round());

      // Draw glow
      final glowPaint = Paint()
        ..color = color.withAlpha(((fadeOpacity * 0.3).clamp(0.0, 1.0) * 255).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(Offset(x, y), particle.size * 2, glowPaint);
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
