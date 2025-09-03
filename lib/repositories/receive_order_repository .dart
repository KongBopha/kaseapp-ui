import 'package:kaseapp_ui/utils/helper/api_helper.dart';

class ReceiveOrderRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> getReceiveOrders({required int page}) async {
    return await _apiHelper.get(
      endpoint: '/pre-order/listing',
      queryParameters: {'page': page.toString()},
    );
  }
}
