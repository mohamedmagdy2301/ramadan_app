import 'package:flutter/material.dart';

class DhikrModel {
  final String id;
  final String text;
  final String subtitle;
  final int defaultTarget;
  final Color color;
  final IconData icon;

  const DhikrModel({
    required this.id,
    required this.text,
    required this.subtitle,
    required this.defaultTarget,
    required this.color,
    required this.icon,
  });

  static const List<DhikrModel> defaultDhikrList = [
    DhikrModel(
      id: 'subhanallah',
      text: 'سبحان الله',
      subtitle: 'Glory be to Allah',
      defaultTarget: 33,
      color: Color(0xFF4CAF50),
      icon: Icons.spa,
    ),
    DhikrModel(
      id: 'alhamdulillah',
      text: 'الحمد لله',
      subtitle: 'Praise be to Allah',
      defaultTarget: 33,
      color: Color(0xFF2196F3),
      icon: Icons.favorite,
    ),
    DhikrModel(
      id: 'allahuakbar',
      text: 'الله أكبر',
      subtitle: 'Allah is the Greatest',
      defaultTarget: 33,
      color: Color(0xFFFF9800),
      icon: Icons.star,
    ),
    DhikrModel(
      id: 'lailahaillallah',
      text: 'لا إله إلا الله',
      subtitle: 'There is no god but Allah',
      defaultTarget: 100,
      color: Color(0xFF9C27B0),
      icon: Icons.brightness_7,
    ),
    DhikrModel(
      id: 'subhanallahwabihamdi',
      text: 'سبحان الله وبحمده',
      subtitle: 'Glory and Praise to Allah',
      defaultTarget: 100,
      color: Color(0xFF00BCD4),
      icon: Icons.wb_sunny,
    ),
    DhikrModel(
      id: 'subhanallahalazeem',
      text: 'سبحان الله العظيم',
      subtitle: 'Glory to Allah the Almighty',
      defaultTarget: 100,
      color: Color(0xFF3F51B5),
      icon: Icons.auto_awesome,
    ),
    DhikrModel(
      id: 'astaghfirullah',
      text: 'أستغفر الله',
      subtitle: 'I seek forgiveness from Allah',
      defaultTarget: 100,
      color: Color(0xFF607D8B),
      icon: Icons.water_drop,
    ),
    DhikrModel(
      id: 'hawqala',
      text: 'لا حول ولا قوة إلا بالله',
      subtitle: 'There is no power except with Allah',
      defaultTarget: 100,
      color: Color(0xFF795548),
      icon: Icons.shield,
    ),
  ];
}

enum SabhaTarget {
  target33(33, '٣٣'),
  target99(99, '٩٩'),
  target100(100, '١٠٠'),
  target500(500, '٥٠٠'),
  target1000(1000, '١٠٠٠'),
  infinite(0, '∞');

  final int value;
  final String arabicLabel;

  const SabhaTarget(this.value, this.arabicLabel);
}
