import 'package:kaseapp_ui/models/product.dart';

class TrendingProduct {
  final Product product;
  final double demandKg;
  final double supplyKg;
  final String demandStatus;

  TrendingProduct({
    required this.product,
    required this.demandKg,
    required this.supplyKg,
    required this.demandStatus,
  });
}