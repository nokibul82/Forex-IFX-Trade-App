part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final AccountInformation accountInformation;
  final String lastFourPhoneNumbers;
  final List<Trade> trades;
  final double totalProfit;

  const AccountLoaded({
    required this.accountInformation,
    required this.lastFourPhoneNumbers,
    required this.trades,
    required this.totalProfit,
  });

  @override
  List<Object> get props => [
    accountInformation,
    lastFourPhoneNumbers,
    trades,
    totalProfit,
  ];
}

class AccountError extends AccountState {
  final String error;

  const AccountError(this.error);

  @override
  List<Object> get props => [error];
}