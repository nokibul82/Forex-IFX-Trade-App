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
  final bool isRefreshing;

  const AccountLoaded({
    required this.accountInformation,
    required this.lastFourPhoneNumbers,
    required this.trades,
    required this.totalProfit,
    this.isRefreshing = false,
  });

  AccountLoaded copyWith({
    AccountInformation? accountInformation,
    String? lastFourPhoneNumbers,
    List<Trade>? trades,
    double? totalProfit,
    bool? isRefreshing,
  }) {
    return AccountLoaded(
      accountInformation: accountInformation ?? this.accountInformation,
      lastFourPhoneNumbers: lastFourPhoneNumbers ?? this.lastFourPhoneNumbers,
      trades: trades ?? this.trades,
      totalProfit: totalProfit ?? this.totalProfit,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object> get props => [
    accountInformation,
    lastFourPhoneNumbers,
    trades,
    totalProfit,
    isRefreshing,
  ];
}

class AccountError extends AccountState {
  final String error;

  const AccountError(this.error);

  @override
  List<Object> get props => [error];
}

class AccountSessionExpired extends AccountState {
  final String message;

  const AccountSessionExpired(this.message);

  @override
  List<Object> get props => [message];
}