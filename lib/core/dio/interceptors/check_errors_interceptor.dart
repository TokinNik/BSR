import 'package:dio/dio.dart';
import 'package:bsr/core/dio/errors/dio_errors.dart';
import 'package:bsr/utils/logger.dart';

class CheckErrorsInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final exception = _parseError(err);
    if (exception != null) {
      err.error = exception;
    }

    super.onError(err, handler);
  }

  ApiErrorException _parseError(DioError err) {
    switch (err.type) {
      case DioErrorType.connectTimeout:
        logD("DioErrorType.connectTimeout: $err");
        // TODO: Handle this case.
        break;
      case DioErrorType.sendTimeout:
        logD("DioErrorType.sendTimeout: $err");
        // TODO: Handle this case.
        break;
      case DioErrorType.receiveTimeout:
        logD("DioErrorType.receiveTimeout: $err");
        // TODO: Handle this case.
        break;
      case DioErrorType.response:
        logD("DioErrorType.response: $err");
        // TODO: Handle this case.
        break;
      case DioErrorType.cancel:
        logD("DioErrorType.cancel: $err");
        // TODO: Handle this case.
        break;
      case DioErrorType.other:
        logD("DioErrorType.other: $err");
        // TODO: Handle this case.
        break;
    }
    return null;
  }
}
