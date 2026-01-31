class LoginRequest {
  final String login;
  final String password;

  LoginRequest({required this.login, required this.password});

  Map<String, dynamic> toJson() => {
    'login': _parseLogin(login),
    'password': password,
  };

  // Try to parse login as integer, fall back to string if it fails
  dynamic _parseLogin(String login) {
    try {
      return int.parse(login);
    } catch (e) {
      return login;
    }
  }
}

class LoginResponse {
  final bool result;
  final String token;

  LoginResponse({required this.result, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    result: json['result'] ?? false,
    token: json['token'] ?? '',
  );
}