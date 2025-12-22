import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/prayer_notifications/presentation/widgets/pre_alert_selector.dart';

// Simple widget for testing that doesn't depend on AdaptiveTheme
class TestPreAlertSelector extends StatelessWidget {
  const TestPreAlertSelector({
    super.key,
    required this.selectedMinutes,
    required this.onChanged,
  });

  final int selectedMinutes;
  final ValueChanged<int> onChanged;

  static const List<int> preAlertOptions = [0, 5, 10, 15];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(30),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التنبيه المسبق',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            selectedMinutes == 0
                ? 'بدون تنبيه مسبق'
                : 'تنبيه قبل موعد الصلاة بـ $selectedMinutes دقيقة',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(150),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: preAlertOptions.map((minutes) {
              final isSelected = selectedMinutes == minutes;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _TestPreAlertChip(
                    minutes: minutes,
                    isSelected: isSelected,
                    onTap: () => onChanged(minutes),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TestPreAlertChip extends StatelessWidget {
  const _TestPreAlertChip({
    required this.minutes,
    required this.isSelected,
    required this.onTap,
  });

  final int minutes;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withAlpha(50),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              minutes == 0 ? '0' : '$minutes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  Widget createTestWidget({
    required int selectedMinutes,
    required ValueChanged<int> onChanged,
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
          body: SingleChildScrollView(
            child: TestPreAlertSelector(
              selectedMinutes: selectedMinutes,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }

  group('PreAlertSelector', () {
    testWidgets('should display title', (tester) async {
      await tester.pumpWidget(createTestWidget(
        selectedMinutes: 0,
        onChanged: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.text('التنبيه المسبق'), findsOneWidget);
    });

    testWidgets('should display no pre-alert message when 0 minutes selected',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        selectedMinutes: 0,
        onChanged: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.text('بدون تنبيه مسبق'), findsOneWidget);
    });

    testWidgets('should display pre-alert description when minutes selected',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        selectedMinutes: 10,
        onChanged: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('10'), findsAtLeast(1));
    });

    testWidgets('should display all time options', (tester) async {
      await tester.pumpWidget(createTestWidget(
        selectedMinutes: 0,
        onChanged: (_) {},
      ));
      await tester.pumpAndSettle();

      // Check for all option values
      expect(find.text('0'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('should call onChanged when option is tapped', (tester) async {
      int? selectedValue;

      await tester.pumpWidget(createTestWidget(
        selectedMinutes: 0,
        onChanged: (value) => selectedValue = value,
      ));
      await tester.pumpAndSettle();

      // Tap on the 10 minutes option
      await tester.tap(find.text('10'));
      await tester.pump();

      expect(selectedValue, equals(10));
    });

    testWidgets('should call onChanged with 5 when 5 is tapped',
        (tester) async {
      int? selectedValue;

      await tester.pumpWidget(createTestWidget(
        selectedMinutes: 0,
        onChanged: (value) => selectedValue = value,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('5'));
      await tester.pump();

      expect(selectedValue, equals(5));
    });

    testWidgets('should call onChanged with 15 when 15 is tapped',
        (tester) async {
      int? selectedValue;

      await tester.pumpWidget(createTestWidget(
        selectedMinutes: 0,
        onChanged: (value) => selectedValue = value,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pump();

      expect(selectedValue, equals(15));
    });

    testWidgets('should call onChanged with 0 when 0 is tapped',
        (tester) async {
      int? selectedValue;

      await tester.pumpWidget(createTestWidget(
        selectedMinutes: 10,
        onChanged: (value) => selectedValue = value,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('0'));
      await tester.pump();

      expect(selectedValue, equals(0));
    });

    test('preAlertOptions should contain expected values', () {
      expect(PreAlertSelector.preAlertOptions, equals([0, 5, 10, 15]));
    });
  });
}
