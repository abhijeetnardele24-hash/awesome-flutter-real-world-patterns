class AuthSession {
  const AuthSession({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  final String userId;
  final String accessToken;
  final String refreshToken;
}
