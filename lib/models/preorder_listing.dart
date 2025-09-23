class PreOrderListing {
  final int preOrderId;
  final String vendorName;
  final String productName;
  final double quantity;
  final String location;
  final String note;
  final String deliveryDate;
  final String status;

  PreOrderListing({
    required this.preOrderId,
    required this.vendorName,
    required this.productName,
    required this.quantity,
    required this.location,
    required this.note,
    required this.deliveryDate,
    required this.status,
  });

  factory PreOrderListing.fromJson(Map<String, dynamic> json) {
    return PreOrderListing(
      preOrderId: (json['pre_order_id'] as num?)?.toInt() ?? 0,
      vendorName: json['vendor_name'] ?? 'Unknown Vendor',
      productName: json['product_name'] ?? 'Unknown Product',
      quantity: double.tryParse(json['quantity']?.toString() ?? '0') ?? 0.0,
      location: json['location'] ?? 'Unknown Location',
      note: json['note'] ?? 'No notes',
      deliveryDate: json['delivery_date'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pre_order_id': preOrderId,
      'vendor_name': vendorName,
      'product_name': productName,
      'quantity': quantity,
      'location': location,
      'note': note,
      'delivery_date': deliveryDate,
      'status': status,
    };
  }
}
