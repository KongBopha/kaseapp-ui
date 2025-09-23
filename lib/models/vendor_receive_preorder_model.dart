import 'package:kaseapp_ui/utils/order_details_enum.dart';

class VendorReceivePreorderModel {
  final int preOrderId;
  final int orderDetailId;  
  final String farmName;      
  final String productName;
  final double requestedQty;        
  final double fulfilledQty;
  final String location;
  final String? note;
  final String deliveryDate;
  final OrderDetailsEnum status;

  VendorReceivePreorderModel({
    required this.preOrderId,
    required this.orderDetailId,
    required this.farmName,
    required this.productName,
    required this.requestedQty,
    required this.fulfilledQty,
    required this.location,
    this.note,
    required this.deliveryDate,
    required this.status,
  });

  factory VendorReceivePreorderModel.fromJson(Map<String, dynamic> json) {
    return VendorReceivePreorderModel(
      preOrderId: json['pre_order_id'] != null ? (json['pre_order_id'] as num).toInt() : 0,
      orderDetailId: json['order_detail_id'] != null ? (json['order_detail_id'] as num).toInt() : 0,
      farmName: json['vendorName'] as String? ?? 'Unknown',  
      productName: json['product_name'] as String,
      requestedQty: double.tryParse(json['requested_qty']?.toString() ?? '0') ?? 0.0,
      fulfilledQty: double.tryParse(json['fulfilled_qty']?.toString() ?? '0') ?? 0.0,
      location: json['location'] as String? ?? '',
      note: json['note'] as String?,
      deliveryDate: json['delivery_date'] as String? ?? '',
      status: OrderDetailsEnum.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['offer_status'] as String?)?.toLowerCase(),
        orElse: () => OrderDetailsEnum.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pre_order_id': preOrderId,
      'order_detail_id': orderDetailId,
      'vendorName': farmName,
      'product_name': productName,
      'requested_qty': requestedQty,
      'fulfilled_qty': fulfilledQty,
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
    double? requestedQty,
    double? fulfilledQty,
    String? location,
    String? note,
    String? deliveryDate,
    OrderDetailsEnum? status,
  }) {
    return VendorReceivePreorderModel(
      preOrderId: preOrderId ?? this.preOrderId,
      orderDetailId: orderDetailId ?? this.orderDetailId,
      farmName: farmName ?? this.farmName,
      productName: productName ?? this.productName,
      requestedQty: requestedQty ?? this.requestedQty,
      fulfilledQty: fulfilledQty ?? this.fulfilledQty,
      location: location ?? this.location,
      note: note ?? this.note,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
    );
  }
}
