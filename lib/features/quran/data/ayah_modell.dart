// ignore_for_file: file_names

class AyahModell {
  String audio;
  AyahModell({required this.audio});

  factory AyahModell.fromJson(Map<String, dynamic> json) {
    return AyahModell(audio: json['audio']);
  }
}
