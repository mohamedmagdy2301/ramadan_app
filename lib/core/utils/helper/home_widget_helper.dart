import 'package:home_widget/home_widget.dart';

class HomeWidgetHelper {
  static Future<void> updateNextPrayerWidget(String prayer, String time) async {
    await HomeWidget.saveWidgetData<String>('nextPrayer', prayer);
    await HomeWidget.saveWidgetData<String>('remainingTime', time);
    await HomeWidget.updateWidget(name: 'TimePrayer', iOSName: 'TimePrayer');
  }
}
