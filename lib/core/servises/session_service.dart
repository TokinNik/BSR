import 'package:bsr/core/data/session.dart';
import 'package:bsr/core/data/token.dart';

abstract class SessionService {
  Future<Session> getSession();

  Future<void> setSession(Session session);

  Future<Token> refreshToken();

  Future<bool> checkToken(Token token);

  Future<void> clearSession();

  Future<void> onTokenExpired();
}
