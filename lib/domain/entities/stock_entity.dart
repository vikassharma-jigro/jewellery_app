class StockLedgerEntity {
  final String id;
  final String type; // IN, OUT
  final String metalType; // GOLD, SILVER
  final double weight;
  final DateTime createdAt;

  const StockLedgerEntity({
    required this.id,
    required this.type,
    required this.metalType,
    required this.weight,
    required this.createdAt,
  });
}

class StockBalanceEntity {
  final double goldIn;
  final double goldOut;
  final double goldAvailable;
  
  final double silverIn;
  final double silverOut;
  final double silverAvailable;

  const StockBalanceEntity({
    required this.goldIn,
    required this.goldOut,
    required this.goldAvailable,
    required this.silverIn,
    required this.silverOut,
    required this.silverAvailable,
  });
}
