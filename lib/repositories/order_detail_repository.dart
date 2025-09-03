// import 'package:kaseapp_ui/models/order_detail_model.dart';
// import 'package:kaseapp_ui/models/pre_order_model.dart';
// import 'package:kaseapp_ui/models/product.dart';
// import 'package:kaseapp_ui/utils/error/failure.dart';
// import 'package:kaseapp_ui/utils/helper/api_helper.dart';
// import 'package:dartz/dartz.dart';
// import 'package:kaseapp_ui/utils/order_details_enum.dart';


// class OrderDetailRepository {

//   final ApiHelper _apiHelper = ApiHelper();

//   // create order details for farmer

//   Future<Either<Failure,OrderDetailModel>> createOrderDetail
//   (
//     {required OrderDetailModel model, required int userId,
//     Product? product, PreOrder? preOrder}
//   )async
//   { 
//    try{
//     final order = OrderDetailModel
//     (
//       id: null,
//       pre_order_id: model.pre_order_id, 
//       farm_id: userId, 
//       fulfilled_qty: model.fulfilled_qty, 
//       offer_status: OrderDetailsEnum.accepted, 
//       preOrder: preOrder
//     );
//       final dynamic response = await _apiHelper.post(
//         endpoint: '/order-details/{preOrderId}',
//         jsonBody: order.toJson(),
//       );
//       final createOrderDetail = OrderDetailModel.fromJson(response);
//       return right(createOrderDetail);
//    }on Failure catch(e){
//       return left(e);
//    } 
//   }
// } 