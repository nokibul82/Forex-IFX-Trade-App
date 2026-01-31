import '../models/auth_models.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String login, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getSavedLogin();
  Future<String?> getToken();
}