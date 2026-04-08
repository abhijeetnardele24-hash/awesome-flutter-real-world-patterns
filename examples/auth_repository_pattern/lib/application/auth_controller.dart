import '../domain/auth_session.dart';

enum AuthStatus {
  signedOut,
  loading,
  signedIn,
  failure,
}

class AuthState {
  const AuthState({
    required this.status,
    this.session,
    this.errorMessage,
  });

  const AuthState.signedOut()
      : status = AuthStatus.signedOut,
        session = null,
        errorMessage = null;

  final AuthStatus status;
  final AuthSession? session;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
