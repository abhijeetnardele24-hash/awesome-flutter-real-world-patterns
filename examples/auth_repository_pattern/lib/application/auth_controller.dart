import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';
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

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;

  AuthState _state = const AuthState.signedOut();

  AuthState get state => _state;

  Future<void> restoreSession() async {
    _setState(_state.copyWith(status: AuthStatus.loading, errorMessage: null));

    try {
      final session = await _repository.restoreSession();

      if (session == null) {
        _setState(const AuthState.signedOut());
        return;
      }

      _setState(
        AuthState(
          status: AuthStatus.signedIn,
          session: session,
        ),
      );
    } catch (error) {
      _setState(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setState(_state.copyWith(status: AuthStatus.loading, errorMessage: null));

    try {
      final session = await _repository.signIn(
        email: email,
        password: password,
      );

      _setState(
        AuthState(
          status: AuthStatus.signedIn,
          session: session,
        ),
      );
    } catch (error) {
      _setState(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> signOut() async {
    _setState(_state.copyWith(status: AuthStatus.loading, errorMessage: null));

    await _repository.signOut();
    _setState(const AuthState.signedOut());
  }

  void clearError() {
    if (_state.status != AuthStatus.failure) {
      return;
    }

    _setState(const AuthState.signedOut());
  }

  void _setState(AuthState value) {
    _state = value;
    notifyListeners();
  }
}
