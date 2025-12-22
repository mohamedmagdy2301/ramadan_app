import 'package:equatable/equatable.dart';

/// Base failure class for handling errors in the app
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Failure for server-related errors
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    super.message = 'حدث خطأ في الخادم',
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure for network/connection errors
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'لا يوجد اتصال بالإنترنت',
  });
}

/// Failure for cache-related errors
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'حدث خطأ في التخزين المحلي',
  });
}

/// Failure for location-related errors
class LocationFailure extends Failure {
  final LocationFailureType type;

  const LocationFailure({
    required super.message,
    this.type = LocationFailureType.unknown,
  });

  @override
  List<Object?> get props => [message, type];
}

enum LocationFailureType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeout,
  unknown,
}

/// Failure for parsing/format errors
class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'حدث خطأ في معالجة البيانات',
  });
}

/// Failure for timeout errors
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'انتهت مهلة الاتصال',
  });
}

/// Failure for unknown errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'حدث خطأ غير متوقع',
  });
}
