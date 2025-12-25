import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

class CompassWidget extends StatelessWidget {
  final double heading; // Device heading in degrees
  final double qiblaDirection; // Qibla direction in degrees

  const CompassWidget({
    super.key,
    required this.heading,
    required this.qiblaDirection,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the angle to rotate the compass
    // Negative heading to make North stay at top when device rotates
    final compassRotation = -heading * (pi / 180);

    // Calculate the qibla needle rotation relative to compass
    final qiblaNeedleRotation = (qiblaDirection - heading) * (pi / 180);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Compass Rose (rotates with device)
        Transform.rotate(
          angle: compassRotation,
          child: CustomPaint(
            size: Size(280.w, 280.w),
            painter: CompassPainter(
              primaryColor: context.primaryColor,
              textColor: context.onPrimaryColor,
            ),
          ),
        ),
        // Qibla Needle (points to Qibla)
        Transform.rotate(
          angle: qiblaNeedleRotation,
          child: _buildQiblaNeedle(context),
        ),
        // Center point
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: context.primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQiblaNeedle(BuildContext context) {
    return SizedBox(
      width: 280.w,
      height: 280.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Qibla direction indicator
          Positioned(
            top: 15.h,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: context.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.primaryColor.withAlpha(100),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mosque,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                Container(
                  width: 3.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.primaryColor,
                        context.primaryColor.withAlpha(50),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;

  CompassPainter({
    required this.primaryColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw outer circle
    final outerPaint = Paint()
      ..color = primaryColor.withAlpha(30)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, outerPaint);

    // Draw compass border
    final borderPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius - 2, borderPaint);

    // Draw inner circle
    final innerPaint = Paint()
      ..color = primaryColor.withAlpha(10)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.7, innerPaint);

    // Draw degree marks
    _drawDegreeMarks(canvas, center, radius, primaryColor);

    // Draw cardinal directions
    _drawCardinalDirections(canvas, center, radius);
  }

  void _drawDegreeMarks(
      Canvas canvas, Offset center, double radius, Color color) {
    final markPaint = Paint()
      ..color = color.withAlpha(150)
      ..strokeWidth = 1;

    final majorMarkPaint = Paint()
      ..color = color
      ..strokeWidth = 2;

    for (int i = 0; i < 360; i += 5) {
      final isMajor = i % 30 == 0;
      final paint = isMajor ? majorMarkPaint : markPaint;
      final markLength = isMajor ? 15.0 : 8.0;

      final radians = i * (pi / 180);
      final outerPoint = Offset(
        center.dx + (radius - 5) * sin(radians),
        center.dy - (radius - 5) * cos(radians),
      );
      final innerPoint = Offset(
        center.dx + (radius - 5 - markLength) * sin(radians),
        center.dy - (radius - 5 - markLength) * cos(radians),
      );

      canvas.drawLine(outerPoint, innerPoint, paint);
    }
  }

  void _drawCardinalDirections(Canvas canvas, Offset center, double radius) {
    final directions = ['N', 'E', 'S', 'W'];
    final arabicDirections = ['ش', 'شر', 'ج', 'غ'];
    final angles = [0, 90, 180, 270];

    for (int i = 0; i < 4; i++) {
      final radians = angles[i] * (pi / 180);
      final distance = radius - 45;
      final position = Offset(
        center.dx + distance * sin(radians),
        center.dy - distance * cos(radians),
      );

      // Draw direction letter
      final textPainter = TextPainter(
        text: TextSpan(
          text: directions[i],
          style: TextStyle(
            color: i == 0 ? Colors.red : textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          position.dx - textPainter.width / 2,
          position.dy - textPainter.height / 2,
        ),
      );

      // Draw Arabic direction below
      final arabicPainter = TextPainter(
        text: TextSpan(
          text: arabicDirections[i],
          style: TextStyle(
            color: textColor.withAlpha(180),
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.rtl,
      );
      arabicPainter.layout();
      arabicPainter.paint(
        canvas,
        Offset(
          position.dx - arabicPainter.width / 2,
          position.dy + textPainter.height / 2 + 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CompassPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.textColor != textColor;
  }
}
