part of 'repository_imports.dart';

extension on Repository {
  dynamic onServerErrorBase(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          Object? msg;
          if (e.response?.data is Map) {
            msg = e.response?.data['error_msg'];
            msg ??= e.response?.data['message'];
          } else {
            msg = e.response?.data;
          }
          return msg ?? e.error;
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.connectionError:
          if (e.error is SocketException) {
            return 'تعذر الإتصال بالخادم، أعد المحاولة لاحقًا';
          }
          return e.message ?? e.error.toString();
        default:
          return e.toString();
      }
    }
    return e.toString();
  }

  // ignore: unused_element
  Future<Either<String, T>> responseHandling<T>({
    required Future<T> Function() onSuccess,
    Future<String> Function(Exception exception)? onOtherError,
  }) async {
    try {
      final f = await onSuccess();
      return Right(f);
    } on SocketException {
      return const Left('Please Check Your Internet Connection');
    } on Exception catch (e) {
      if (onOtherError != null) {
        final f = await onOtherError(e);
        return Left(f.toString());
      }
      final f = onServerErrorBase(e);
      return Left(f.toString());
    }
  }
}
