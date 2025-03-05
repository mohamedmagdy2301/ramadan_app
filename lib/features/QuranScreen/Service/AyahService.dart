// ignore_for_file: non_constant_identifier_names

import 'package:ramadan_app/features/QuranScreen/Service/Api.dart';
import 'package:ramadan_app/features/QuranScreen/data/models/ayah_model.dart';

class AyahService {
  Future<List<AyahModel>> getAyahData(int suraNumber, String nameReader) async {
    Map<String, dynamic> AyahList = await Api().getApi(
      url: 'https://api.alquran.cloud/v1/surah/$suraNumber/ar.$nameReader',
    );
    List<AyahModel> ayahModelList = [];
    // Map<String, dynamic> AyahModelLis    //tFinal = {};
    // mnmnmn
    for (int i = 0; i < AyahList['data']['ayahs'].length; i++) {
      ayahModelList.add(AyahModel.fromJson(AyahList['data']['ayahs'][i]));
    }

    // AyahModelListFinal.addAll({
    //   'ayahs': ayahModelList,
    //   'number': AyahList['data']['number'],
    //   'name': AyahList['data']['name'],
    // });

    print(ayahModelList[0].audio);
    print("---------------------------------------");
    return ayahModelList;
  }
}
