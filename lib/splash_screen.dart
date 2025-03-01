import 'package:flutter/material.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';
import 'package:ramadan_app/core/router/router_helper.dart';
import 'package:ramadan_app/core/router/routes.dart';
import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      navigateAndFinish(context, AppRoutes.mainScaffold);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            50.hSpace,
            CustomLoadingWidget(),
            20.hSpace,
          ],
        ),
      ),
    );
  }
}
