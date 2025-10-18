import 'package:kaseapp_ui/utils/constants/base_api.dart';

class MarketSupplies {
  final int id;
  final int productId;
  final int farmId;
  final String productName;
  final String productImage;
  final String farmName;
  final double availableQty;
  final String unit;
  final DateTime availability;

  MarketSupplies({
    required this.id,
    required this.productName,
    required this.productId,
    required this.farmId,
    required this.productImage,
    required this.farmName,
    required this.availableQty,
    required this.unit,
    required this.availability,
  });

  factory MarketSupplies.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      return DateTime.tryParse(value.toString()) ?? DateTime.now();
    }
       // Helper function to convert relative product image path to full URL
    String getProductImageUrl(String? productUrl) {
      if (productUrl == null || productUrl.isEmpty) {
        return 'https://www.nicepng.com/png/detail/304-3048415_business-advice-product-icon-png.png';
      }
      if (productUrl.startsWith('http')) return productUrl;

      // Clean relative path and prepend backend URL
      final cleanPath = productUrl.replaceAll(RegExp(r'^/storage/product_images/'), '');
      return '${Constants.mainUrl}/storage/product_images/$cleanPath';
    }

    return MarketSupplies(
      id: json['id'],
      productName: json['product']?['name'] ?? '',
      productId: json['product']?['id'] ?? 0,
      farmId: json['farm']?['id'] ?? 0,
      farmName: json['farm']?['name'] ?? '',
      productImage: getProductImageUrl(json['product']?['image']),
      availableQty: (json['available_qty'] as num).toDouble(),
      unit: json['unit'] ?? '',
      availability: parseDate(json['availability']),
    );
  }
}
