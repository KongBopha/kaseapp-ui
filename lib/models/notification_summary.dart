import 'package:kaseapp_ui/models/farm_model.dart';
import 'package:kaseapp_ui/models/vendor_model.dart';
import 'package:kaseapp_ui/models/product.dart';
import 'package:kaseapp_ui/models/notification_model.dart';

class NotificationSummary {
  final int preOrderId;
  final VendorModel? vendor;
  final FarmModel? farm;
  final Product? product;
  final List<NotificationModel> notifications;
  final DateTime createdAt;

  NotificationSummary({
    required this.preOrderId,
    required this.vendor,
    required this.farm,
    required this.product,
    required this.notifications,
    required this.createdAt,
  });

  factory NotificationSummary.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      return DateTime.tryParse(value.toString()) ?? DateTime.now();
    }

    // Handle notifications list
    final List notifList = (json['notifications'] as List?) ?? [];

    // --- Parse vendor ---
    VendorModel? vendor;
    if (json['vendor'] != null) {
      vendor = VendorModel.fromJson({
        ...?json['vendor']?['vendor_info'],
        ...?json['vendor']?['user_info'],
      });
    }

    FarmModel? farm;
    if (json['farm'] != null) {
      farm = FarmModel.fromJson(json['farm']);
    }

    Product? product;
    if (json['product'] != null) {
      product = Product.fromJson(json['product']);
    }

    return NotificationSummary(
      preOrderId: json['pre_order_id'] ?? 0,
      vendor: vendor,
      farm: farm,
      product: product,
      notifications: notifList
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: parseDate(json['created_at']),
    );
  }

  NotificationSummary copyWith({
    int? preOrderId,
    VendorModel? vendor,
    FarmModel? farm,
    Product? product,
    List<NotificationModel>? notifications,
    DateTime? createdAt,
  }) {
    return NotificationSummary(
      preOrderId: preOrderId ?? this.preOrderId,
      vendor: vendor ?? this.vendor,
      farm: farm ?? this.farm,
      product: product ?? this.product,
      notifications: notifications ?? this.notifications,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
