import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/utils/functions/convert_num_to_ar.dart';
import 'package:ramadan_app/features/sabha/data/models/dhikr_model.dart';
import 'package:ramadan_app/features/sabha/presentation/view/widgets/progress_ring.dart';

class DhikrCounterCircle extends StatefulWidget {
  final int counter;
  final double progress;
  final Color color;
  final SabhaTarget target;
  final bool isAnimating;
  final VoidCallback onTap;
  final String dhikrText;

  const DhikrCounterCircle({
    super.key,
    required this.counter,
    required this.progress,
    required this.color,
    required this.target,
    required this.isAnimating,
    required this.onTap,
    required this.dhikrText,
  });

  @override
  State<DhikrCounterCircle> createState() => _DhikrCounterCircleState();
}

class _DhikrCounterCircleState extends State<DhikrCounterCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive size based on available space
        final maxSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final size = (maxSize * 0.85).clamp(200.0, 300.0);

        return GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isAnimating ? 0.95 : _pulseAnimation.value,
                child: child,
              );
            },
            child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withAlpha(77),
                          blurRadius: 25,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  ),

                  // Progress ring
                  SizedBox(
                    width: size - 16,
                    height: size - 16,
                    child: ProgressRing(
                      progress: widget.progress,
                      color: widget.color,
                      strokeWidth: size * 0.04,
                    ),
                  ),

                  // Inner circle with gradient
                  Container(
                    width: size - 50,
                    height: size - 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.color.withAlpha(51),
                          widget.color.withAlpha(13),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                      border: Border.all(
                        color: widget.color.withAlpha(77),
                        width: 2,
                      ),
                    ),
                  ),

                  // Counter content
                  Padding(
                    padding: EdgeInsets.all(size * 0.15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Counter number
                        Flexible(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.counter == 0
                                    ? '٠'
                                    : convertNumberToArabic(
                                        widget.counter.toString()),
                                key: ValueKey(widget.counter),
                                style: TextStyle(
                                  fontSize: _getCounterFontSize(size),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Amiri',
                                  color: context.isDark
                                      ? Colors.white
                                      : widget.color,
                                  shadows: [
                                    Shadow(
                                      color: widget.color.withAlpha(128),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        if (widget.target != SabhaTarget.infinite) ...[
                          SizedBox(height: 4.h),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: widget.color.withAlpha(38),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Text(
                                '${widget.target.arabicLabel} / ${convertNumberToArabic(widget.counter.toString())}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: widget.color,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Ripple effect on tap
                  if (widget.isAnimating)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: size - 35,
                      height: size - 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.color.withAlpha(128),
                          width: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _getCounterFontSize(double size) {
    final length = widget.counter.toString().length;
    final baseSize = size * 0.25;
    if (length <= 1) return baseSize;
    if (length <= 2) return baseSize * 0.85;
    if (length <= 3) return baseSize * 0.7;
    if (length <= 4) return baseSize * 0.55;
    return baseSize * 0.45;
  }
}
