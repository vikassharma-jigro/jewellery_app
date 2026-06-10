import '../../domain/entities/stock_entity.dart';

class StockLedgerDto {
  final String id;
  final String type;
  final String metalType;
  final double weight;
  final DateTime createdAt;

  StockLedgerDto({
    required this.id,
    required this.type,
    required this.metalType,
    required this.weight,
    required this.createdAt,
  });

  factory StockLedgerDto.fromJson(Map<String, dynamic> json) {
    return StockLedgerDto(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? 'IN',
      metalType: json['metalType'] ?? 'GOLD',
      weight: (json['weight'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  StockLedgerEntity toEntity() {
    return StockLedgerEntity(
      id: id,
      type: type,
      metalType: metalType,
      weight: weight,
      createdAt: createdAt,
    );
  }
}

class StockBalanceDto {
  final double goldIn;
  final double goldOut;
  final double goldAvailable;
  final double silverIn;
  final double silverOut;
  final double silverAvailable;

  StockBalanceDto({
    required this.goldIn,
    required this.goldOut,
    required this.goldAvailable,
    required this.silverIn,
    required this.silverOut,
    required this.silverAvailable,
  });

  factory StockBalanceDto.fromJson(Map<String, dynamic> json) {
    final gold = json['GOLD'] ?? {};
    final silver = json['SILVER'] ?? {};
    
    return StockBalanceDto(
      goldIn: (gold['IN'] ?? 0).toDouble(),
      goldOut: (gold['OUT'] ?? 0).toDouble(),
      goldAvailable: (gold['AVAILABLE'] ?? 0).toDouble(),
      silverIn: (silver['IN'] ?? 0).toDouble(),
      silverOut: (silver['OUT'] ?? 0).toDouble(),
      silverAvailable: (silver['AVAILABLE'] ?? 0).toDouble(),
    );
  }

  StockBalanceEntity toEntity() {
    return StockBalanceEntity(
      goldIn: goldIn,
      goldOut: goldOut,
      goldAvailable: goldAvailable,
      silverIn: silverIn,
      silverOut: silverOut,
      silverAvailable: silverAvailable,
    );
  }
}
