import 'package:dartz/dartz.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/models/preorder_vendor_listing.dart';
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

  // Fetch all pre-orders
  Future<Map<String, dynamic>> getPreOrders({
    int page = 1,
    String? search,
    String? timeFilter, // 'today', 'this_week', 'next_week' or null for all
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (timeFilter != null && timeFilter.isNotEmpty) 'time_filter': timeFilter,
      };

      final response = await _apiHelper.get(
        endpoint: '/pre-orders/list-item',
        queryParameters: queryParams,
      );

      print("API response: $response"); // Debug

      final dataList = (response['data']['data'] as List?) ?? [];

      final orders = dataList
          .map((json) => PreOrderListItem.fromJson(json as Map<String, dynamic>))
          .toList();

      final currentPage = int.tryParse(response['data']['current_page'].toString()) ?? 1;
      final lastPage = int.tryParse(response['data']['last_page'].toString()) ?? 1;

      return {
        'orders': orders,
        'current_page': currentPage,
        'last_page': lastPage,
      };
    } catch (e) {
      print("Error fetching pre-orders: $e");
      rethrow;
    }
  }
 /// Order directly from market surplus screen
Future<Either<Failure, PreOrder>> createOrderFromMarket({
  required int userId,
  required int farmId,
  required int productId,
  required double quantity,
  required String unit,
  required int marketSupplyId,
  String? note,
  String? recurringSchedule,
  DateTime? deliveryDate,
}) async {
  try {
    final Map<String, dynamic> requestBody = {
      'user_id': userId,
      'farm_id': farmId,
      'product_id': productId,
      'quantity': quantity,
      'unit': unit,
      'market_supply_id': marketSupplyId,
      if (note != null) 'note': note,
      if (recurringSchedule != null) 'recurring_schedule': recurringSchedule,
      if (deliveryDate != null) 'delivery_date': deliveryDate.toIso8601String(),
    };

    final dynamic response = await _apiHelper.post(
      endpoint: '/pre-orders/from-surplus',
      jsonBody: requestBody,
    );

    final createdPreOrder = PreOrder.fromJson(response);
    return Right(createdPreOrder);
  } on Failure catch (e) {
    return Left(e);
  }
}

}
