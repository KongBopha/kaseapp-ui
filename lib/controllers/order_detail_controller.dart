import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/resettable_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/order_detail_model.dart';
import 'package:kaseapp_ui/models/receiveorder_model.dart';
import 'package:kaseapp_ui/repositories/order_detail_repository.dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';

class OrderDetailController extends GetxController implements ResettableController {
  final OrderDetailRepository orderDetailRepository;
  final UserController userController = Get.find();

  OrderDetailController({required this.orderDetailRepository}); 

  var receiveOrders = <ReceiveorderModel>[].obs;
  var isLoading = false.obs;

  Future<void> respondToPreOrder({
    required ReceiveorderModel preOrder,
    required OrderDetailsEnum offerStatus,
    int fulfilledQty = 0,
    String? description,
  }) async {
    if (userController.user.id == null) {
      Get.snackbar('Error', 'User not found');
      return;
    }

    isLoading.value = true;

    try {
      final orderDetail = OrderDetailModel(
        pre_order_id: preOrder.preOrderId,
        farm_id: userController.user.id!,
        fulfilled_qty: fulfilledQty,
        offer_status: offerStatus,
        description: description,
      );

      final result = await orderDetailRepository.submitOrderDetail(
        preOrderId: preOrder.preOrderId,
        orderDetail: orderDetail,
        userId: userController.user.id!
      );

      result.fold(
        (failure) => Get.snackbar('Error', failure.message),
        (submittedOrder) {
          preOrder.offerStatus = offerStatus == OrderDetailsEnum.accepted ? 'Accepted' : 'Rejected';
          receiveOrders.refresh();
          Get.snackbar('Success', 'Response submitted successfully');
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  @override
  void reset() {
    receiveOrders.clear();
    isLoading.value = false;
    print("ReceiveOrderRespondController has been reset");  
  }  
  }

