import 'package:kaseapp_ui/models/product.dart';

class MarketTrend {
  final int id;
  final int productId;
  final double totalDemand;
  final double totalSupply;
  final String demandStatus;
  final DateTime recordedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product? product;

  MarketTrend({
    required this.id,
    required this.productId,
    required this.totalDemand,
    required this.totalSupply,
    required this.demandStatus,
    required this.recordedAt,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  factory MarketTrend.fromJson(Map<String, dynamic> json) {
    return MarketTrend(
      id: json['id'],
      productId: json['product_id'],
      totalDemand: double.parse(json['total_demand'].toString()),
      totalSupply: double.parse(json['total_supply'].toString()),
      demandStatus: json['demand_status'],
      recordedAt: DateTime.parse(json['recorded_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }
}