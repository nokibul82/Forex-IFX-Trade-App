

import '../datasources/remote_data_source.dart';
import '../models/account_models.dart';
import '../models/trade_models.dart';
import 'account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final RemoteDataSource _remoteDataSource;

  AccountRepositoryImpl(this._remoteDataSource);

  @override
  Future<AccountInformation> getAccountInformation(
      String login, String token) async {
    final request = AccountInfoRequest(login: login, token: token);
    return await _remoteDataSource.getAccountInformation(request);
  }

  @override
  Future<String> getLastFourPhoneNumbers(String login, String token) async {
    final request = AccountInfoRequest(login: login, token: token);
    return await _remoteDataSource.getLastFourPhoneNumbers(request);
  }

  @override
  Future<List<Trade>> getOpenTrades(String login, String token) async {
    final request = TradeRequest(login: login, token: token);
    return await _remoteDataSource.getOpenTrades(request);
  }
}