/// Represents a Hijri (Islamic) date
class HijriDate {
  final int day;
  final int month;
  final int year;

  const HijriDate({
    required this.day,
    required this.month,
    required this.year,
  });

  /// Arabic names of Hijri months
  static const List<String> monthNames = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الثاني',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  /// Arabic names of weekdays
  static const List<String> weekdayNames = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  /// Get the month name in Arabic
  String get monthName => monthNames[month - 1];

  /// Get formatted date string
  String get formatted => '$day $monthName $year';

  /// Get formatted date with year label
  String get formattedWithLabel => '$day $monthName $year هـ';

  @override
  String toString() => 'HijriDate($day/$month/$year)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HijriDate &&
          day == other.day &&
          month == other.month &&
          year == other.year;

  @override
  int get hashCode => day.hashCode ^ month.hashCode ^ year.hashCode;

  /// Copy with modifications
  HijriDate copyWith({
    int? day,
    int? month,
    int? year,
  }) {
    return HijriDate(
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
