import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CelebrationOverlay extends StatefulWidget {
  final bool isVisible;
  final Color primaryColor;
  final VoidCallback onDismiss;
  final int targetReached;

  const CelebrationOverlay({
    super.key,
    required this.isVisible,
    required this.primaryColor,
    required this.onDismiss,
    required this.targetReached,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late List<ConfettiParticle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _particles = List.generate(50, (_) => _createParticle());
  }

  ConfettiParticle _createParticle() {
    return ConfettiParticle(
      x: _random.nextDouble(),
      y: -0.1,
      size: _random.nextDouble() * 10 + 5,
      speedX: (_random.nextDouble() - 0.5) * 0.5,
      speedY: _random.nextDouble() * 0.5 + 0.3,
      rotation: _random.nextDouble() * 2 * pi,
      rotationSpeed: (_random.nextDouble() - 0.5) * 0.2,
      color: _getRandomColor(),
    );
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFF4CAF50), // Green
      const Color(0xFF2196F3), // Blue
      const Color(0xFFFF9800), // Orange
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFE91E63), // Pink
      widget.primaryColor,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void didUpdateWidget(CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _particles = List.generate(50, (_) => _createParticle());
      _confettiController.forward(from: 0);
      _scaleController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        color: Colors.black54,
        child: Stack(
          children: [
            // Confetti animation
            AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(
                    particles: _particles,
                    animation: _confettiController.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),

            // Celebration card
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40.w),
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor.withAlpha(77),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Trophy icon
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFFD700),
                              const Color(0xFFFFA500),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withAlpha(128),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 45.sp,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Congratulations text
                      Text(
                        'ما شاء الله!',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: widget.primaryColor,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        'لقد أكملت ${widget.targetReached} تسبيحة',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Tajawal',
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        'تقبل الله منك',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Amiri',
                          color: widget.primaryColor,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Continue button
                      ElevatedButton(
                        onPressed: widget.onDismiss,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'استمر في التسبيح',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfettiParticle {
  double x;
  double y;
  final double size;
  final double speedX;
  final double speedY;
  double rotation;
  final double rotationSpeed;
  final Color color;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double animation;

  ConfettiPainter({
    required this.particles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final x = (particle.x + particle.speedX * animation) * size.width;
      final y = (particle.y + particle.speedY * animation) * size.height;
      final rotation = particle.rotation + particle.rotationSpeed * animation * 10;

      if (y > size.height) continue;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final paint = Paint()
        ..color = particle.color.withAlpha(((1 - animation * 0.5) * 255).round())
        ..style = PaintingStyle.fill;

      // Draw confetti shape (rectangle)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.size,
            height: particle.size * 0.6,
          ),
          Radius.circular(2),
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
