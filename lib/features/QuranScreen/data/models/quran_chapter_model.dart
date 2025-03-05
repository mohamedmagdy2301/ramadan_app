import 'package:ramadan_app/features/QuranScreen/data/database/quran_database.dart';

class QuranChapterModel {
  int id;
  String name;
  String transliteration;
  String type;
  int totalVerses;
  List<QuranVerse> verses;

  // Constructor
  QuranChapterModel({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.type,
    required this.totalVerses,
    required this.verses,
  });

  // Convert from JSON to QuranChapter object
  factory QuranChapterModel.fromJson(Map<String, dynamic> json) {
    return QuranChapterModel(
      id: json['id'],
      name: json['name'],
      transliteration: json['transliteration'],
      type: json['type'],
      totalVerses: json['total_verses'],
      verses:
          List.from(json['verses']).map((e) => QuranVerse.fromJson(e)).toList(),
    );
  }
}

// Define the QuranVerse class
class QuranVerse {
  int id;
  String text;

  // Constructor
  QuranVerse({required this.id, required this.text});

  // Convert from JSON to QuranVerse object
  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(id: json['id'], text: json['text']);
  }
}

List<QuranChapterModel> quranData =
    List.from(quranDataBase).map((e) => QuranChapterModel.fromJson(e)).toList();
