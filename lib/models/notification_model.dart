 import 'package:kaseapp_ui/utils/message_types_enum.dart';
class NotificationModel {
  final int id;
  final int? recepient_id;
  final int farmId;
  final int vendorId;
  final int preOrderId;
  final int? referenceId;
  final String message;
  final MessageTypesEnum type;
  late final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    this.recepient_id,
    required this.farmId,
    required this.vendorId,
    required this.preOrderId,
    this.referenceId,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

factory NotificationModel.fromJson(Map<String, dynamic> json) {
  int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  DateTime parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  return NotificationModel(
    id: parseInt(json['id']),
    recepient_id: parseInt(json['recepient_id']),
    farmId: parseInt(json['farm_id']),
    vendorId: parseInt(json['vendor_id']),
    preOrderId: parseInt(json['pre_order_id']),
    referenceId: json['reference'] != null ? parseInt(json['reference']['id']) : null,
    message: json['message'] ?? '',
    type: MessageTypesEnum.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => MessageTypesEnum.preOrder,
    ),
    isRead: (json['read_status'] ?? 0) == 1,
    createdAt: parseDate(json['created_at']),
    updatedAt: parseDate(json['updated_at']),
  );
}

}
