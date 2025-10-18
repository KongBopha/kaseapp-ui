import 'notification_model.dart';

class NotificationSummary {
  final int preOrderId;
  final dynamic product;
  final dynamic vendor;
  final dynamic farm;
  final DateTime createdAt;
  final List<NotificationModel> notifications;

  NotificationSummary({
    required this.preOrderId,
    required this.product,
    required this.vendor,
    required this.farm,
    required this.notifications,
    required this.createdAt
  });

  factory NotificationSummary.fromJson(Map<String, dynamic> json) {

    DateTime parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
    final List notifList = (json['notifications'] as List?) ?? [];
    return NotificationSummary(
      preOrderId: json['pre_order_id'] ?? 0,
      product: json['product'],
      vendor: {
        'user_info': json['vendor']?['user_info'] ?? {},
        'vendor_info': json['vendor']?['vendor_info'] ?? {},
      },      
      farm: json['farm'],
      createdAt: parseDate(json['created_at']),
      notifications: notifList
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
    NotificationSummary copyWith({
    int? preOrderId,
    dynamic product,
    dynamic vendor,
    dynamic farm,
    DateTime? createdAt,

    
    List<NotificationModel>? notifications,
  }) {
    return NotificationSummary(
      preOrderId: preOrderId ?? this.preOrderId,
      product: product ?? this.product,
      vendor: vendor ?? this.vendor,
      farm: farm ?? this.farm,
      createdAt: createdAt ?? this.createdAt,
      notifications: notifications ?? this.notifications,
    );
  }
}
