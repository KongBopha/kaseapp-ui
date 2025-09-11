import 'package:kaseapp_ui/utils/error/failure.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';

class ReceiveOrderRespondRepository {
  final ApiHelper _apiHelper = ApiHelper();

  // listing pre order that farm responded

  Future<Map<String,dynamic>> getPreOrderRespond
  (
    {required int page}
  )async{
    return await _apiHelper.get(
      endpoint: '/order-details/listing',
      queryParameters: {'page':page.toString()},);
  } 

  // update confirm/reject to farmer
  Future<void>vendorStatus({required int orderDetail_id, required OrderDetailsEnum status})async{
    try{
      await _apiHelper.update(
        endpoint: '/order-details/$orderDetail_id/offer-status', 
        jsonBody: {
          'offer_status':status.value,
        },
        );
    }catch(e){
        throw ServerFailure(message: e.toString());
    }

  }
}
