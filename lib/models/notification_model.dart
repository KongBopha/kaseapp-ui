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
    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recepient_id': recepient_id,
      'farm_id': farmId,
      'vendor_id': vendorId,
      'pre_order_id': preOrderId,
      'reference_id': referenceId,
      'message': message,
      'type': type.name,
      'read_status': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
    NotificationModel copyWith({
    int? id,
    int? recepientId,
    int? farmId,
    int? vendorId,
    int? preOrderId,
    int? referenceId,
    String? message,
    MessageTypesEnum? type,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      recepient_id: recepientId ?? this.recepient_id,
      farmId: farmId ?? this.farmId,
      vendorId: vendorId ?? this.vendorId,
      preOrderId: preOrderId ?? this.preOrderId,
      referenceId: referenceId ?? this.referenceId,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  }
