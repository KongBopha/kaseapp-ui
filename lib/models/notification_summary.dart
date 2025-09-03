import 'notification_model.dart';

class NotificationSummary {
  final int preOrderId;
  final dynamic product;
  final dynamic vendor;
  final dynamic farm;
  final List<NotificationModel> notifications;

  NotificationSummary({
    required this.preOrderId,
    required this.product,
    required this.vendor,
    required this.farm,
    required this.notifications,
  });

  factory NotificationSummary.fromJson(Map<String, dynamic> json) {
    final List notifList = (json['notifications'] as List?) ?? [];
    return NotificationSummary(
      preOrderId: json['pre_order_id'] ?? 0,
      product: json['product'],
      vendor: json['vendor'],
      farm: json['farm'],
      notifications: notifList
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
