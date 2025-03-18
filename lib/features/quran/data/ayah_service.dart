// ignore_for_file: non_constant_identifier_names

import 'package:ramadan_app/core/network/api_services.dart';
import 'package:ramadan_app/features/quran/data/ayah_modell.dart';

class AyahService {
  Future<List<AyahModell>> getAyahData(
    int suraNumber,
    String nameReader,
  ) async {
    Map<String, dynamic> AyahList = await Api().getApi(
      url: 'https://api.alquran.cloud/v1/surah/$suraNumber/ar.$nameReader',
    );
    List<AyahModell> ayahModelList = [];
    for (int i = 0; i < AyahList['data']['ayahs'].length; i++) {
      ayahModelList.add(AyahModell.fromJson(AyahList['data']['ayahs'][i]));
    }
    return ayahModelList;
  }
}
