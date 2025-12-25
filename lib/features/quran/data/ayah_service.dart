// ignore_for_file: non_constant_identifier_names

import 'package:ramadan_app/core/network/api_services.dart';
import 'package:ramadan_app/features/quran/data/ayah_model.dart';

class AyahService {
  Future<List<AyahModel>> getAyahData(
    int suraNumber,
    String nameReader,
  ) async {
    Map<String, dynamic> AyahList = await Api().getApi(
      url: 'https://api.alquran.cloud/v1/surah/$suraNumber/ar.$nameReader',
    );
    List<AyahModel> ayahModelList = [];
    for (int i = 0; i < AyahList['data']['ayahs'].length; i++) {
      ayahModelList.add(AyahModel.fromJson(AyahList['data']['ayahs'][i]));
    }
    return ayahModelList;
  }
}
