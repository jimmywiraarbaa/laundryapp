import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundryapp/core/networking/api_client.dart';
import 'package:laundryapp/core/providers/network_providers.dart';
import 'package:laundryapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:laundryapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laundryapp/features/auth/domain/entities/auth_session.dart';
import 'package:laundryapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:laundryapp/features/auth/domain/usecases/login.dart';
import 'package:laundryapp/features/auth/domain/usecases/register.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});

final loginUseCaseProvider = Provider<Login>((ref) {
  return Login(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<Register>((ref) {
  return Register(ref.watch(authRepositoryProvider));
});

enum AuthStatus { idle, loading, authenticated, error }

class AuthState {
  const AuthState._({
    required this.status,
    this.session,
    this.errorMessage,
  });

  const AuthState.idle() : this._(status: AuthStatus.idle);

  const AuthState.loading() : this._(status: AuthStatus.loading);

  const AuthState.authenticated(AuthSession session)
      : this._(status: AuthStatus.authenticated, session: session);

  const AuthState.error(String message)
      : this._(status: AuthStatus.error, errorMessage: message);

  final AuthStatus status;
  final AuthSession? session;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required Login login,
    required Register register,
  })  : _login = login,
        _register = register,
        super(const AuthState.idle());

  final Login _login;
  final Register _register;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final session = await _login(
        email: email,
        password: password,
      );
      state = AuthState.authenticated(session);
    } catch (error) {
      state = AuthState.error(_messageFromError(error));
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final session = await _register(
        username: username,
        email: email,
        password: password,
      );
      state = AuthState.authenticated(session);
    } catch (error) {
      state = AuthState.error(_messageFromError(error));
    }
  }

  void logout() {
    state = const AuthState.idle();
  }

  String _messageFromError(Object error) {
    if (error is ApiException) {
      return 'Permintaan gagal (${error.statusCode})';
    }
    return 'Terjadi kesalahan, coba lagi.';
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    return AuthNotifier(
      login: ref.watch(loginUseCaseProvider),
      register: ref.watch(registerUseCaseProvider),
    );
  },
);
