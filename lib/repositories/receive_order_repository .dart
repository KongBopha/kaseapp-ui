import 'package:kaseapp_ui/utils/error/failure.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';

class ReceiveOrderRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> getReceiveOrders({
    required int page,
    String? status,
    bool excludePending = false, 
  }) async {
    try {
      final queryParams = {'page': page.toString()};

      if (status != null && status != 'all') {
        queryParams['status'] = status;
      }

      if (excludePending) {
        queryParams['exclude_pending'] = 'true';  
      }

      return await _apiHelper.get(
        endpoint: '/pre-order/listing',
        queryParameters: queryParams,
      );
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}

