import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/exceptions.dart';

/// Singleton API Client with proper error handling
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _RetryInterceptor(_dio),
    ]);
  }

  /// Get singleton instance
  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  /// GET request with error handling
  Future<T> get<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );

      if (parser != null) {
        return parser(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// POST request with error handling
  Future<T> post<T>({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
      );

      if (parser != null) {
        return parser(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Handle Dio exceptions and convert to app exceptions
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = _getErrorMessage(e.response?.data);
        return ServerException(
          message: message,
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return const ServerException(message: 'تم إلغاء الطلب');

      default:
        return ServerException(message: e.message ?? 'حدث خطأ غير متوقع');
    }
  }

  /// Extract error message from response
  String _getErrorMessage(dynamic data) {
    if (data == null) return 'حدث خطأ في الخادم';

    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? 'حدث خطأ في الخادم';
    }

    return 'حدث خطأ في الخادم';
  }
}

/// Logging interceptor for debugging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('🌐 REQUEST[${options.method}] => ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.uri}');
      print('   Message: ${err.message}');
    }
    handler.next(err);
  }
}

/// Retry interceptor for failed requests
class _RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int _maxRetries;
  final Duration _retryDelay;

  _RetryInterceptor(
    this._dio, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
  })  : _maxRetries = maxRetries,
        _retryDelay = retryDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    // Only retry on connection errors and timeouts
    final shouldRetry = _shouldRetry(err) && retryCount < _maxRetries;

    if (shouldRetry) {
      if (kDebugMode) {
        print('🔄 Retrying request (${retryCount + 1}/$_maxRetries)...');
      }

      await Future.delayed(_retryDelay * (retryCount + 1));

      final options = err.requestOptions;
      options.extra['retryCount'] = retryCount + 1;

      try {
        final response = await _dio.fetch(options);
        handler.resolve(response);
        return;
      } on DioException catch (e) {
        handler.next(e);
        return;
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
