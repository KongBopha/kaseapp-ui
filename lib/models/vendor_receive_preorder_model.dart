import 'package:kaseapp_ui/utils/order_details_enum.dart';

class VendorReceivePreorderModel {
  final int preOrderId;
  final int orderDetailId;  
  final String farmName;
  final String productName;
  final double fulfilled_qty;
  final String location;
  final String? note;
  final String deliveryDate;
  final OrderDetailsEnum status;

  VendorReceivePreorderModel({
    required this.preOrderId,
    required this.orderDetailId,
    required this.farmName,
    required this.productName,
    required this.fulfilled_qty,
    required this.location,
    this.note,
    required this.deliveryDate,
    required this.status,
  });

  factory VendorReceivePreorderModel.fromJson(Map<String, dynamic> json) {
    return VendorReceivePreorderModel(
      preOrderId: json['pre_order_id'] != null ? (json['pre_order_id'] as num).toInt() : 0,
      orderDetailId: json['order_detail_id'] != null ? (json['order_detail_id'] as num).toInt() : 0,
      farmName: json['farm_name'] as String,
      productName: json['product_name'] as String,
      fulfilled_qty: double.tryParse(json['fulfilled_qty'].toString()) ?? 0.0,
      location: json['location'] as String,
      note: json['note'] as String?,
      deliveryDate: json['delivery_date'],
      status: OrderDetailsEnum.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['offer_status'] as String).toLowerCase(),
        orElse: () => OrderDetailsEnum.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pre_order_id': preOrderId,
      'farm_name': farmName,
      'product_name': productName,
      'fulfilled_qty': fulfilled_qty,
      'location': location,
      'note': note,
      'delivery_date': deliveryDate,
      'offer_status': status.name,
    };
  }
    VendorReceivePreorderModel copyWith({
    int? preOrderId,
    int? orderDetailId,
    String? farmName,
    String? productName,
    double? fulfilled_qty,
    String? location,
    String? note,
    String? deliveryDate,
    OrderDetailsEnum? status,
  }) {
    return VendorReceivePreorderModel(
      preOrderId: preOrderId ?? this.preOrderId,
      orderDetailId:orderDetailId ?? this.orderDetailId,
      farmName: farmName ?? this.farmName,
      productName: productName ?? this.productName,
      fulfilled_qty: fulfilled_qty ?? this.fulfilled_qty,
      location: location ?? this.location,
      note: note ?? this.note,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
    );
  }

}
