import 'package:laundryapp/core/config/app_config.dart';
import 'package:laundryapp/core/networking/api_client.dart';
import 'package:laundryapp/features/auth/data/models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  });

  Future<AuthSessionModel> register({
    required String username,
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.postJson(
      AppConfig.loginPath,
      body: {
        'email': email,
        'password': password,
      },
    );
    return AuthSessionModel.fromResponse(response);
  }

  @override
  Future<AuthSessionModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.postJson(
      AppConfig.registerPath,
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );
    return AuthSessionModel.fromResponse(response);
  }
}
