import 'package:ramadan_app/features/hijri_calendar/domain/hijri_date.dart';

/// Converts between Gregorian and Hijri dates
/// Uses the Umm al-Qura algorithm for accurate conversion
class HijriDateConverter {
  /// Convert Gregorian date to Hijri date
  static HijriDate toHijri(DateTime gregorian) {
    // Julian Day Number calculation
    int jd = _gregorianToJulian(gregorian.year, gregorian.month, gregorian.day);

    // Convert Julian Day to Hijri
    return _julianToHijri(jd);
  }

  /// Convert Hijri date to Gregorian date
  static DateTime toGregorian(HijriDate hijri) {
    int jd = _hijriToJulian(hijri.year, hijri.month, hijri.day);
    return _julianToGregorian(jd);
  }

  /// Get today's Hijri date
  static HijriDate today() {
    return toHijri(DateTime.now());
  }

  /// Calculate days between two Hijri dates
  static int daysBetween(HijriDate from, HijriDate to) {
    int jd1 = _hijriToJulian(from.year, from.month, from.day);
    int jd2 = _hijriToJulian(to.year, to.month, to.day);
    return jd2 - jd1;
  }

  /// Get the weekday name for a Hijri date
  static String getWeekdayName(HijriDate date) {
    final gregorian = toGregorian(date);
    // DateTime weekday: 1 = Monday, 7 = Sunday
    // Our weekday list starts with Sunday = 0
    int weekdayIndex = gregorian.weekday % 7;
    return HijriDate.weekdayNames[weekdayIndex];
  }

  /// Get number of days in a Hijri month
  static int daysInMonth(int year, int month) {
    // Odd months have 30 days, even months have 29 days
    // Exception: month 12 has 30 days in leap years
    if (month == 12 && _isHijriLeapYear(year)) {
      return 30;
    }
    return month % 2 == 1 ? 30 : 29;
  }

  /// Check if a Hijri year is a leap year
  static bool _isHijriLeapYear(int year) {
    // In a 30-year cycle, years 2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29 are leap years
    return [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29].contains(year % 30);
  }

  // ============ Private conversion methods ============

  /// Convert Gregorian date to Julian Day Number
  static int _gregorianToJulian(int year, int month, int day) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }

    int a = year ~/ 100;
    int b = 2 - a + (a ~/ 4);

    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524;
  }

  /// Convert Julian Day Number to Hijri date
  static HijriDate _julianToHijri(int jd) {
    // Days since epoch of Islamic calendar (July 16, 622 CE)
    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;

    int j = ((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor() +
        (l / 5670).floor() * ((43 * l) / 15238).floor();
    l = l -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;

    int month = ((24 * l) / 709).floor();
    int day = l - ((709 * month) / 24).floor();
    int year = 30 * n + j - 30;

    return HijriDate(day: day, month: month, year: year);
  }

  /// Convert Hijri date to Julian Day Number
  static int _hijriToJulian(int year, int month, int day) {
    return ((11 * year + 3) / 30).floor() +
        354 * year +
        30 * month -
        ((month - 1) / 2).floor() +
        day +
        1948440 -
        385;
  }

  /// Convert Julian Day Number to Gregorian date
  static DateTime _julianToGregorian(int jd) {
    int l = jd + 68569;
    int n = (4 * l) ~/ 146097;
    l = l - ((146097 * n + 3) ~/ 4);
    int i = (4000 * (l + 1)) ~/ 1461001;
    l = l - ((1461 * i) ~/ 4) + 31;
    int j = (80 * l) ~/ 2447;
    int day = l - ((2447 * j) ~/ 80);
    l = j ~/ 11;
    int month = j + 2 - 12 * l;
    int year = 100 * (n - 49) + i + l;

    return DateTime(year, month, day);
  }
}
