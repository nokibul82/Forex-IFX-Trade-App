class AccountInfoRequest {
  final String login;
  final String token;

  AccountInfoRequest({required this.login, required this.token});

  Map<String, dynamic> toJson() => {
    'login': login,
    'token': token,
  };
}

class AccountInformation {
  final String address;
  final double balance;
  final String city;
  final String country;
  final int currency;
  final int currentTradesCount;
  final double currentTradesVolume;
  final double equity;
  final double freeMargin;
  final bool isAnyOpenTrades;
  final bool isSwapFree;
  final int leverage;
  final String name;
  final String phone;
  final int totalTradesCount;
  final double totalTradesVolume;
  final int type;
  final int verificationLevel;
  final String zipCode;

  AccountInformation({
    required this.address,
    required this.balance,
    required this.city,
    required this.country,
    required this.currency,
    required this.currentTradesCount,
    required this.currentTradesVolume,
    required this.equity,
    required this.freeMargin,
    required this.isAnyOpenTrades,
    required this.isSwapFree,
    required this.leverage,
    required this.name,
    required this.phone,
    required this.totalTradesCount,
    required this.totalTradesVolume,
    required this.type,
    required this.verificationLevel,
    required this.zipCode,
  });

  factory AccountInformation.fromJson(Map<String, dynamic> json) =>
      AccountInformation(
        address: json['address'] ?? '',
        balance: (json['balance'] as num).toDouble(),
        city: json['city'] ?? '',
        country: json['country'] ?? '',
        currency: json['currency'] ?? 0,
        currentTradesCount: json['currentTradesCount'] ?? 0,
        currentTradesVolume: (json['currentTradesVolume'] as num).toDouble(),
        equity: (json['equity'] as num).toDouble(),
        freeMargin: (json['freeMargin'] as num).toDouble(),
        isAnyOpenTrades: json['isAnyOpenTrades'] ?? false,
        isSwapFree: json['isSwapFree'] ?? false,
        leverage: json['leverage'] ?? 0,
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        totalTradesCount: json['totalTradesCount'] ?? 0,
        totalTradesVolume: (json['totalTradesVolume'] as num).toDouble(),
        type: json['type'] ?? 0,
        verificationLevel: json['verificationLevel'] ?? 0,
        zipCode: json['zipCode'] ?? '',
      );
}