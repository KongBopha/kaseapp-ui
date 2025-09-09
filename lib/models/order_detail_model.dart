import 'package:kaseapp_ui/utils/order_details_enum.dart';

class OrderDetailModel {

  final int ?id;
  final int pre_order_id;
  final int farm_id;
  late int ?crop_id;
  final int fulfilled_qty;
  final OrderDetailsEnum offer_status;
  final String ?description;

    OrderDetailModel({
    this.id,
    required this.pre_order_id,
    required this.farm_id,
    this.crop_id,
    required this.fulfilled_qty,
    required this.offer_status,
    this.description,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id']!= null ? (json['id'] as num).toInt() : 0,
      pre_order_id: json['pre_order_id'],
      farm_id: json['farm_id'],
      crop_id: json['crop_id']!= null ? (json['id'] as num).toInt() : 0,
      fulfilled_qty: (json['fulfilled_qty'] is String)
          ? int.tryParse(json['fulfilled_qty']) ?? 0
          : json['fulfilled_qty'] ?? 0,
      offer_status: OrderDetailStatusExtension.fromString(json['offer_status']??'pending'),
      description: json['description']??null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pre_order_id': pre_order_id,
      'farm_id': farm_id,
      'crop_id': crop_id,
      'fulfilled_qty': fulfilled_qty,
      'offer_status': offer_status.value,
      'description': description,
    };
  }
}

