import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/prayer_notifications/domain/entities/adhan_sound.dart';

void main() {
  group('AdhanSound', () {
    group('arabicName', () {
      test('should return correct Arabic name for makkah', () {
        expect(AdhanSound.makkah.arabicName, equals('أذان الحرم المكي'));
      });

      test('should return correct Arabic name for defaultSound', () {
        expect(AdhanSound.defaultSound.arabicName, equals('الصوت الافتراضي'));
      });
    });

    group('assetPath', () {
      test('should return correct asset path for makkah', () {
        expect(AdhanSound.makkah.assetPath, equals('assets/sound/adan.mp3'));
      });

      test('should return correct asset path for defaultSound', () {
        expect(
            AdhanSound.defaultSound.assetPath, equals('assets/sound/reminder.mp3'));
      });
    });

    group('rawResourceName', () {
      test('should return correct raw resource name for makkah', () {
        expect(AdhanSound.makkah.rawResourceName, equals('sound_test'));
      });

      test('should return correct raw resource name for defaultSound', () {
        expect(AdhanSound.defaultSound.rawResourceName, equals('sound_test'));
      });

      test('all adhan sounds should use sound_test resource', () {
        final names =
            AdhanSound.values.map((e) => e.rawResourceName).toSet();
        expect(names, contains('sound_test'));
      });
    });

    group('fromString', () {
      test('should return correct AdhanSound for valid name', () {
        expect(AdhanSound.fromString('makkah'), equals(AdhanSound.makkah));
        expect(AdhanSound.fromString('defaultSound'),
            equals(AdhanSound.defaultSound));
      });

      test('should return null for null input', () {
        expect(AdhanSound.fromString(null), isNull);
      });

      test('should return null for invalid name', () {
        expect(AdhanSound.fromString('invalid'), isNull);
        expect(AdhanSound.fromString(''), isNull);
        expect(AdhanSound.fromString('MAKKAH'), isNull);
      });
    });

    group('values', () {
      test('should have expected number of values', () {
        expect(AdhanSound.values.length, equals(2));
      });

      test('should contain all expected adhan sounds', () {
        expect(AdhanSound.values, contains(AdhanSound.makkah));
        expect(AdhanSound.values, contains(AdhanSound.defaultSound));
      });
    });
  });
}
