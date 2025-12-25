import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/core/responsive/responsive_helper.dart';
import 'package:ramadan_app/core/responsive/screen_type.dart';

void main() {
  group('ResponsiveHelper', () {
    Widget buildTestWidget({required Size size, required Widget child}) {
      return MediaQuery(
        data: MediaQueryData(size: size),
        child: child,
      );
    }

    testWidgets('should return mobile for width < 600', (tester) async {
      late ScreenType screenType;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(500, 800),
          child: Builder(
            builder: (context) {
              screenType = ResponsiveHelper.getScreenType(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(screenType, ScreenType.mobile);
    });

    testWidgets('should return tablet for width 600-900', (tester) async {
      late ScreenType screenType;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(700, 1000),
          child: Builder(
            builder: (context) {
              screenType = ResponsiveHelper.getScreenType(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(screenType, ScreenType.tablet);
    });

    testWidgets('should return desktop for width > 900', (tester) async {
      late ScreenType screenType;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: Builder(
            builder: (context) {
              screenType = ResponsiveHelper.getScreenType(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(screenType, ScreenType.desktop);
    });

    testWidgets('isMobile should return true for mobile screens',
        (tester) async {
      late bool isMobile;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(400, 800),
          child: Builder(
            builder: (context) {
              isMobile = ResponsiveHelper.isMobile(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(isMobile, true);
    });

    testWidgets('isTablet should return true for tablet screens',
        (tester) async {
      late bool isTablet;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(700, 1000),
          child: Builder(
            builder: (context) {
              isTablet = ResponsiveHelper.isTablet(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(isTablet, true);
    });

    testWidgets('getGridColumns should return correct columns', (tester) async {
      late int mobileColumns;
      late int tabletColumns;
      late int desktopColumns;

      // Test mobile
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(400, 800),
          child: Builder(
            builder: (context) {
              mobileColumns = ResponsiveHelper.getGridColumns(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(mobileColumns, 1);

      // Test tablet
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(700, 1000),
          child: Builder(
            builder: (context) {
              tabletColumns = ResponsiveHelper.getGridColumns(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(tabletColumns, 2);

      // Test desktop
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: Builder(
            builder: (context) {
              desktopColumns = ResponsiveHelper.getGridColumns(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(desktopColumns, 3);
    });

    testWidgets('getValue should return correct value for each screen type',
        (tester) async {
      late String mobileValue;
      late String tabletValue;
      late String desktopValue;

      // Test mobile
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(400, 800),
          child: Builder(
            builder: (context) {
              mobileValue = ResponsiveHelper.getValue(
                context,
                mobile: 'mobile',
                tablet: 'tablet',
                desktop: 'desktop',
              );
              return const SizedBox();
            },
          ),
        ),
      );
      expect(mobileValue, 'mobile');

      // Test tablet
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(700, 1000),
          child: Builder(
            builder: (context) {
              tabletValue = ResponsiveHelper.getValue(
                context,
                mobile: 'mobile',
                tablet: 'tablet',
                desktop: 'desktop',
              );
              return const SizedBox();
            },
          ),
        ),
      );
      expect(tabletValue, 'tablet');

      // Test desktop
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: Builder(
            builder: (context) {
              desktopValue = ResponsiveHelper.getValue(
                context,
                mobile: 'mobile',
                tablet: 'tablet',
                desktop: 'desktop',
              );
              return const SizedBox();
            },
          ),
        ),
      );
      expect(desktopValue, 'desktop');
    });

    testWidgets('getValue should fallback correctly when values not provided',
        (tester) async {
      late String tabletValue;
      late String desktopValue;

      // Test tablet fallback to mobile
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(700, 1000),
          child: Builder(
            builder: (context) {
              tabletValue = ResponsiveHelper.getValue(
                context,
                mobile: 'mobile',
              );
              return const SizedBox();
            },
          ),
        ),
      );
      expect(tabletValue, 'mobile');

      // Test desktop fallback to tablet
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: Builder(
            builder: (context) {
              desktopValue = ResponsiveHelper.getValue(
                context,
                mobile: 'mobile',
                tablet: 'tablet',
              );
              return const SizedBox();
            },
          ),
        ),
      );
      expect(desktopValue, 'tablet');
    });

    testWidgets('getHorizontalPadding should return correct values',
        (tester) async {
      late double mobilePadding;
      late double tabletPadding;

      // Test mobile
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(400, 800),
          child: Builder(
            builder: (context) {
              mobilePadding = ResponsiveHelper.getHorizontalPadding(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(mobilePadding, 16.0);

      // Test tablet
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(700, 1000),
          child: Builder(
            builder: (context) {
              tabletPadding = ResponsiveHelper.getHorizontalPadding(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(tabletPadding, 32.0);
    });
  });
}
