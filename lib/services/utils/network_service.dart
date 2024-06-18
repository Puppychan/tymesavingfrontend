import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retry/retry.dart';
import 'package:tymesavingfrontend/common/constant/local_storage_key_constant.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/local_storage_service.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";

dynamic handleError(Object e) {
  print("Caught error: $e");
  if (e is DioException) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      // Network timeout error
      return {
        'response': "Network timeout. Please try again later.",
        'statusCode': 408
      };
    } else if (e.type == DioExceptionType.connectionError) {
      // No internet connection error
      return {
        'response': "No internet connection. Please check your connection.",
        'statusCode': 503
      };
    } else if (e.type == DioExceptionType.badResponse) {
      // Handle backend error response
      return {
        'response': e.response?.data['response'] ??
            "Server error. Please try again later.",
        'statusCode': e.response?.statusCode ?? 500
      };
    } else {
      // Other types of errors
      return {
        'response':
            e.response?.data['response'] ?? "Oops. Something went wrong.",
        'statusCode': e.response?.statusCode ?? 500
      };
    }
  } else {
    return {'response': "Oops. Something went wrong.", 'statusCode': 500};
  }
}

Future<String?> getToken() async {
  // Replace this with your own logic to get the token
  return await LocalStorageService.getString(LOCAL_AUTH_TOKEN);
}

class NetworkService {
  final TIMEOUT_DURATION = const Duration(seconds: 10);
  late final Dio _dio;
  final JsonEncoder _encoder = const JsonEncoder();
  static final NetworkService _instance = NetworkService.internal();

  NetworkService.internal();

  static NetworkService get instance => _instance;

  Future<void> initClient() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: BackendEndpoints.baseUrl,
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        headers: {
          CONTENT_TYPE: APPLICATION_JSON,
          ACCEPT: APPLICATION_JSON,
        },
      ),
    );
    // Add an interceptor that adds the Authorization header
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get the token from somewhere (e.g., shared preferences)
          String? token = await getToken();

          if (token != null) {
            // Add the token to the request headers
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );
  }
    final retryCall = const RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 2),
  );

  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await retryCall.retry(
        () => _dio.get(url, queryParameters: queryParameters).timeout(TIMEOUT_DURATION),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
      );

      // final response = await _dio.get(url, queryParameters: queryParameters);
      return {
        'response': response.data?['response'],
        'statusCode': response.statusCode
      };
    } catch (error) {
      return handleError(error);
    }
  }

  Future<dynamic> download(String url, String path) async {
    try {
      final response = await retryCall.retry(
        () => _dio.download(url, path).timeout(TIMEOUT_DURATION),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
      );
      // final response = await _dio.download(url, path);
      return {
        'response': response.data?['response'],
        'statusCode': response.statusCode
      };
    } catch (error) {
      return handleError(error);
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      final response = await retryCall.retry(
        () => _dio.delete(url).timeout(TIMEOUT_DURATION),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
      );
      // final response = await _dio.delete(url);
      return {
        'response': response.data?['response'],
        'statusCode': response.statusCode
      };
    } catch (error) {
      return handleError(error);
    }
  }

  Future<dynamic> post(String url, {body, encoding}) async {
    try {
      final response = await retryCall.retry(
        () => _dio.post(url, data: _encoder.convert(body)).timeout(TIMEOUT_DURATION),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
      );
      // final response = await _dio.post(url, data: _encoder.convert(body));
      return {
        'response': response.data?['response'],
        'statusCode': response.statusCode
      };
    } catch (error) {
      return handleError(error);
    }
  }

  Future<dynamic> postFormData(String url, {required FormData data}) async {
    try {
      final response = await retryCall.retry(
        () => _dio.post(url, data: data).timeout(TIMEOUT_DURATION),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
      );
      // final response = await _dio.post(url, data: data);
      return {
        'response': response.data?['response'],
        'statusCode': response.statusCode
      };
    } catch (error) {
      return handleError(error);
    }
  }

  Future<dynamic> patch(String url, {body, encoding}) async {
    try {
      final response = await retryCall.retry(
        () => _dio.patch(url, data: _encoder.convert(body)).timeout(TIMEOUT_DURATION),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
      );
      // final response = await _dio.patch(url, data: _encoder.convert(body));
      return {
        'response': response.data?['response'],
        'statusCode': response.statusCode
      };
    } catch (error) {
      return handleError(error);
    }
  }

  Future<dynamic> put(String url, {body, encoding}) async {
    try {
      final response = await retryCall.retry(
        () => _dio.put(url, data: _encoder.convert(body)).timeout(TIMEOUT_DURATION),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
      );
      // final response = await _dio.put(url, data: _encoder.convert(body));
      return {
        'response': response.data?['response'],
        'statusCode': response.statusCode
      };
    } catch (error) {
      return handleError(error);
    }
  }
}
