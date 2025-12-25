import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/sabha/data/models/dhikr_model.dart';

void main() {
  group('DhikrModel', () {
    test('defaultDhikrList contains expected dhikr types', () {
      final list = DhikrModel.defaultDhikrList;

      expect(list.length, 8);
      expect(list[0].id, 'subhanallah');
      expect(list[0].text, 'سبحان الله');
      expect(list[0].defaultTarget, 33);

      expect(list[1].id, 'alhamdulillah');
      expect(list[1].text, 'الحمد لله');
      expect(list[1].defaultTarget, 33);

      expect(list[2].id, 'allahuakbar');
      expect(list[2].text, 'الله أكبر');
      expect(list[2].defaultTarget, 33);
    });

    test('each dhikr has unique id', () {
      final list = DhikrModel.defaultDhikrList;
      final ids = list.map((d) => d.id).toSet();

      expect(ids.length, list.length);
    });

    test('each dhikr has non-empty text and subtitle', () {
      for (final dhikr in DhikrModel.defaultDhikrList) {
        expect(dhikr.text.isNotEmpty, true);
        expect(dhikr.subtitle.isNotEmpty, true);
      }
    });

    test('each dhikr has valid target', () {
      for (final dhikr in DhikrModel.defaultDhikrList) {
        expect(dhikr.defaultTarget, greaterThan(0));
      }
    });
  });

  group('SabhaTarget', () {
    test('target values are correct', () {
      expect(SabhaTarget.target33.value, 33);
      expect(SabhaTarget.target99.value, 99);
      expect(SabhaTarget.target100.value, 100);
      expect(SabhaTarget.target500.value, 500);
      expect(SabhaTarget.target1000.value, 1000);
      expect(SabhaTarget.infinite.value, 0);
    });

    test('Arabic labels are correct', () {
      expect(SabhaTarget.target33.arabicLabel, '٣٣');
      expect(SabhaTarget.target99.arabicLabel, '٩٩');
      expect(SabhaTarget.target100.arabicLabel, '١٠٠');
      expect(SabhaTarget.target500.arabicLabel, '٥٠٠');
      expect(SabhaTarget.target1000.arabicLabel, '١٠٠٠');
      expect(SabhaTarget.infinite.arabicLabel, '∞');
    });
  });
}
