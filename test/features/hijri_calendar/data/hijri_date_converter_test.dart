import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/hijri_calendar/data/hijri_date_converter.dart';
import 'package:ramadan_app/features/hijri_calendar/domain/hijri_date.dart';

void main() {
  group('HijriDateConverter', () {
    group('toHijri', () {
      test('should convert known date correctly - January 1, 2024', () {
        // January 1, 2024 = 19 Jumada al-Thani 1445
        final gregorian = DateTime(2024, 1, 1);
        final hijri = HijriDateConverter.toHijri(gregorian);

        expect(hijri.year, 1445);
        expect(hijri.month, 6); // Jumada al-Thani
        expect(hijri.day, greaterThan(15));
        expect(hijri.day, lessThan(25));
      });

      test('should convert Ramadan 1, 1445 correctly', () {
        // Ramadan 1, 1445 = approximately March 11, 2024
        final gregorian = DateTime(2024, 3, 11);
        final hijri = HijriDateConverter.toHijri(gregorian);

        expect(hijri.year, 1445);
        expect(hijri.month, 9); // Ramadan
        expect(hijri.day, lessThan(5));
      });

      test('should convert Eid al-Fitr 1445 correctly', () {
        // Eid al-Fitr 1445 = approximately April 10, 2024
        final gregorian = DateTime(2024, 4, 10);
        final hijri = HijriDateConverter.toHijri(gregorian);

        expect(hijri.year, 1445);
        expect(hijri.month, 10); // Shawwal
        expect(hijri.day, lessThan(5));
      });

      test('should handle dates in different centuries', () {
        // Year 2000
        final hijri2000 = HijriDateConverter.toHijri(DateTime(2000, 1, 1));
        expect(hijri2000.year, greaterThan(1400));
        expect(hijri2000.year, lessThan(1425));

        // Year 1990
        final hijri1990 = HijriDateConverter.toHijri(DateTime(1990, 1, 1));
        expect(hijri1990.year, greaterThan(1400));
        expect(hijri1990.year, lessThan(1415));
      });
    });

    group('toGregorian', () {
      test('should convert back to Gregorian correctly', () {
        final original = DateTime(2024, 6, 15);
        final hijri = HijriDateConverter.toHijri(original);
        final converted = HijriDateConverter.toGregorian(hijri);

        expect(converted.year, original.year);
        expect(converted.month, original.month);
        expect(converted.day, original.day);
      });

      test('should convert Ramadan 1, 1446 to Gregorian', () {
        final hijri = HijriDate(day: 1, month: 9, year: 1446);
        final gregorian = HijriDateConverter.toGregorian(hijri);

        // Ramadan 1, 1446 should be around February/March 2025
        expect(gregorian.year, 2025);
        expect(gregorian.month, greaterThan(1));
        expect(gregorian.month, lessThan(4));
      });
    });

    group('today', () {
      test('should return a valid HijriDate', () {
        final today = HijriDateConverter.today();

        expect(today.year, greaterThan(1440));
        expect(today.year, lessThan(1460));
        expect(today.month, greaterThan(0));
        expect(today.month, lessThan(13));
        expect(today.day, greaterThan(0));
        expect(today.day, lessThan(31));
      });
    });

    group('daysBetween', () {
      test('should return 0 for same date', () {
        final date = HijriDate(day: 15, month: 1, year: 1445);
        final days = HijriDateConverter.daysBetween(date, date);

        expect(days, 0);
      });

      test('should return positive number for future date', () {
        final from = HijriDate(day: 1, month: 1, year: 1445);
        final to = HijriDate(day: 15, month: 1, year: 1445);
        final days = HijriDateConverter.daysBetween(from, to);

        expect(days, 14);
      });

      test('should return negative number for past date', () {
        final from = HijriDate(day: 15, month: 1, year: 1445);
        final to = HijriDate(day: 1, month: 1, year: 1445);
        final days = HijriDateConverter.daysBetween(from, to);

        expect(days, -14);
      });

      test('should calculate days across months correctly', () {
        final from = HijriDate(day: 25, month: 1, year: 1445);
        final to = HijriDate(day: 5, month: 2, year: 1445);
        final days = HijriDateConverter.daysBetween(from, to);

        // Month 1 has 30 days, so 5 days remaining + 5 days into month 2 = 10 days
        expect(days, greaterThan(8));
        expect(days, lessThan(12));
      });
    });

    group('getWeekdayName', () {
      test('should return valid Arabic weekday name', () {
        final date = HijriDateConverter.today();
        final weekday = HijriDateConverter.getWeekdayName(date);

        expect(HijriDate.weekdayNames, contains(weekday));
      });
    });

    group('daysInMonth', () {
      test('should return 30 for odd months', () {
        expect(HijriDateConverter.daysInMonth(1445, 1), 30); // Muharram
        expect(HijriDateConverter.daysInMonth(1445, 3), 30); // Rabi al-Awwal
        expect(HijriDateConverter.daysInMonth(1445, 5), 30); // Jumada al-Ula
        expect(HijriDateConverter.daysInMonth(1445, 7), 30); // Rajab
        expect(HijriDateConverter.daysInMonth(1445, 9), 30); // Ramadan
        expect(HijriDateConverter.daysInMonth(1445, 11), 30); // Dhu al-Qadah
      });

      test('should return 29 for even months (except leap year month 12)', () {
        expect(HijriDateConverter.daysInMonth(1445, 2), 29); // Safar
        expect(HijriDateConverter.daysInMonth(1445, 4), 29); // Rabi al-Thani
        expect(HijriDateConverter.daysInMonth(1445, 6), 29); // Jumada al-Thani
        expect(HijriDateConverter.daysInMonth(1445, 8), 29); // Shaban
        expect(HijriDateConverter.daysInMonth(1445, 10), 29); // Shawwal
      });
    });
  });

  group('HijriDate', () {
    test('should have correct month names', () {
      expect(HijriDate.monthNames.length, 12);
      expect(HijriDate.monthNames[0], 'محرم');
      expect(HijriDate.monthNames[8], 'رمضان');
      expect(HijriDate.monthNames[11], 'ذو الحجة');
    });

    test('should have correct weekday names', () {
      expect(HijriDate.weekdayNames.length, 7);
      expect(HijriDate.weekdayNames[0], 'الأحد');
      expect(HijriDate.weekdayNames[5], 'الجمعة');
    });

    test('monthName should return correct name', () {
      final date = HijriDate(day: 1, month: 9, year: 1445);
      expect(date.monthName, 'رمضان');
    });

    test('formatted should return correct format', () {
      final date = HijriDate(day: 15, month: 9, year: 1445);
      expect(date.formatted, '15 رمضان 1445');
    });

    test('formattedWithLabel should include هـ', () {
      final date = HijriDate(day: 15, month: 9, year: 1445);
      expect(date.formattedWithLabel, '15 رمضان 1445 هـ');
    });

    test('equality should work correctly', () {
      final date1 = HijriDate(day: 1, month: 1, year: 1445);
      final date2 = HijriDate(day: 1, month: 1, year: 1445);
      final date3 = HijriDate(day: 2, month: 1, year: 1445);

      expect(date1, equals(date2));
      expect(date1, isNot(equals(date3)));
    });

    test('copyWith should create new instance with modified values', () {
      final original = HijriDate(day: 1, month: 1, year: 1445);
      final modified = original.copyWith(day: 15);

      expect(modified.day, 15);
      expect(modified.month, 1);
      expect(modified.year, 1445);
      expect(original.day, 1); // Original unchanged
    });
  });
}
