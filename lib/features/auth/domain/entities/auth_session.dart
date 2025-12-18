class AuthSession {
  const AuthSession({
    this.token,
    this.email,
    this.username,
  });

  final String? token;
  final String? email;
  final String? username;
}
