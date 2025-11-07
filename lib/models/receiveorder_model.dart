class ReceiveorderModel {
  final int preOrderId;
  final int orderDetailId;
  final String vendorName;
  final String productName;
  final String productImage;
  final double requestedQty;
  final double fulfilledQty;
  final String location;
  final String note;
  final String deliveryDate;
  late final String offerStatus;

  ReceiveorderModel({
    required this.preOrderId,
    required this.orderDetailId,
    required this.vendorName,
    required this.productName,
    required this.productImage,
    required this.requestedQty,
    required this.fulfilledQty,
    required this.location,
    required this.note,
    required this.deliveryDate,
    required this.offerStatus,
  });

  factory ReceiveorderModel.fromJson(Map<String, dynamic> json) {
    return ReceiveorderModel(
      preOrderId: (json['pre_order_id'] as num?)?.toInt() ?? 0,
      orderDetailId: (json['order_detail_id'] as num?)?.toInt() ?? 0,
      vendorName: json['vendorName'] ?? 'Unknown Vendor',
      productName: json['product_name'] ?? 'Unknown Product',
      requestedQty: double.tryParse(json['requested_qty']?.toString() ?? '0') ?? 0.0,
      fulfilledQty: double.tryParse(json['fulfilled_qty']?.toString() ?? '0') ?? 0.0,
      location: json['location'] ?? 'Unknown Location',
      note: json['note'] ?? 'No notes',
      deliveryDate: json['delivery_date'] ?? '',
      offerStatus: json['offer_status'] ?? 'pending',
      productImage: json['product_image'] ?? 'Unknown Image',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pre_order_id': preOrderId,
      'order_detail_id': orderDetailId,
      'vendorName': vendorName,
      'product_name': productName,
      'product_image': productImage,
      'requested_qty': requestedQty,
      'fulfilled_qty': fulfilledQty,
      'location': location,
      'note': note,
      'delivery_date': deliveryDate,
      'offer_status': offerStatus,
    };
  }
    ReceiveorderModel copyWith({
    int? preOrderId,
    int? orderDetailId,
    String? vendorName,
    String? productName,
    String? productImage,
    double? requestedQty,
    double? fulfilledQty,
    String? location,
    String? note,
    String? deliveryDate,
    String? offerStatus,
  }) {
    return ReceiveorderModel(
      preOrderId: preOrderId ?? this.preOrderId,
      orderDetailId: orderDetailId ?? this.orderDetailId,
      vendorName: vendorName ?? this.vendorName,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      requestedQty: requestedQty ?? this.requestedQty,
      fulfilledQty: fulfilledQty ?? this.fulfilledQty,
      location: location ?? this.location,
      note: note ?? this.note,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      offerStatus: offerStatus ?? this.offerStatus,
    );
  }
}
