class PreOrderListItem {
  final int id;
  final String productName;
  final String productImage;
  final String quantity;
  final String deliveryDate;
  final String status;
  final String note;

  PreOrderListItem({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.deliveryDate,
    required this.status,
    required this.note,
  });

  factory PreOrderListItem.fromJson(Map<String, dynamic> json) {
    return PreOrderListItem(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? "Unknown Product",
      productImage: json['product_image'] ?? "",
      quantity: json['quantity'] ?? "0",
      deliveryDate: json['delivery_date'] ?? "",
      status: json['status'] ?? "Pending",
      note: json['note'] ?? "No notes",
    );
  }
}
