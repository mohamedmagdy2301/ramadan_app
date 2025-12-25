import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/prayer_notifications/domain/entities/adhan_sound.dart';
import 'package:ramadan_app/features/prayer_notifications/services/adhan_player_service.dart';

void main() {
  group('AdhanPlayerService', () {
    group('singleton', () {
      test('should return same instance', () {
        final instance1 = AdhanPlayerService.instance;
        final instance2 = AdhanPlayerService.instance;

        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('initial state', () {
      test('isPlaying should be false initially', () {
        final service = AdhanPlayerService.instance;
        expect(service.isPlaying, isFalse);
      });

      test('currentAdhan should be null initially', () {
        final service = AdhanPlayerService.instance;
        expect(service.currentAdhan, isNull);
      });
    });

    group('static methods', () {
      test('isPlayingStatic should return same value as instance', () {
        expect(AdhanPlayerService.isPlayingStatic,
            equals(AdhanPlayerService.instance.isPlaying));
      });

      test('currentAdhanStatic should return same value as instance', () {
        expect(AdhanPlayerService.currentAdhanStatic,
            equals(AdhanPlayerService.instance.currentAdhan));
      });
    });

    group('IAdhanPlayerService interface', () {
      test('should implement IAdhanPlayerService', () {
        final service = AdhanPlayerService.instance;
        expect(service, isA<IAdhanPlayerService>());
      });
    });
  });

  group('AdhanSound integration', () {
    test('all AdhanSound values should have valid asset paths', () {
      for (final adhan in AdhanSound.values) {
        expect(adhan.assetPath, isNotEmpty);
        expect(adhan.assetPath, startsWith('assets/'));
        expect(adhan.assetPath, endsWith('.mp3'));
      }
    });

    test('all AdhanSound values should have valid raw resource names', () {
      for (final adhan in AdhanSound.values) {
        expect(adhan.rawResourceName, isNotEmpty);
        expect(adhan.rawResourceName.contains('.'), isFalse);
      }
    });
  });
}
