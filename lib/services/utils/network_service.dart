import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retry/retry.dart';
import 'package:tymesavingfrontend/common/constant/local_storage_key_constant.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tymesavingfrontend/services/utils/local_storage_service.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";

bool _isNetworkError(Object e) {
  return e is DioException &&
      (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout);
}

dynamic handleError(Object e) {
  print("Caught error: $e");
  if (e is DioException) {
    if (e.type == DioExceptionType.cancel) {
      return {'response': "Request cancelled.", 'statusCode': 499};
    } else if (e.type == DioExceptionType.connectionTimeout ||
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
  final TIMEOUT_DURATION = const Duration(seconds: 30);
  late final Dio _dio;
  final JsonEncoder _encoder = const JsonEncoder();
  static final NetworkService _instance = NetworkService.internal();

  NetworkService.internal();

  static NetworkService get instance => _instance;

  Future<void> initClient() async {
    final cacheDir = await getTemporaryDirectory();
    final cacheStore =
        HiveCacheStore(cacheDir.path); // Path to store cache files

    final cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.high,
      maxStale: const Duration(days: 7),
    );

    _dio = Dio(
      BaseOptions(
        baseUrl: BackendEndpoints.baseUrl,
        connectTimeout: TIMEOUT_DURATION,
        receiveTimeout: TIMEOUT_DURATION,
        headers: {
          CONTENT_TYPE: APPLICATION_JSON,
          ACCEPT: APPLICATION_JSON,
        },
      ),
    );

    // add interceptor to cache responses
    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    // Add an interceptor that adds the Authorization header
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get the token from somewhere (e.g., shared preferences)
          // await addBearerTokenToHeader(_dio);

          // return handler.next(options);
          String? token = await getToken();
          if (token != null) {
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
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await retryCall.retry(
        () => _dio
            .get(url,
                queryParameters: queryParameters, cancelToken: cancelToken)
            .timeout(TIMEOUT_DURATION),
        retryIf: (e) => _isNetworkError(e),
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

  Future<dynamic> download(
    String url,
    String path,
    CancelToken? cancelToken,
  ) async {
    try {
      final response = await retryCall.retry(
        () => _dio
            .download(url, path, cancelToken: cancelToken)
            .timeout(TIMEOUT_DURATION),
        retryIf: (e) => _isNetworkError(e),
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
        retryIf: (e) => _isNetworkError(e),
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
        () => _dio
            .post(url, data: _encoder.convert(body))
            .timeout(TIMEOUT_DURATION),
        retryIf: (e) => _isNetworkError(e),
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
      () => _dio
          .post(url, data: data)
          .timeout(TIMEOUT_DURATION),
      retryIf: (e) => _isNetworkError(e),
    );
    return {
      'response': response.data?['response'],
      'statusCode': response.statusCode
    };
  } catch (error) {
    return handleError(error);
  }
}

  Future<dynamic> putFormData(String url, {required FormData data}) async {
    try {
      final response = await retryCall.retry(
        () => _dio.put(url, data: data).timeout(TIMEOUT_DURATION),
        retryIf: (e) => _isNetworkError(e),
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
        () => _dio
            .patch(url, data: _encoder.convert(body))
            .timeout(TIMEOUT_DURATION),
        retryIf: (e) => _isNetworkError(e),
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
        () => _dio
            .put(url, data: _encoder.convert(body))
            .timeout(TIMEOUT_DURATION),
        retryIf: (e) => _isNetworkError(e),
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
