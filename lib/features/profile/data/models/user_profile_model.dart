import 'package:laundryapp/features/profile/domain/entities/user_profile.dart';

class UserProfileModel {
  const UserProfileModel({
    required this.username,
    required this.email,
    this.phone,
    this.avatarUrl,
  });

  final String username;
  final String email;
  final String? phone;
  final String? avatarUrl;

  UserProfile toEntity() {
    return UserProfile(
      username: username,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }

  factory UserProfileModel.fromResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      return UserProfileModel.fromJson(response);
    }
    if (response is Map) {
      return UserProfileModel.fromJson(Map<String, dynamic>.from(response));
    }
    return const UserProfileModel(
      username: '',
      email: '',
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final data = _mapFromJson(json['data']) ?? json;

    return UserProfileModel(
      username: _stringFromJson(
        data,
        ['username', 'name', 'full_name'],
        fallback: '',
      ),
      email: _stringFromJson(data, ['email'], fallback: ''),
      phone: _stringFromJson(data, ['phone', 'phone_number']),
      avatarUrl: _stringFromJson(data, ['avatar', 'avatar_url', 'photo']),
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

  static String _stringFromJson(
    Map<String, dynamic> json,
    List<String> keys, {
    String? fallback,
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
      if (value != null) {
        return value.toString();
      }
    }
    return fallback ?? '';
  }
}
