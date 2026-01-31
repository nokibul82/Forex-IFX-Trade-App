class Trade {
  final double currentPrice;
  final String? comment;
  final int digits;
  final int login;
  final double openPrice;
  final DateTime openTime;
  final double profit;
  final double sl;
  final double swaps;
  final String symbol;
  final double tp;
  final int ticket;
  final int type;
  final double volume;

  Trade({
    required this.currentPrice,
    this.comment,
    required this.digits,
    required this.login,
    required this.openPrice,
    required this.openTime,
    required this.profit,
    required this.sl,
    required this.swaps,
    required this.symbol,
    required this.tp,
    required this.ticket,
    required this.type,
    required this.volume,
  });

  factory Trade.fromJson(Map<String, dynamic> json) => Trade(
    currentPrice: (json['currentPrice'] as num).toDouble(),
    comment: json['comment'],
    digits: json['digits'] ?? 0,
    login: json['login'] ?? 0,
    openPrice: (json['openPrice'] as num).toDouble(),
    openTime: DateTime.parse(json['openTime']),
    profit: (json['profit'] as num).toDouble(),
    sl: (json['sl'] as num).toDouble(),
    swaps: (json['swaps'] as num).toDouble(),
    symbol: json['symbol'] ?? '',
    tp: (json['tp'] as num).toDouble(),
    ticket: json['ticket'] ?? 0,
    type: json['type'] ?? 0,
    volume: (json['volume'] as num).toDouble(),
  );
}

class TradeRequest {
  final String login;
  final String token;

  TradeRequest({required this.login, required this.token});

  Map<String, dynamic> toJson() => {
    'login': login,
    'token': token,
  };
}