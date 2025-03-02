import 'package:flutter/material.dart';

import '../widgets/appbar_azkar.dart';
import '../widgets/azkar_screen_body.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});
  static const String routeName = "/azkarScreen";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: AppBarAzkar(), body: AzkarScreenBody());
  }
}
