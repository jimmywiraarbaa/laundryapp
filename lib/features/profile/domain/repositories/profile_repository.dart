import 'package:laundryapp/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> fetchProfile();
}
