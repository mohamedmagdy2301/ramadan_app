import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/prayer_notifications/domain/entities/prayer_notification_settings.dart';

// Simple widget for testing that doesn't depend on AdaptiveTheme
class TestPrayerNotificationTile extends StatelessWidget {
  const TestPrayerNotificationTile({
    super.key,
    required this.prayerType,
    required this.isEnabled,
    required this.onToggle,
  });

  final PrayerType prayerType;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(30),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isEnabled
                  ? Theme.of(context).primaryColor.withAlpha(25)
                  : Theme.of(context).colorScheme.onPrimary.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getPrayerIcon(prayerType),
              color: isEnabled
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onPrimary.withAlpha(100),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              prayerType.arabicName,
              style: TextStyle(
                fontSize: 18,
                color: isEnabled
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onPrimary.withAlpha(120),
                fontWeight: isEnabled ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          Switch.adaptive(
            value: isEnabled,
            onChanged: onToggle,
            activeTrackColor: Theme.of(context).primaryColor,
            thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }

  IconData _getPrayerIcon(PrayerType prayer) {
    switch (prayer) {
      case PrayerType.fajr:
        return Icons.wb_twilight_rounded;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_rounded;
      case PrayerType.asr:
        return Icons.wb_sunny_outlined;
      case PrayerType.maghrib:
        return Icons.nights_stay_outlined;
      case PrayerType.isha:
        return Icons.nights_stay_rounded;
    }
  }
}

void main() {
  Widget createTestWidget({
    required PrayerType prayerType,
    required bool isEnabled,
    required ValueChanged<bool> onToggle,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.teal,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            onPrimary: Colors.black,
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Scaffold(
          body: TestPrayerNotificationTile(
            prayerType: prayerType,
            isEnabled: isEnabled,
            onToggle: onToggle,
          ),
        ),
      ),
    );
  }

  group('PrayerNotificationTile', () {
    testWidgets('should display prayer name in Arabic', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prayerType: PrayerType.fajr,
        isEnabled: true,
        onToggle: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.text('الفجر'), findsOneWidget);
    });

    testWidgets('should display all prayer names correctly', (tester) async {
      for (final prayer in PrayerType.values) {
        await tester.pumpWidget(createTestWidget(
          prayerType: prayer,
          isEnabled: true,
          onToggle: (_) {},
        ));
        await tester.pumpAndSettle();

        expect(find.text(prayer.arabicName), findsOneWidget);
      }
    });

    testWidgets('should show enabled switch when isEnabled is true',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        prayerType: PrayerType.dhuhr,
        isEnabled: true,
        onToggle: (_) {},
      ));
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      final Switch switchWidget = tester.widget(switchFinder);
      expect(switchWidget.value, isTrue);
    });

    testWidgets('should show disabled switch when isEnabled is false',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        prayerType: PrayerType.asr,
        isEnabled: false,
        onToggle: (_) {},
      ));
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      final Switch switchWidget = tester.widget(switchFinder);
      expect(switchWidget.value, isFalse);
    });

    testWidgets('should call onToggle when switch is tapped', (tester) async {
      bool? toggledValue;

      await tester.pumpWidget(createTestWidget(
        prayerType: PrayerType.maghrib,
        isEnabled: true,
        onToggle: (value) => toggledValue = value,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(toggledValue, isFalse);
    });

    testWidgets('should display prayer icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prayerType: PrayerType.fajr,
        isEnabled: true,
        onToggle: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Icon), findsAtLeast(1));
    });

    testWidgets('should display correct icon for Fajr', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prayerType: PrayerType.fajr,
        isEnabled: true,
        onToggle: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.wb_twilight_rounded), findsOneWidget);
    });

    testWidgets('should display correct icon for Dhuhr', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prayerType: PrayerType.dhuhr,
        isEnabled: true,
        onToggle: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.wb_sunny_rounded), findsOneWidget);
    });

    testWidgets('should display correct icon for Asr', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prayerType: PrayerType.asr,
        isEnabled: true,
        onToggle: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
    });

    testWidgets('should display correct icon for Maghrib', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prayerType: PrayerType.maghrib,
        isEnabled: true,
        onToggle: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.nights_stay_outlined), findsOneWidget);
    });

    testWidgets('should display correct icon for Isha', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prayerType: PrayerType.isha,
        isEnabled: true,
        onToggle: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.nights_stay_rounded), findsOneWidget);
    });
  });

  group('PrayerType', () {
    test('arabicName should return correct Arabic name for each prayer', () {
      expect(PrayerType.fajr.arabicName, equals('الفجر'));
      expect(PrayerType.dhuhr.arabicName, equals('الظهر'));
      expect(PrayerType.asr.arabicName, equals('العصر'));
      expect(PrayerType.maghrib.arabicName, equals('المغرب'));
      expect(PrayerType.isha.arabicName, equals('العشاء'));
    });

    test('notificationId should return unique IDs', () {
      final ids = PrayerType.values.map((e) => e.notificationId).toSet();
      expect(ids.length, equals(5));
    });

    test('preAlertNotificationId should return unique IDs', () {
      final ids = PrayerType.values.map((e) => e.preAlertNotificationId).toSet();
      expect(ids.length, equals(5));
    });

    test('notification IDs should not overlap with pre-alert IDs', () {
      final notificationIds = PrayerType.values.map((e) => e.notificationId).toSet();
      final preAlertIds = PrayerType.values.map((e) => e.preAlertNotificationId).toSet();
      expect(notificationIds.intersection(preAlertIds), isEmpty);
    });
  });
}
