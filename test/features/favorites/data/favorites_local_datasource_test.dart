import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_item.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_type.dart';

void main() {
  group('FavoriteItem', () {
    test('should create with required fields', () {
      final item = FavoriteItem(
        id: 'azkar_sabah',
        type: FavoriteType.azkar,
        title: 'أذكار الصباح',
        addedAt: DateTime(2024, 1, 1),
      );

      expect(item.id, 'azkar_sabah');
      expect(item.type, FavoriteType.azkar);
      expect(item.title, 'أذكار الصباح');
      expect(item.addedAt, DateTime(2024, 1, 1));
    });

    test('should create with optional subtitle', () {
      final item = FavoriteItem(
        id: 'azkar_sabah',
        type: FavoriteType.azkar,
        title: 'أذكار الصباح',
        subtitle: 'أذكار',
        addedAt: DateTime(2024, 1, 1),
      );

      expect(item.subtitle, 'أذكار');
    });

    test('toJson should return correct map', () {
      final item = FavoriteItem(
        id: 'azkar_sabah',
        type: FavoriteType.azkar,
        title: 'أذكار الصباح',
        addedAt: DateTime(2024, 1, 1, 12, 0, 0),
      );

      final json = item.toJson();

      expect(json['id'], 'azkar_sabah');
      expect(json['type'], 'azkar');
      expect(json['title'], 'أذكار الصباح');
      expect(json['addedAt'], '2024-01-01T12:00:00.000');
    });

    test('fromJson should create correct item', () {
      final json = {
        'id': 'azkar_sabah',
        'type': 'azkar',
        'title': 'أذكار الصباح',
        'subtitle': 'أذكار',
        'addedAt': '2024-01-01T12:00:00.000',
      };

      final item = FavoriteItem.fromJson(json);

      expect(item.id, 'azkar_sabah');
      expect(item.type, FavoriteType.azkar);
      expect(item.title, 'أذكار الصباح');
      expect(item.subtitle, 'أذكار');
      expect(item.addedAt.year, 2024);
      expect(item.addedAt.month, 1);
      expect(item.addedAt.day, 1);
    });

    test('equality should work correctly', () {
      final item1 = FavoriteItem(
        id: 'azkar_sabah',
        type: FavoriteType.azkar,
        title: 'أذكار الصباح',
        addedAt: DateTime(2024, 1, 1),
      );

      final item2 = FavoriteItem(
        id: 'azkar_sabah',
        type: FavoriteType.azkar,
        title: 'أذكار الصباح',
        addedAt: DateTime(2024, 1, 1),
      );

      final item3 = FavoriteItem(
        id: 'different_id',
        type: FavoriteType.azkar,
        title: 'أذكار الصباح',
        addedAt: DateTime(2024, 1, 1),
      );

      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
    });

    test('copyWith should create new instance with modified values', () {
      final original = FavoriteItem(
        id: 'azkar_sabah',
        type: FavoriteType.azkar,
        title: 'أذكار الصباح',
        addedAt: DateTime(2024, 1, 1),
      );

      final modified = original.copyWith(title: 'New Title');

      expect(modified.title, 'New Title');
      expect(modified.id, 'azkar_sabah');
      expect(original.title, 'أذكار الصباح'); // Original unchanged
    });
  });

  group('FavoriteType', () {
    test('should have correct values', () {
      expect(FavoriteType.azkar.value, 'azkar');
      expect(FavoriteType.dua.value, 'dua');
      expect(FavoriteType.surah.value, 'surah');
    });

    test('should have correct Arabic names', () {
      expect(FavoriteType.azkar.arabicName, 'أذكار');
      expect(FavoriteType.dua.arabicName, 'أدعية');
      expect(FavoriteType.surah.arabicName, 'قرآن');
    });

    test('fromString should return correct type', () {
      expect(FavoriteType.fromString('azkar'), FavoriteType.azkar);
      expect(FavoriteType.fromString('dua'), FavoriteType.dua);
      expect(FavoriteType.fromString('surah'), FavoriteType.surah);
    });

    test('fromString should return null for null input', () {
      expect(FavoriteType.fromString(null), null);
    });

    test('fromString should return default for invalid input', () {
      expect(FavoriteType.fromString('invalid'), FavoriteType.azkar);
    });
  });
}
