import 'package:get/get.dart';
import 'package:kaseapp_ui/models/vendor_receive_preorder_model.dart';
import 'package:kaseapp_ui/repositories/receive_order_respond_repository.dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';

class ReceiveOrderRespondController extends GetxController {
  final ReceiveOrderRespondRepository repository;
  final AuthController authController = Get.find();

  ReceiveOrderRespondController({required this.repository});

  var receiveOrders = <VendorReceivePreorderModel>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var selectedStatus = Rx<String?>(null); // null = all

  bool get canLoadMore => currentPage.value < lastPage.value;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void changeStatus(String? status) {
    selectedStatus.value = status;
    reset();
    fetchOrders();
  }

  void reset() {
    receiveOrders.clear();
    currentPage.value = 1;
    lastPage.value = 1;
  }

  Future<void> fetchOrders({bool loadMore = false}) async {
    if (isLoading.value) return;
    if (loadMore && !canLoadMore) return;

    isLoading.value = true;
    final pageToFetch = loadMore ? currentPage.value + 1 : 1;

    try {
      final response = await repository.filterOrderDetails(
        page: pageToFetch,
        offerStatus: selectedStatus.value,
      );

      final data = List<Map<String, dynamic>>.from(response['data'] ?? []);
      final orders = data.map((json) => VendorReceivePreorderModel.fromJson(json)).toList();

      final meta = Map<String, dynamic>.from(response['meta'] ?? {});
      lastPage.value = (meta['last_page'] as num?)?.toInt() ?? 1;
      currentPage.value = (meta['current_page'] as num?)?.toInt() ?? pageToFetch;

      if (loadMore) {
        receiveOrders.addAll(orders);
      } else {
        receiveOrders.assignAll(orders);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch orders: $e');
    } finally {
      isLoading.value = false;
    }
  }
// vendor confirmation/ rejection
  Future<bool> respondToOffer({
    required int orderDetailId,
    required OrderDetailsEnum status,
    int? fulfilledQty,
    String? description,
  }) async {
    try {
      await repository.vendorStatus(
        orderDetail_id: orderDetailId,
        status: status,
      );

      final index =
          receiveOrders.indexWhere((o) => o.orderDetailId == orderDetailId);
      if (index != -1) {
        receiveOrders[index] =
            receiveOrders[index].copyWith(status: status, note: description);
      }

      Get.snackbar('Success', 'Offer ${status.name} successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }
}
