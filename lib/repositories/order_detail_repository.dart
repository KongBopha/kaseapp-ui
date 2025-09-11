import 'package:kaseapp_ui/models/order_detail_model.dart';
import 'package:kaseapp_ui/utils/error/failure.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';
import 'package:dartz/dartz.dart';


class OrderDetailRepository {
  final ApiHelper _apiHelper = ApiHelper();

  // Create order detail for a farm
  Future<Either<Failure, OrderDetailModel>> submitOrderDetail({
    required int preOrderId,
    required int userId,
    required OrderDetailModel orderDetail,
  }) async {
    try {
      final response = await _apiHelper.post(
        endpoint: '/order-details/$preOrderId',
        jsonBody: orderDetail.toJson(),
      );

      final submittedOrderDetail = OrderDetailModel.fromJson(response);
      return right(submittedOrderDetail);
    } on Failure catch (e) {
      return left(e);
    }
  }

  // Reject Request 
  Future<Either<Failure,bool>> rejectPreOrder(
    { required int preOrderId,
      required int userId,
      required OrderDetailModel orderDetail,
}
  )async{
    try{
      final response = await _apiHelper.post(
        endpoint: '/', 
        jsonBody: {
          
      },
      );
    return right(response['success']??true);
    }on Failure catch(e)
    {
      return left(e);
    }
    
  }
}