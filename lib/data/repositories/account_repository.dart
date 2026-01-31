import '../models/account_models.dart';
import '../models/trade_models.dart';

abstract class AccountRepository {
  Future<AccountInformation> getAccountInformation(
      String login, String token);
  Future<String> getLastFourPhoneNumbers(String login, String token);
  Future<List<Trade>> getOpenTrades(String login, String token);
}