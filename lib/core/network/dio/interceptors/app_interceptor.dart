import 'dart:async';

import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  AppInterceptors(
    this.onRequestHeader,
    this.onResponseCallback,
    this.onErrorCallback,
  );

  final Future<Map<String, dynamic>> Function()? onRequestHeader;
  final Future<void> Function(Response)? onResponseCallback;
  final Future<void> Function(DioException)? onErrorCallback;

  @override
  FutureOr<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (onRequestHeader != null) {
      final header = await onRequestHeader!.call();
      options.headers.addAll(header);
    }
    return handler.next(options);
  }

  @override
  FutureOr<dynamic> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    await onResponseCallback?.call(response);
    return handler.resolve(response);
  }

  @override
  FutureOr<dynamic> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    await onErrorCallback?.call(err);
    return handler.next(err);
  }
}
