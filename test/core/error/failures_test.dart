import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/core/error/failures.dart';

void main() {
  group('ServerFailure', () {
    test('should create with default message', () {
      const failure = ServerFailure();

      expect(failure.message, 'حدث خطأ في الخادم');
      expect(failure.statusCode, isNull);
    });

    test('should create with custom message and status code', () {
      const failure = ServerFailure(
        message: 'Custom error',
        statusCode: 500,
      );

      expect(failure.message, 'Custom error');
      expect(failure.statusCode, 500);
    });

    test('props should include message and statusCode', () {
      const failure = ServerFailure(message: 'Test', statusCode: 404);

      expect(failure.props, ['Test', 404]);
    });

    test('two failures with same props should be equal', () {
      const failure1 = ServerFailure(message: 'Error', statusCode: 500);
      const failure2 = ServerFailure(message: 'Error', statusCode: 500);

      expect(failure1, equals(failure2));
    });
  });

  group('NetworkFailure', () {
    test('should create with default message', () {
      const failure = NetworkFailure();

      expect(failure.message, 'لا يوجد اتصال بالإنترنت');
    });

    test('should create with custom message', () {
      const failure = NetworkFailure(message: 'No connection');

      expect(failure.message, 'No connection');
    });
  });

  group('CacheFailure', () {
    test('should create with default message', () {
      const failure = CacheFailure();

      expect(failure.message, 'حدث خطأ في التخزين المحلي');
    });
  });

  group('LocationFailure', () {
    test('should create with required message', () {
      const failure = LocationFailure(message: 'Location error');

      expect(failure.message, 'Location error');
      expect(failure.type, LocationFailureType.unknown);
    });

    test('should create with type', () {
      const failure = LocationFailure(
        message: 'Permission denied',
        type: LocationFailureType.permissionDenied,
      );

      expect(failure.type, LocationFailureType.permissionDenied);
    });

    test('props should include message and type', () {
      const failure = LocationFailure(
        message: 'Test',
        type: LocationFailureType.serviceDisabled,
      );

      expect(failure.props, ['Test', LocationFailureType.serviceDisabled]);
    });
  });

  group('ParseFailure', () {
    test('should create with default message', () {
      const failure = ParseFailure();

      expect(failure.message, 'حدث خطأ في معالجة البيانات');
    });
  });

  group('TimeoutFailure', () {
    test('should create with default message', () {
      const failure = TimeoutFailure();

      expect(failure.message, 'انتهت مهلة الاتصال');
    });
  });

  group('UnknownFailure', () {
    test('should create with default message', () {
      const failure = UnknownFailure();

      expect(failure.message, 'حدث خطأ غير متوقع');
    });
  });

  group('Failure equality', () {
    test('different failure types should not be equal', () {
      const serverFailure = ServerFailure();
      const networkFailure = NetworkFailure();

      expect(serverFailure, isNot(equals(networkFailure)));
    });

    test('same failure type with same message should be equal', () {
      const failure1 = NetworkFailure(message: 'Test');
      const failure2 = NetworkFailure(message: 'Test');

      expect(failure1, equals(failure2));
    });

    test('same failure type with different message should not be equal', () {
      const failure1 = NetworkFailure(message: 'Test1');
      const failure2 = NetworkFailure(message: 'Test2');

      expect(failure1, isNot(equals(failure2)));
    });
  });
}
