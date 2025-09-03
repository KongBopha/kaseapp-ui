class ReceiveorderModel {
  final int preOrderId;
  final String vendorName;
  final String productName;
  final double quantity; 
  final String location;
  final String note;
  final String deliveryDate;  
  final String status;

  ReceiveorderModel({
    required this.preOrderId,
    required this.vendorName,
    required this.productName,
    required this.quantity,
    required this.location,
    required this.note,
    required this.deliveryDate,
    required this.status,
  });

  factory ReceiveorderModel.fromJson(Map<String, dynamic> json) {
    return ReceiveorderModel(
      preOrderId: json['pre_order_id'],
      vendorName: json['vendor_name'],
      productName: json['product_name'],
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0, 
      location: json['location'],
      note: json['note'],
      deliveryDate: json['delivery_date'],
      status: json['status'],
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
