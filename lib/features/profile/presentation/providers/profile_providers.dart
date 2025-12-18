import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundryapp/core/networking/api_client.dart';
import 'package:laundryapp/core/providers/network_providers.dart';
import 'package:laundryapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:laundryapp/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:laundryapp/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:laundryapp/features/profile/domain/entities/user_profile.dart';
import 'package:laundryapp/features/profile/domain/repositories/profile_repository.dart';
import 'package:laundryapp/features/profile/domain/usecases/get_profile.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final token = ref.watch(
    authNotifierProvider.select((state) => state.session?.token),
  );

  return ProfileRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    token: token,
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
  );
});

final getProfileProvider = Provider<GetProfile>((ref) {
  return GetProfile(ref.watch(profileRepositoryProvider));
});

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfile>> {
  ProfileNotifier({required GetProfile getProfile})
      : _getProfile = getProfile,
        super(const AsyncValue.loading()) {
    _load();
  }

  final GetProfile _getProfile;

  Future<void> _load() async {
    state = await AsyncValue.guard(() => _getProfile());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _load();
  }

  String messageFromError(Object error) {
    if (error is ApiException) {
      return 'Permintaan gagal (${error.statusCode})';
    }
    return 'Terjadi kesalahan, coba lagi.';
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfile>>((ref) {
  return ProfileNotifier(
    getProfile: ref.watch(getProfileProvider),
  );
});
