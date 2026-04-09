import '../domain/auth_session.dart';

abstract class TokenStore {
  Future<AuthSession?> read();

  Future<void> write(AuthSession session);

  Future<void> clear();
}

class InMemoryTokenStore implements TokenStore {
  AuthSession? _cachedSession;

  @override
  Future<void> clear() async {
    _cachedSession = null;
  }

  @override
  Future<AuthSession?> read() async {
    return _cachedSession;
  }

  @override
  Future<void> write(AuthSession session) async {
    _cachedSession = session;
  }
}
