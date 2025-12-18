import 'package:laundryapp/features/auth/domain/entities/auth_session.dart';
import 'package:laundryapp/features/auth/domain/repositories/auth_repository.dart';

class Register {
  const Register(this.repository);

  final AuthRepository repository;

  Future<AuthSession> call({
    required String username,
    required String email,
    required String password,
  }) {
    return repository.register(
      username: username,
      email: email,
      password: password,
    );
  }
}
