import 'package:kaseapp_ui/models/preorder_listing.dart';
import 'package:kaseapp_ui/models/receiveorder_model.dart';

class ReceivePreorderViewModel {
  final int preOrderId;
  final int? orderDetailId;
  final String vendorName;
  final String productName;
  final double requestedQty;
  final double fulfilledQty;
  final String location;
  final String note;
  final String deliveryDate;
  final String offerStatus;

  ReceivePreorderViewModel({
    required this.preOrderId,
    this.orderDetailId,
    required this.vendorName,
    required this.productName,
    required this.requestedQty,
    required this.fulfilledQty,
    required this.location,
    required this.note,
    required this.deliveryDate,
    required this.offerStatus,
  });

  // for pre order listing farmer

  factory ReceivePreorderViewModel.fromPreOrderListing(PreOrderListing pre) {
    return ReceivePreorderViewModel(
      preOrderId: pre.preOrderId,
      vendorName: pre.vendorName,
      productName: pre.productName,
      requestedQty: pre.quantity,
      fulfilledQty: 0,
      location: pre.location,
      note: pre.note,
      deliveryDate: pre.deliveryDate,
      offerStatus: pre.status,
    );
  }
  
  // filter status

  factory ReceivePreorderViewModel.fromReceiveOrder(ReceiveorderModel order) {
    return ReceivePreorderViewModel(
      preOrderId: order.preOrderId,
      orderDetailId: order.orderDetailId,
      vendorName: order.vendorName,
      productName: order.productName,
      requestedQty: order.requestedQty,
      fulfilledQty: order.fulfilledQty,
      location: order.location,
      note: order.note,
      deliveryDate: order.deliveryDate,
      offerStatus: order.offerStatus,
    );
  }

  ReceivePreorderViewModel copyWith({
    int? preOrderId,
    int? orderDetailId,
    String? vendorName,
    String? productName,
    double? requestedQty,
    double? fulfilledQty,
    String? location,
    String? note,
    String? deliveryDate,
    String? offerStatus,
  }) {
    return ReceivePreorderViewModel(
      preOrderId: preOrderId ?? this.preOrderId,
      orderDetailId: orderDetailId ?? this.orderDetailId,
      vendorName: vendorName ?? this.vendorName,
      productName: productName ?? this.productName,
      requestedQty: requestedQty ?? this.requestedQty,
      fulfilledQty: fulfilledQty ?? this.fulfilledQty,
      location: location ?? this.location,
      note: note ?? this.note,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      offerStatus: offerStatus ?? this.offerStatus,
    );
  }
}

