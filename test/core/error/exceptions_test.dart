import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/core/error/exceptions.dart';

void main() {
  group('ServerException', () {
    test('should create with default message', () {
      const exception = ServerException();

      expect(exception.message, 'حدث خطأ في الخادم');
      expect(exception.statusCode, isNull);
    });

    test('should create with custom message and status code', () {
      const exception = ServerException(
        message: 'Custom error',
        statusCode: 500,
      );

      expect(exception.message, 'Custom error');
      expect(exception.statusCode, 500);
    });

    test('toString should include message and status code', () {
      const exception = ServerException(
        message: 'Test error',
        statusCode: 404,
      );

      expect(exception.toString(), 'ServerException: Test error (Status: 404)');
    });
  });

  group('NetworkException', () {
    test('should create with default message', () {
      const exception = NetworkException();

      expect(exception.message, 'لا يوجد اتصال بالإنترنت');
    });

    test('should create with custom message', () {
      const exception = NetworkException(message: 'No internet');

      expect(exception.message, 'No internet');
    });

    test('toString should include message', () {
      const exception = NetworkException(message: 'Test');

      expect(exception.toString(), 'NetworkException: Test');
    });
  });

  group('CacheException', () {
    test('should create with default message', () {
      const exception = CacheException();

      expect(exception.message, 'حدث خطأ في التخزين المحلي');
    });

    test('toString should include message', () {
      const exception = CacheException(message: 'Cache error');

      expect(exception.toString(), 'CacheException: Cache error');
    });
  });

  group('LocationException', () {
    test('should create with required message', () {
      const exception = LocationException(message: 'Location disabled');

      expect(exception.message, 'Location disabled');
      expect(exception.type, LocationExceptionType.unknown);
    });

    test('should create with type', () {
      const exception = LocationException(
        message: 'Permission denied',
        type: LocationExceptionType.permissionDenied,
      );

      expect(exception.type, LocationExceptionType.permissionDenied);
    });

    test('toString should include message', () {
      const exception = LocationException(message: 'Test');

      expect(exception.toString(), 'LocationException: Test');
    });
  });

  group('ParseException', () {
    test('should create with default message', () {
      const exception = ParseException();

      expect(exception.message, 'حدث خطأ في معالجة البيانات');
    });
  });

  group('TimeoutException', () {
    test('should create with default message', () {
      const exception = TimeoutException();

      expect(exception.message, 'انتهت مهلة الاتصال');
      expect(exception.duration, isNull);
    });

    test('should create with duration', () {
      const exception = TimeoutException(
        duration: Duration(seconds: 30),
      );

      expect(exception.duration, const Duration(seconds: 30));
    });
  });
}
