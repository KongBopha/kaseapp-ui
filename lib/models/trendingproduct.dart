class TrendingProduct {
  final int productId;
  final int preOrderCount;
  final String productName;
  final String productImage;
  final String unit;

  TrendingProduct({
    required this.productId,
    required this.preOrderCount,
    required this.productName,
    required this.productImage,
    required this.unit,
  });

  factory TrendingProduct.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return TrendingProduct(
      productId: json['product_id'],
      preOrderCount: json['pre_order_count'],
      productName: product['name'] ?? '',
      productImage: product['image'] ?? '',
      unit: product['unit'] ?? '',
    );
  }
}
