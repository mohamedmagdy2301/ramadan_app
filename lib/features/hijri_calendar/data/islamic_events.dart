import 'package:ramadan_app/features/hijri_calendar/data/hijri_date_converter.dart';
import 'package:ramadan_app/features/hijri_calendar/domain/hijri_date.dart';

/// Represents an Islamic event/occasion
class IslamicEvent {
  final String name;
  final int day;
  final int month;
  final String? description;
  final bool isHoliday;

  const IslamicEvent({
    required this.name,
    required this.day,
    required this.month,
    this.description,
    this.isHoliday = false,
  });

  /// Get the Hijri date for this event in a given year
  HijriDate getDateInYear(int year) {
    return HijriDate(day: day, month: month, year: year);
  }

  /// Calculate days remaining until this event from today
  int daysUntil() {
    final today = HijriDateConverter.today();
    final eventThisYear = getDateInYear(today.year);

    int days = HijriDateConverter.daysBetween(today, eventThisYear);

    // If the event has passed this year, calculate for next year
    if (days < 0) {
      final eventNextYear = getDateInYear(today.year + 1);
      days = HijriDateConverter.daysBetween(today, eventNextYear);
    }

    return days;
  }

  /// Check if this event is today
  bool isToday() {
    final today = HijriDateConverter.today();
    return today.day == day && today.month == month;
  }
}

/// List of important Islamic events
class IslamicEvents {
  static const List<IslamicEvent> events = [
    IslamicEvent(
      name: 'رأس السنة الهجرية',
      day: 1,
      month: 1,
      description: 'بداية العام الهجري الجديد',
      isHoliday: true,
    ),
    IslamicEvent(
      name: 'يوم عاشوراء',
      day: 10,
      month: 1,
      description: 'يوم صيام مستحب',
    ),
    IslamicEvent(
      name: 'المولد النبوي الشريف',
      day: 12,
      month: 3,
      description: 'ذكرى مولد النبي محمد ﷺ',
      isHoliday: true,
    ),
    IslamicEvent(
      name: 'الإسراء والمعراج',
      day: 27,
      month: 7,
      description: 'ذكرى رحلة الإسراء والمعراج',
    ),
    IslamicEvent(
      name: 'ليلة النصف من شعبان',
      day: 15,
      month: 8,
      description: 'ليلة مباركة للدعاء والاستغفار',
    ),
    IslamicEvent(
      name: 'بداية شهر رمضان',
      day: 1,
      month: 9,
      description: 'بداية شهر الصيام المبارك',
      isHoliday: true,
    ),
    IslamicEvent(
      name: 'ليلة القدر',
      day: 27,
      month: 9,
      description: 'خير من ألف شهر',
    ),
    IslamicEvent(
      name: 'عيد الفطر',
      day: 1,
      month: 10,
      description: 'عيد الفطر المبارك',
      isHoliday: true,
    ),
    IslamicEvent(
      name: 'يوم عرفة',
      day: 9,
      month: 12,
      description: 'أفضل أيام الدنيا',
    ),
    IslamicEvent(
      name: 'عيد الأضحى',
      day: 10,
      month: 12,
      description: 'عيد الأضحى المبارك',
      isHoliday: true,
    ),
  ];

  /// Get upcoming events sorted by days remaining
  static List<IslamicEvent> getUpcomingEvents({int limit = 5}) {
    final sorted = List<IslamicEvent>.from(events)
      ..sort((a, b) => a.daysUntil().compareTo(b.daysUntil()));

    return sorted.take(limit).toList();
  }

  /// Get today's events
  static List<IslamicEvent> getTodayEvents() {
    return events.where((e) => e.isToday()).toList();
  }

  /// Get events for a specific month
  static List<IslamicEvent> getEventsForMonth(int month) {
    return events.where((e) => e.month == month).toList();
  }
}
