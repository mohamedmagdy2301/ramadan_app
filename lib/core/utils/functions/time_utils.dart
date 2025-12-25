import 'package:flutter/material.dart';

/// Utility class for time-related operations
class TimeUtils {
  /// Check if a TimeOfDay is in the future compared to current time
  static bool isTimeInFuture(TimeOfDay time, {DateTime? now}) {
    final currentTime = now ?? DateTime.now();
    final selectedDateTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      time.hour,
      time.minute,
    );

    return selectedDateTime.isAfter(currentTime);
  }

  /// Check if a TimeOfDay is in the past compared to current time
  static bool isTimeInPast(TimeOfDay time, {DateTime? now}) {
    return !isTimeInFuture(time, now: now);
  }

  /// Convert TimeOfDay to DateTime for today
  static DateTime timeOfDayToDateTime(TimeOfDay time, {DateTime? date}) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month, d.day, time.hour, time.minute);
  }

  /// Get the next occurrence of a time (today or tomorrow if past)
  static DateTime getNextOccurrence(TimeOfDay time, {DateTime? now}) {
    final currentTime = now ?? DateTime.now();
    var scheduledTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(currentTime) ||
        scheduledTime.isAtSameMomentAs(currentTime)) {
      // Schedule for tomorrow
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime;
  }

  /// Format TimeOfDay to Arabic 12-hour format
  static String formatTimeArabic(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '$hour:$minute $period';
  }

  /// Calculate duration between two times
  static Duration durationBetween(TimeOfDay from, TimeOfDay to) {
    final fromMinutes = from.hour * 60 + from.minute;
    final toMinutes = to.hour * 60 + to.minute;

    var diff = toMinutes - fromMinutes;
    if (diff < 0) {
      // To is on the next day
      diff += 24 * 60;
    }

    return Duration(minutes: diff);
  }

  /// Parse a time string (HH:mm) to TimeOfDay
  static TimeOfDay? parseTimeString(String timeStr) {
    try {
      // Handle format like "05:30" or "5:30"
      final cleanTime = timeStr.replaceAll(RegExp(r'[^\d:]'), '');
      final parts = cleanTime.split(':');
      if (parts.length != 2) return null;

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);

      if (hour == null || minute == null) return null;
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
}
