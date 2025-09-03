import 'package:dartz/dartz.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';
import '../utils/error/failure.dart';
import '../models/product.dart';
import '../utils/pre_order_enum.dart';

class PreOrderRepository {
  final ApiHelper _apiHelper = ApiHelper();

  /// Create a new pre-order
  Future<Either<Failure, PreOrder>> createPreOrder({
    required PreOrder model,
    required int userId,
    Product? product,
  }) async {
    try {
      final preOrder = PreOrder(
        id: null,
        userId: userId,
        productId: model.productId,
        qty: model.qty,
        location: model.location,
        noteText: model.noteText,
        recurringSchedule: model.recurringSchedule,
        deliveryDate: model.deliveryDate,
        status: PreOrderStatus.pending,
        cropId: null,
        product: product,
      );

      final dynamic response = await _apiHelper.post(
        endpoint: '/pre-orders',
        jsonBody: preOrder.toJson(),
      );

      final createdPreOrder = PreOrder.fromJson(response);
      return Right(createdPreOrder);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  // // Fetch all pre-orders
  // Future<Either<Failure, List<ReceiveorderModel>>> getPreOrders() async {
  //   try {
  //     // API call returns Map<String, dynamic>
  //     final response = await _apiHelper.get(endpoint: '/pre-order/listing');

  //     // Extract the 'data' array
  //     final List<dynamic> orderJson = response['data'] ?? [];

  //     // Map each JSON object to PreOrder model
  //     final orders = orderJson
  //         .map((json) => ReceiveorderModel.fromJson(json as Map<String, dynamic>))
  //         .toList();

  //     return Right(orders);
  //   } on Failure catch (e) {
  //     return Left(e);
  //   }
  // }
}
