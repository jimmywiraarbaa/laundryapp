import 'package:laundryapp/features/profile/domain/entities/user_profile.dart';
import 'package:laundryapp/features/profile/domain/repositories/profile_repository.dart';

class GetProfile {
  const GetProfile(this.repository);

  final ProfileRepository repository;

  Future<UserProfile> call() {
    return repository.fetchProfile();
  }
}
