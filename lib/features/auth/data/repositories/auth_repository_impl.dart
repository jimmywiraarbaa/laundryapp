import 'package:laundryapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:laundryapp/features/auth/domain/entities/auth_session.dart';
import 'package:laundryapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final session = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    return session.toEntity();
  }

  @override
  Future<AuthSession> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final session = await _remoteDataSource.register(
      username: username,
      email: email,
      password: password,
    );
    return session.toEntity();
  }
}
