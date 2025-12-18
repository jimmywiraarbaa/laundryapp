import 'package:laundryapp/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:laundryapp/features/profile/domain/entities/user_profile.dart';
import 'package:laundryapp/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<UserProfile> fetchProfile() async {
    final model = await _remoteDataSource.fetchProfile();
    return model.toEntity();
  }
}
