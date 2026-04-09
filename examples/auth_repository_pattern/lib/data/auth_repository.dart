import '../domain/auth_session.dart';
import 'token_store.dart';

abstract class AuthRepository {
  Future<AuthSession?> restoreSession();

  Future<AuthSession> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this._tokenStore);

  final TokenStore _tokenStore;

  @override
  Future<AuthSession?> restoreSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _tokenStore.read();
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Email and password are required.');
    }

    if (!email.contains('@')) {
      throw Exception('Enter a valid email address.');
    }

    final session = AuthSession(
      userId: 'user_01',
      accessToken: 'access-token-demo',
      refreshToken: 'refresh-token-demo',
    );

    await _tokenStore.write(session);
    return session;
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _tokenStore.clear();
  }
}
