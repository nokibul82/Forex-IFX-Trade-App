part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String login;
  final String password;

  const LoginRequested({required this.login, required this.password});

  @override
  List<Object> get props => [login, password];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class SessionExpired extends AuthEvent {
  final String message;

  const SessionExpired({required this.message});

  @override
  List<Object> get props => [message];
}