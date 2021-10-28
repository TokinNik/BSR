import 'package:dio/dio.dart';
import 'package:bsr/constants/environment.dart';
import 'package:bsr/core/servises/session_service.dart';
import 'package:bsr/utils/logger.dart';

import 'interceptors/check_errors_interceptor.dart';
import 'interceptors/check_token_interceptor.dart';

export 'package:dio/dio.dart' show Dio;

class DioFactory {
  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: Environment.baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 10000,
    sendTimeout: 10000,
  );

  static Dio buildMainClient(SessionService sessionService) {
    final dio = Dio(_defaultOptions);

    dio.interceptors.add(
      CheckTokenInterceptor(
        sessionService,
        dio.interceptors.requestLock,
      ),
    );

    if (Environment.isApiLoggingEnabled) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          logPrint: logV,
        ),
      );
    }

    dio.interceptors.add(CheckErrorsInterceptor());

    return dio;
  }

  static Dio buildAuthClient() {
    final dio = Dio(_defaultOptions);

    if (Environment.isApiLoggingEnabled) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          logPrint: logV,
        ),
      );
    }

    dio.interceptors.add(CheckErrorsInterceptor());

    return dio;
  }
}

extension ResponseErrors on Response {
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  bool get isBadRequestError => statusCode == 400;

  bool get isUnauthorizedError => statusCode == 401;

  bool get isNotFoundError => statusCode == 404;

  bool get isServerError => statusCode >= 500 && statusCode < 600;
}
