import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/resettable_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/order_detail_model.dart';
import 'package:kaseapp_ui/models/receiveorder_model.dart';
import 'package:kaseapp_ui/repositories/order_detail_repository.dart';
import 'package:kaseapp_ui/repositories/receive_order_repository .dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';

class ReceiveOrderController extends GetxController implements ResettableController {
  final ReceiveOrderRepository repo;
  final OrderDetailRepository orderDetailRepository;
  final UserController userController = Get.find();


  ReceiveOrderController({required this.repo,required this.orderDetailRepository});

  var receiveOrders = <ReceiveorderModel>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;

  @override
  void onInit() {
    fetchReceiveOrders();
    super.onInit();
  }

  Future<void> fetchReceiveOrders({bool loadMore = false}) async {
    if (isLoading.value) return; 
    if (loadMore && currentPage.value > lastPage.value) return;

    isLoading.value = true;

    final pageToFetch = loadMore ? currentPage.value + 1 : 1;

    try {
      final response = await repo.getReceiveOrders(page: pageToFetch);

      // Parse data array
      final data = response['data'] as List<dynamic>;
      final orders = data
          .map((json) => ReceiveorderModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Pagination info
      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      lastPage.value = meta['last_page'] != null
          ? (meta['last_page'] as num).toInt()
          : 1;
      currentPage.value = meta['current_page'] != null
          ? (meta['current_page'] as num).toInt()
          : 1;

      if (loadMore) {
        receiveOrders.addAll(orders);
        currentPage.value++;
      } else {
        receiveOrders.assignAll(orders);
        currentPage.value = 1;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool get canLoadMore => currentPage.value < lastPage.value;
    Future<void> respondToPreOrder({
    required ReceiveorderModel preOrder,
    required OrderDetailsEnum offerStatus,
    required int fulfilledQty,
    String? description,
  }) async {
    try {
      isLoading.value = true;

      // Create OrderDetailModel
      final orderDetail = OrderDetailModel(
        pre_order_id: preOrder.preOrderId,
        farm_id:userController.user.id!,
        fulfilled_qty: fulfilledQty,
        offer_status: offerStatus,
        description: description,
      );

      final result = await orderDetailRepository.submitOrderDetail(
        orderDetail: orderDetail,
        userId: orderDetail.farm_id,
        preOrderId: preOrder.preOrderId,
      );

      result.fold(
        (failure) => Get.snackbar('Error', failure.message),
        (createdOrder) {
          // Update UI: mark this pre-order as responded
          final index = receiveOrders.indexWhere(
              (element) => element.preOrderId == preOrder.preOrderId);
          if (index != -1) {
            receiveOrders[index] = receiveOrders[index].copyWith(
              status: offerStatus == OrderDetailsEnum.accepted
                  ? 'Accepted'
                  : 'Rejected',
            );
          }
          Get.snackbar('Success', 'Response submitted successfully');
        },
      );
    }catch (e, s) {    
    print('RespondToPreOrder Error: $e');
    print(s);
    Get.snackbar('Error', e.toString());
  } finally {
      isLoading.value = false;
    }
  }
  
  @override
  void reset() {
    receiveOrders.clear();
    isLoading.value = false;
    print("ReceiveOrderController has been reset");
 } 
}
