import 'package:dio/dio.dart';
import 'package:elhanbly/core/network/dio/dio_helper.dart';

class FakeDioHelper implements DioHelper {
  final List<FakeDioRequest> requests = [];
  final Map<String, Object?> responses = {};
  final Map<String, Object> errors = {};

  void stubResponse(String method, String url, Object? data) {
    responses[_key(method, url)] = data;
  }

  void stubError(String method, String url, Object error) {
    errors[_key(method, url)] = error;
  }

  @override
  Future<Response<T>> get<T>(String url, {Map<String, dynamic>? queryParams}) {
    return _request<T>('GET', url, queryParams: queryParams);
  }

  @override
  Future<Response<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) {
    return _request<T>('POST', url, data: data, queryParams: queryParams);
  }

  @override
  Future<Response<T>> put<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) {
    return _request<T>('PUT', url, data: data, queryParams: queryParams);
  }

  @override
  Future<Response<T>> delete<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) {
    return _request<T>('DELETE', url, data: data, queryParams: queryParams);
  }

  Future<Response<T>> _request<T>(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    requests.add(
      FakeDioRequest(
        method: method,
        url: url,
        data: data,
        queryParams: queryParams,
      ),
    );

    final key = _key(method, url);
    final error = errors[key];
    if (error != null) {
      if (error is Exception) throw error;
      throw Exception(error.toString());
    }

    return Response<T>(
      data: responses[key] as T?,
      requestOptions: RequestOptions(path: url),
      statusCode: 200,
    );
  }

  String _key(String method, String url) => '$method $url';
}

class FakeDioRequest {
  const FakeDioRequest({
    required this.method,
    required this.url,
    this.data,
    this.queryParams,
  });

  final String method;
  final String url;
  final dynamic data;
  final Map<String, dynamic>? queryParams;
}
