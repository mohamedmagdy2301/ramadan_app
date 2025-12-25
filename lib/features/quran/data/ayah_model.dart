class AyahModel {
  String audio;
  AyahModel({required this.audio});

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(audio: json['audio']);
  }
}
