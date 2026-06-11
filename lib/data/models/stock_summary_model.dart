import 'package:equatable/equatable.dart';

class MetalStockSummary extends Equatable {
  final double inStock;
  final double outStock;
  final double available;

  const MetalStockSummary({
    this.inStock = 0.0,
    this.outStock = 0.0,
    this.available = 0.0,
  });

  factory MetalStockSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MetalStockSummary();
    return MetalStockSummary(
      inStock: (json['stockIn'] ?? 0).toDouble(),
      outStock: (json['stockOut'] ?? 0).toDouble(),
      available: (json['available'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'stockIn': inStock,
        'stockOut': outStock,
        'available': available,
      };

  @override
  List<Object?> get props => [inStock, outStock, available];
}

class StockSummaryModel extends Equatable {
  final MetalStockSummary gold;

  final MetalStockSummary jewellery;

  const StockSummaryModel({
    this.gold = const MetalStockSummary(),

    this.jewellery = const MetalStockSummary(),
  });

  factory StockSummaryModel.fromJson(Map<String, dynamic> json) {
    return StockSummaryModel(
      gold: MetalStockSummary.fromJson(json['gold'] as Map<String, dynamic>?),

      jewellery: MetalStockSummary.fromJson(json['jewellery'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gold': gold.toJson(),

      'jewellery': jewellery.toJson(),
    };
  }

  @override
  List<Object?> get props => [gold, jewellery];
}
