import 'package:equatable/equatable.dart';

/// Entity representing daily statistics for azkar and quran reading
class DailyStats extends Equatable {
  /// The date for these statistics (YYYY-MM-DD format)
  final String date;

  /// Number of azkar categories completed
  final int azkarCompleted;

  /// Total count of azkar repeated
  final int azkarCount;

  /// Number of Quran pages read
  final int quranPagesRead;

  /// Number of Quran surahs read
  final int quranSurahsRead;

  /// Number of sabha (tasbih) counts
  final int sabhaCount;

  /// Timestamp when stats were last updated
  final DateTime lastUpdated;

  const DailyStats({
    required this.date,
    this.azkarCompleted = 0,
    this.azkarCount = 0,
    this.quranPagesRead = 0,
    this.quranSurahsRead = 0,
    this.sabhaCount = 0,
    required this.lastUpdated,
  });

  /// Create empty stats for a given date
  factory DailyStats.empty(String date) {
    return DailyStats(
      date: date,
      lastUpdated: DateTime.now(),
    );
  }

  /// Create from JSON map
  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: json['date'] as String,
      azkarCompleted: json['azkarCompleted'] as int? ?? 0,
      azkarCount: json['azkarCount'] as int? ?? 0,
      quranPagesRead: json['quranPagesRead'] as int? ?? 0,
      quranSurahsRead: json['quranSurahsRead'] as int? ?? 0,
      sabhaCount: json['sabhaCount'] as int? ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'azkarCompleted': azkarCompleted,
      'azkarCount': azkarCount,
      'quranPagesRead': quranPagesRead,
      'quranSurahsRead': quranSurahsRead,
      'sabhaCount': sabhaCount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Copy with updated values
  DailyStats copyWith({
    String? date,
    int? azkarCompleted,
    int? azkarCount,
    int? quranPagesRead,
    int? quranSurahsRead,
    int? sabhaCount,
    DateTime? lastUpdated,
  }) {
    return DailyStats(
      date: date ?? this.date,
      azkarCompleted: azkarCompleted ?? this.azkarCompleted,
      azkarCount: azkarCount ?? this.azkarCount,
      quranPagesRead: quranPagesRead ?? this.quranPagesRead,
      quranSurahsRead: quranSurahsRead ?? this.quranSurahsRead,
      sabhaCount: sabhaCount ?? this.sabhaCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Check if any activity was done today
  bool get hasActivity =>
      azkarCompleted > 0 ||
      azkarCount > 0 ||
      quranPagesRead > 0 ||
      quranSurahsRead > 0 ||
      sabhaCount > 0;

  /// Get total activity score (for streak calculation)
  int get activityScore =>
      azkarCompleted + quranSurahsRead + (sabhaCount ~/ 100);

  @override
  List<Object?> get props => [
        date,
        azkarCompleted,
        azkarCount,
        quranPagesRead,
        quranSurahsRead,
        sabhaCount,
        lastUpdated,
      ];
}
