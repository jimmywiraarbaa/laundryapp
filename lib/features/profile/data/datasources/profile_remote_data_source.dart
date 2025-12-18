import 'package:laundryapp/core/config/app_config.dart';
import 'package:laundryapp/core/networking/api_client.dart';
import 'package:laundryapp/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> fetchProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({
    required ApiClient apiClient,
    String? token,
  })  : _apiClient = apiClient,
        _token = token;

  final ApiClient _apiClient;
  final String? _token;

  @override
  Future<UserProfileModel> fetchProfile() async {
    final response = await _apiClient.getJson(
      AppConfig.profilePath,
      headers: _token == null ? null : {'Authorization': 'Bearer $_token'},
    );
    return UserProfileModel.fromResponse(response);
  }
}
