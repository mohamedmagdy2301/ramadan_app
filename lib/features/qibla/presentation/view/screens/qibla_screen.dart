import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/qibla/data/qibla_calculator.dart';
import 'package:ramadan_app/features/qibla/presentation/widgets/compass_widget.dart';
import 'package:ramadan_app/features/qibla/services/location_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  static const routeName = '/qibla';

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final QiblaLocationService _locationService = QiblaLocationService();

  StreamSubscription<CompassEvent>? _compassSubscription;
  double _heading = 0;
  double _qiblaDirection = 0;
  double _distanceToKaaba = 0;
  bool _isLoading = true;
  bool _hasCompass = false;
  String? _errorMessage;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeQibla();
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeQibla() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Check compass availability
    _hasCompass = FlutterCompass.events != null;

    if (!_hasCompass) {
      setState(() {
        _isLoading = false;
        _errorMessage = AppStrings.noCompassSensor;
      });
      return;
    }

    // Get location
    final position = await _locationService.getCurrentPosition();

    if (position == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = AppStrings.locationPermissionDenied;
      });
      return;
    }

    _currentPosition = position;

    // Calculate Qibla direction
    _qiblaDirection = QiblaCalculator.calculateQiblaDirection(
      position.latitude,
      position.longitude,
    );

    // Calculate distance
    _distanceToKaaba = QiblaCalculator.calculateDistanceToKaaba(
      position.latitude,
      position.longitude,
    );

    // Start compass stream
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (mounted && event.heading != null) {
        setState(() {
          _heading = event.heading!;
        });
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.qiblaCompass,
          style: StyleText.regular20().copyWith(
            color: context.onPrimaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.onPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: context.backgroundColor,
        child: _isLoading
            ? _buildLoadingWidget()
            : _errorMessage != null
                ? _buildErrorWidget()
                : _buildQiblaContent(),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.primaryColor,
          ),
          SizedBox(height: 20.h),
          Text(
            AppStrings.detectingLocation,
            style: StyleText.regular16().copyWith(
              color: context.onPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: context.primaryColor.withAlpha(150),
            ),
            SizedBox(height: 20.h),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: StyleText.regular16().copyWith(
                color: context.onPrimaryColor,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _initializeQibla,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              ),
              child: Text(
                AppStrings.tryAgain,
                style: StyleText.regular16().copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => _locationService.openAppSettings(),
              child: Text(
                AppStrings.openSettings,
                style: StyleText.regular14().copyWith(
                  color: context.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQiblaContent() {
    final isAligned = (_heading - _qiblaDirection).abs() < 5 ||
        (360 - (_heading - _qiblaDirection).abs()) < 5;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Compass
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: context.primaryColor.withAlpha(10),
                shape: BoxShape.circle,
              ),
              child: CompassWidget(
                heading: _heading,
                qiblaDirection: _qiblaDirection,
              ),
            ),
            SizedBox(height: 30.h),
            // Alignment indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isAligned
                    ? Colors.green.withAlpha(30)
                    : context.primaryColor.withAlpha(20),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isAligned
                      ? Colors.green
                      : context.primaryColor.withAlpha(50),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isAligned ? Icons.check_circle : Icons.explore,
                    color: isAligned ? Colors.green : context.primaryColor,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    isAligned
                        ? AppStrings.qiblaAligned
                        : AppStrings.rotateToQibla,
                    style: StyleText.regular16().copyWith(
                      color: isAligned ? Colors.green : context.onPrimaryColor,
                      fontWeight:
                          isAligned ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            // Info cards
            _buildInfoCard(
              icon: Icons.explore,
              title: AppStrings.qiblaDirection,
              value: '${_qiblaDirection.toStringAsFixed(1)}°',
            ),
            SizedBox(height: 12.h),
            _buildInfoCard(
              icon: Icons.straighten,
              title: AppStrings.distanceToKaaba,
              value: '${_distanceToKaaba.toStringAsFixed(0)} ${AppStrings.km}',
            ),
            SizedBox(height: 12.h),
            _buildInfoCard(
              icon: Icons.navigation,
              title: AppStrings.currentHeading,
              value: '${_heading.toStringAsFixed(1)}°',
            ),
            SizedBox(height: 24.h),
            // Location info
            if (_currentPosition != null)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: context.primaryColor.withAlpha(10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: context.primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                        style: StyleText.regular14().copyWith(
                          color: context.onPrimaryColor.withAlpha(180),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.primaryColor.withAlpha(10),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.primaryColor.withAlpha(30),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(20),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: context.primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: StyleText.regular14().copyWith(
                    color: context.onPrimaryColor.withAlpha(180),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: StyleText.bold18().copyWith(
                    color: context.onPrimaryColor,
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
