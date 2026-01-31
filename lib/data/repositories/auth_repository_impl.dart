import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/auth_models.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  AuthRepositoryImpl(
      this._remoteDataSource,
      this._localDataSource,
      );

  @override
  Future<LoginResponse> login(String login, String password) async {
    final request = LoginRequest(login: login, password: password);
    final response = await _remoteDataSource.login(request);

    if (response.result) {
      await _localDataSource.saveToken(response.token);
      await _localDataSource.saveLogin(login);
    }

    return response;
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearToken();
    await _localDataSource.clearLogin();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> getSavedLogin() async {
    return await _localDataSource.getLogin();
  }

  @override
  Future<String?> getToken() async {
    return await _localDataSource.getToken();
  }
}