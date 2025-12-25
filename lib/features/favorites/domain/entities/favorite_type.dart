/// Type of favorite item
enum FavoriteType {
  azkar('azkar', 'أذكار'),
  dua('dua', 'أدعية'),
  surah('surah', 'قرآن');

  final String value;
  final String arabicName;

  const FavoriteType(this.value, this.arabicName);

  static FavoriteType? fromString(String? value) {
    if (value == null) return null;
    return FavoriteType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => FavoriteType.azkar,
    );
  }
}
