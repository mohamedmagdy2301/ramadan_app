import 'package:geolocator/geolocator.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../prayer_times_model/prayer_times_model.dart';

/// Abstract class for prayer times remote datasource
abstract class PrayerTimesRemoteDatasource {
  /// Fetches prayer times from the API
  ///
  /// Throws [ServerException] for all server errors
  /// Throws [NetworkException] for network errors
  Future<PrayerTimesModel> fetchPrayerTimes({required Position location});
}

/// Implementation of [PrayerTimesRemoteDatasource]
class PrayerTimesRemoteDatasourceImpl implements PrayerTimesRemoteDatasource {
  final ApiClient apiClient;

  /// Base URL for the Aladhan API
  static const String _baseUrl = 'https://api.aladhan.com/v1/timings';

  /// Calculation method (5 = Egyptian General Authority of Survey)
  static const String _method = '5';

  PrayerTimesRemoteDatasourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<PrayerTimesModel> fetchPrayerTimes({required Position location}) async {
    final now = DateTime.now();
    final formattedDate = '${now.day}-${now.month}-${now.year}';

    final url = '$_baseUrl/$formattedDate';
    final queryParams = {
      'latitude': location.latitude.toString(),
      'longitude': location.longitude.toString(),
      'method': _method,
    };

    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        url: url,
        queryParameters: queryParams,
      );

      if (response['data'] == null) {
        throw const ServerException(message: 'لا توجد بيانات في الاستجابة');
      }

      return PrayerTimesModel.fromJson(response['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'خطأ في جلب مواقيت الصلاة: $e');
    }
  }
}
