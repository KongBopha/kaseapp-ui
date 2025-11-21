class PreOrderOfferResponse {
  final bool success;
  final PreOrderItem preOrder;
  final List<OfferItem> offers;

  PreOrderOfferResponse({
    required this.success,
    required this.preOrder,
    required this.offers,
  });

  factory PreOrderOfferResponse.fromJson(Map<String, dynamic> json) {
    return PreOrderOfferResponse(
      success: json['success'] ?? false,
      preOrder: PreOrderItem.fromJson(json['pre_order']),
      offers: (json['offers'] as List<dynamic>)
          .map((e) => OfferItem.fromJson(e))
          .toList(),
    );
  }
}

class PreOrderItem {
  final int id;
  final String productName;
  final String requestedQty;

  PreOrderItem({
    required this.id,
    required this.productName,
    required this.requestedQty,
  });

  factory PreOrderItem.fromJson(Map<String, dynamic> json) {
    return PreOrderItem(
      id: json['id'],
      productName: json['product_name'],
      requestedQty: json['requested_qty'],
    );
    }
}

class OfferItem {
  final int orderDetailId;
  final int farmId;
  final String farmName;
  final String farmerName;
  final String fulfilledQty;
  final String status;
  final String? note;

  OfferItem({
    required this.orderDetailId,
    required this.farmId,
    required this.farmName,
    required this.farmerName,
    required this.fulfilledQty,
    required this.status,
    this.note,
  });

  factory OfferItem.fromJson(Map<String, dynamic> json) {
    return OfferItem(
      orderDetailId: json['order_detail_id'],
      farmId: json['farm_id'],
      farmName: json['farm_name'],
      farmerName: json['farmer_name'],
      fulfilledQty: json['fulfilled_qty'],
      status: json['status'],
      note: json['note'],
    );
  }
}
