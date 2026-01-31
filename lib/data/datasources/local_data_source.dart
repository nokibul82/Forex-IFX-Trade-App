import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();

  Future<void> saveLogin(String login);
  Future<String?> getLogin();
  Future<void> clearLogin();
}

class LocalDataSourceImpl implements LocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _loginKey = 'user_login';

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  @override
  Future<void> saveLogin(String login) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loginKey, login);
  }

  @override
  Future<String?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loginKey);
  }

  @override
  Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
  }
}