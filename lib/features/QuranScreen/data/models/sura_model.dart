// Define model classes
import 'dart:convert';

class SurahModel {
  final String index;
  final SurahInfo start;
  final SurahInfo end;

  SurahModel({required this.index, required this.start, required this.end});

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      index: json['index'],
      start: SurahInfo.fromJson(json['start']),
      end: SurahInfo.fromJson(json['end']),
    );
  }
}

class SurahInfo {
  final String index;
  final String verse;
  final String name;
  final String nameAr;

  SurahInfo({
    required this.index,
    required this.verse,
    required this.name,
    required this.nameAr,
  });

  factory SurahInfo.fromJson(Map<String, dynamic> json) {
    return SurahInfo(
      index: json['index'],
      verse: json['verse'],
      name: json['name'],
      nameAr: json['nameAr'],
    );
  }
}

List<SurahModel> parseSurahs(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<SurahModel>((json) => SurahModel.fromJson(json)).toList();
}
