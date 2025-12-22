import 'dart:math';

/// Class to calculate Qibla direction from any location
class QiblaCalculator {
  // Kaaba coordinates in Mecca
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  /// Calculate Qibla direction in degrees from North (0-360)
  /// [latitude] - User's latitude in degrees
  /// [longitude] - User's longitude in degrees
  /// Returns: Qibla direction in degrees (0 = North, 90 = East, 180 = South, 270 = West)
  static double calculateQiblaDirection(double latitude, double longitude) {
    // Convert degrees to radians
    final userLatRad = _toRadians(latitude);
    final userLonRad = _toRadians(longitude);
    final kaabaLatRad = _toRadians(kaabaLatitude);
    final kaabaLonRad = _toRadians(kaabaLongitude);

    // Calculate the difference in longitude
    final lonDiff = kaabaLonRad - userLonRad;

    // Calculate Qibla direction using the spherical law of cosines
    final y = sin(lonDiff);
    final x = cos(userLatRad) * tan(kaabaLatRad) -
        sin(userLatRad) * cos(lonDiff);

    // Calculate bearing
    var bearing = atan2(y, x);

    // Convert to degrees
    bearing = _toDegrees(bearing);

    // Normalize to 0-360
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  /// Calculate distance to Kaaba in kilometers using Haversine formula
  static double calculateDistanceToKaaba(double latitude, double longitude) {
    const earthRadius = 6371.0; // Earth's radius in kilometers

    final lat1Rad = _toRadians(latitude);
    final lat2Rad = _toRadians(kaabaLatitude);
    final deltaLat = _toRadians(kaabaLatitude - latitude);
    final deltaLon = _toRadians(kaabaLongitude - longitude);

    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) => degrees * pi / 180;
  static double _toDegrees(double radians) => radians * 180 / pi;
}
