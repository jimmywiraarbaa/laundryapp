class UserProfile {
  const UserProfile({
    required this.username,
    required this.email,
    this.phone,
    this.avatarUrl,
  });

  final String username;
  final String email;
  final String? phone;
  final String? avatarUrl;
}
