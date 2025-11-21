import 'package:kaseapp_ui/models/product.dart';
import 'package:kaseapp_ui/utils/pre_order_enum.dart';

class PreOrder {
  final int? id;
  final int userId;
  final int? cropId;
  final int productId;
  final double qty;
  final String location;
  final String? noteText;
  final DateTime deliveryDate;
  final String? recurringSchedule;
  final PreOrderStatus status;
  final Product? product; // Nested product object

  PreOrder({
    required this.id,
    required this.userId,
    this.cropId,
    required this.productId,
    required this.qty,
    required this.location,
    this.noteText,
    required this.deliveryDate,
    this.recurringSchedule,
    required this.status,
    this.product,
  });

  factory PreOrder.fromJson(Map<String, dynamic> json) {
    return PreOrder(
      id: json['id'] != null ? (json['id'] as num).toInt() : 0,
      userId: json['user_id'] != null ? (json['user_id'] as num).toInt() : 0,
      cropId: json['crop_id'] != null ? (json['crop_id'] as num).toInt() : null,
      productId: json['product_id'] != null ? (json['product_id'] as num).toInt() : 0,
      qty: json['qty'] != null ? double.tryParse(json['qty'].toString()) ?? 0.0 : 0.0,
      location: json['location'] ?? "Unknown location",
      noteText: json['note'],
      deliveryDate: json['delivery_date'] != null
          ? DateTime.tryParse(json['delivery_date']) ?? DateTime.now()
          : DateTime.now(),
      recurringSchedule: json['recurring_schedule'],
      status: PreOrderStatusExtension.fromString(json['status'] ?? 'pending'),
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'crop_id': cropId,
        'product_id': productId,
        'qty': qty,
        'location': location,
        'note': noteText,
        'delivery_date': deliveryDate.toIso8601String(),
        'recurring_schedule': recurringSchedule,
        'status': status.value, // enum to string
        'product': product?.toJson(),
  };
    PreOrder copyWith({
    int? id,
    int? userId,
    int? cropId,
    int? productId,
    double? qty,
    String? location,
    String? noteText,
    DateTime? deliveryDate,
    String? recurringSchedule,
    PreOrderStatus? status,
    Product? product,
  }) {
    return PreOrder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cropId: cropId ?? this.cropId,
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      location: location ?? this.location,
      noteText: noteText ?? this.noteText,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      recurringSchedule: recurringSchedule ?? this.recurringSchedule,
      status: status ?? this.status,
      product: product ?? this.product,
    );
  }

}
