import 'package:dio/dio.dart';
import 'package:bsr/core/dio/dio.dart';
import 'package:bsr/core/dio/errors/dio_errors.dart';
import 'package:bsr/core/servises/session_service.dart';

class CheckTokenInterceptor extends Interceptor {
  final SessionService sessionService;
  final Lock requestLock;

  CheckTokenInterceptor(this.sessionService, this.requestLock);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final session = await sessionService.getSession();
    var authToken = session.accessToken;

    if (authToken == null) {
      return handler.reject(_buildSessionExpiredException(options));
    }

    if (authToken.isNearExpiration()) {
      requestLock.lock();

      try {
        final newToken = await sessionService.refreshToken();

        if (newToken == null) {
          requestLock.clear();
          requestLock.unlock();
          return handler.reject(_buildSessionExpiredException(options));
        } else {
          authToken = newToken;
        }
      } catch (error) {
        requestLock.clear(error.toString());
        requestLock.unlock();
        return handler.reject(DioError(requestOptions: options, error: error));
      }

      requestLock.unlock();
    }

    //TODO: Change auth header
    options.headers['Authorization'] = 'Bearer $authToken';
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type == DioErrorType.response && err.response.isUnauthorizedError) {
      sessionService.onTokenExpired();
      return handler.next(_buildSessionExpiredException(err.requestOptions));
    }
    super.onError(err, handler);
  }

  DioError _buildSessionExpiredException(RequestOptions options) {
    return DioError(requestOptions: options, error: SessionExpiredException());
  }
}
