import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dio_helper.dart';
import 'interceptors/app_interceptor.dart';

typedef RequestCallback = Future<Map<String, dynamic>> Function();
typedef ResponseCallback = Future<void> Function(Response);
typedef ErrorCallback = Future<void> Function(DioException);

class DioImpl extends DioHelper {
  final RequestCallback? onRequest;
  final ResponseCallback? onResponse;
  final ErrorCallback? onError;
  // final String userAgent;

  final String baseURL;
  late Dio _dio;

  DioImpl({
    // required this.userAgent,
    required this.baseURL,
    this.onResponse,
    this.onRequest,
    this.onError,
  }) {
    _dio = Dio()
      ..interceptors.addAll(
        [
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 120,
          ),
          AppInterceptors(onRequest, onResponse, onError),
        ],
      )
      ..options.baseUrl = baseURL
      ..options.headers.addAll({
        'Accept': 'application/json',
        if (dotenv.env['TENANT_DOMAIN'] != null) 'X-Tenant-Domain': dotenv.env['TENANT_DOMAIN']!,
        if (dotenv.env['TENANT_SLUG'] != null) 'X-Tenant-Slug': dotenv.env['TENANT_SLUG']!,
      });
  }

  @override
  Future<Response<T>> get<T>(String url, {Map<String, dynamic>? queryParams}) {
    return _dio.get(url, queryParameters: queryParams);
  }

  @override
  Future<Response<T>> post<T>(String url, {dynamic data, Map<String, dynamic>? queryParams}) {
    return _dio.post(url, data: data, queryParameters: queryParams);
  }

  @override
  Future<Response<T>> put<T>(String url, {dynamic data, Map<String, dynamic>? queryParams}) {
    return _dio.put(url, data: data, queryParameters: queryParams);
  }

  @override
  Future<Response<T>> delete<T>(String url, {dynamic data, Map<String, dynamic>? queryParams}) {
    return _dio.delete(url, data: data, queryParameters: queryParams);
  }
}
