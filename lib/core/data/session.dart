import 'package:bsr/core/data/token.dart';

class Session {
  Token accessToken;
  Token refreshToken;

  Session({
    this.accessToken,
    this.refreshToken,
  });

  Session copyWith({
    Token accessToken,
    Token refreshToken,
  }) {
    return new Session(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  String toString() {
    return 'Session{accessToken: $accessToken, refreshToken: $refreshToken}';
  }

  //TODO: Change map names if need
  factory Session.fromJson(Map<String, dynamic> json) => Session(
        accessToken: Token.fromMap(json["accessToken"]),
        refreshToken: Token.fromMap(json["refreshToken"]),
      );

  //TODO: Change map names if need
  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}
