part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class LoadAccountData extends AccountEvent {}

class RefreshAccountData extends AccountEvent {}