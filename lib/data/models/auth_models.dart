class LoginRequest {
  final String login;
  final String password;

  LoginRequest({required this.login, required this.password});

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
  };
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