import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import '../../../core/exceptions/app_exceptions.dart';
import '../../../data/models/account_models.dart';
import '../../../data/models/trade_models.dart';
import '../../../data/repositories/account_repository.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _accountRepository;
  final String login;
  final String token;

  AccountBloc({
    required AccountRepository accountRepository,
    required this.login,
    required this.token,
  })  : _accountRepository = accountRepository,
        super(AccountInitial()) {
    on<LoadAccountData>(_onLoadAccountData);
    on<RefreshAccountData>(_onRefreshAccountData);
  }

  Future<void> _onLoadAccountData(
      LoadAccountData event,
      Emitter<AccountState> emit,
      ) async {
    emit(AccountLoading());
    try {
      final accountInfo = await _accountRepository.getAccountInformation(
        login,
        token,
      );
      final phoneNumbers = await _accountRepository.getLastFourPhoneNumbers(
        login,
        token,
      );
      final trades = await _accountRepository.getOpenTrades(login, token);

      final totalProfit = trades.fold(
        0.0,
            (sum, trade) => sum + trade.profit,
      );

      emit(AccountLoaded(
        accountInformation: accountInfo,
        lastFourPhoneNumbers: phoneNumbers,
        trades: trades,
        totalProfit: totalProfit,
      ));
    } on AuthException catch (e) {
      emit(AccountSessionExpired(e.message));
    } on ServerException catch (e) {
      emit(AccountError(e.message));
    } on NetworkException catch (e) {
      emit(AccountError('Network error: ${e.message}'));
    } catch (e) {
      emit(AccountError('An unexpected error occurred'));
    }
  }

  Future<void> _onRefreshAccountData(
      RefreshAccountData event,
      Emitter<AccountState> emit,
      ) async {
    if (state is AccountLoaded) {
      emit((state as AccountLoaded).copyWith(isRefreshing: true));
    }

    try {
      final trades = await _accountRepository.getOpenTrades(login, token);
      final accountInfo = await _accountRepository.getAccountInformation(
        login,
        token,
      );
      final phoneNumbers = await _accountRepository.getLastFourPhoneNumbers(
        login,
        token,
      );

      final totalProfit = trades.fold(
        0.0,
            (sum, trade) => sum + trade.profit,
      );

      emit(AccountLoaded(
        accountInformation: accountInfo,
        lastFourPhoneNumbers: phoneNumbers,
        trades: trades,
        totalProfit: totalProfit,
      ));
    } on AuthException catch (e) {
      emit(AccountSessionExpired(e.message));
    } on ServerException catch (e) {
      emit(AccountError(e.message));
    } on NetworkException catch (e) {
      emit(AccountError('Network error: ${e.message}'));
    } catch (e) {
      emit(AccountError('An unexpected error occurred'));
    }
  }
}