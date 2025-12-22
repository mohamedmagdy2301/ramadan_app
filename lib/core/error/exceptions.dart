/// Custom exceptions for the app

/// Exception thrown when a server error occurs
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'حدث خطأ في الخادم',
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Exception thrown when there's no internet connection
class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'لا يوجد اتصال بالإنترنت',
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when cache operations fail
class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'حدث خطأ في التخزين المحلي',
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when location services fail
class LocationException implements Exception {
  final String message;
  final LocationExceptionType type;

  const LocationException({
    required this.message,
    this.type = LocationExceptionType.unknown,
  });

  @override
  String toString() => 'LocationException: $message';
}

enum LocationExceptionType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeout,
  unknown,
}

/// Exception thrown when parsing/format errors occur
class ParseException implements Exception {
  final String message;

  const ParseException({
    this.message = 'حدث خطأ في معالجة البيانات',
  });

  @override
  String toString() => 'ParseException: $message';
}

/// Exception thrown when a timeout occurs
class TimeoutException implements Exception {
  final String message;
  final Duration? duration;

  const TimeoutException({
    this.message = 'انتهت مهلة الاتصال',
    this.duration,
  });

  @override
  String toString() => 'TimeoutException: $message';
}
