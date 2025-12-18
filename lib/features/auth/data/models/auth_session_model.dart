import 'package:laundryapp/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel {
  const AuthSessionModel({
    this.token,
    this.email,
    this.username,
  });

  final String? token;
  final String? email;
  final String? username;

  AuthSession toEntity() {
    return AuthSession(
      token: token,
      email: email,
      username: username,
    );
  }

  factory AuthSessionModel.fromResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      return AuthSessionModel.fromJson(response);
    }
    if (response is Map) {
      return AuthSessionModel.fromJson(Map<String, dynamic>.from(response));
    }
    return const AuthSessionModel();
  }

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final data = _mapFromJson(json['data']);
    final user = _mapFromJson(data?['user']) ?? _mapFromJson(json['user']);

    final token = _stringFromJson(data ?? json, ['token', 'access_token']) ??
        _stringFromJson(json, ['token', 'access_token']);
    final email = _stringFromJson(user ?? json, ['email']);
    final username = _stringFromJson(user ?? json, ['username', 'name']);

    return AuthSessionModel(
      token: token,
      email: email,
      username: username,
    );
  }

  static Map<String, dynamic>? _mapFromJson(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static String? _stringFromJson(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
      if (value != null) {
        return value.toString();
      }
    }
    return null;
  }
}
