import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/vendor_receive_preorder_model.dart';
//import 'package:kaseapp_ui/repositories/order_detail_repository.dart';
import 'package:kaseapp_ui/repositories/receive_order_respond_repository.dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';


class ReceiveOrderRespondController extends GetxController{

  final ReceiveOrderRespondRepository receiveOrderRespondRepository;
//  final OrderDetailRepository orderDetailRepository;
  final UserController userController = Get.find();

  ReceiveOrderRespondController({required this.receiveOrderRespondRepository });

  var receiveOrders = <VendorReceivePreorderModel>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;

  @override
  void onInit() {
    fetchFarmRespond();
    super.onInit();
  }

  Future<void>fetchFarmRespond({bool loadMore =false})async{

    if(isLoading.value) return;
    if(loadMore && currentPage.value > lastPage.value) return;

    isLoading.value = true;

    final pageToFetch = loadMore ? currentPage.value +1:1;

    try{
      final response = await receiveOrderRespondRepository.getPreOrderRespond(page: pageToFetch);

      final data  = response['data'] as List<dynamic>;
      final orders  = data
            .map((json)=>VendorReceivePreorderModel.fromJson(json as Map<String,dynamic>))
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

  // response to farm offer confirm/reject

Future<void> respondToOffer({
  required int orderDetailId,
  required OrderDetailsEnum status,
  bool removeAfterRespond = false,  
}) async {
  try {
    // Check if the order exists locally first
    final index = receiveOrders.indexWhere(
      (order) => order.orderDetailId == orderDetailId,
    );

    if (index == -1) {
      Get.snackbar('Error', 'Order not found');
      return; // exit early
    }

    isLoading.value = true;

    // Call repository to update status
    await receiveOrderRespondRepository.vendorStatus(
      orderDetail_id: orderDetailId,
      status: status,
    );

    // Update the local list
    receiveOrders[index] = receiveOrders[index].copyWith(
      status: status,
    );

    // Optionally remove the order from the list
    if (removeAfterRespond) {
      receiveOrders.removeAt(index);
    }

    Get.snackbar('Success', 'Offer ${status} successfully');
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading.value = false;
  }
}

}