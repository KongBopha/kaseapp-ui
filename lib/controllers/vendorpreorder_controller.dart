import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/resettable_controller.dart';
import 'package:kaseapp_ui/models/preorder_listing.dart';
import 'package:kaseapp_ui/utils/pre_order_enum.dart';

import '../repositories/receive_order_repository .dart';

class VendorPreOrderController extends GetxController implements ResettableController {
  final ReceiveOrderRepository repo;

  VendorPreOrderController({required this.repo});

  var preOrders = <PreOrderListing>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;

  // Track selected status
  var selectedStatus = PreOrderStatus.pending.obs;

  @override
  void onInit() {
    vendorFilterPreOrder();  
    super.onInit();
  }

  Future<void> vendorFilterPreOrder({bool loadMore = false}) async {
    if (isLoading.value) return;
    if (loadMore && currentPage.value > lastPage.value) return;

    isLoading.value = true;
    final pageToFetch = loadMore ? currentPage.value + 1 : 1;

    try {
      final bool excludePending = selectedStatus.value != PreOrderStatus.pending;

      final response = await repo.getReceiveOrders(
        status: selectedStatus.value.value,  
        page: pageToFetch,
        excludePending: excludePending,  
      );

      final data = response['data'] as List<dynamic>;
      final orders = data
          .map((json) => PreOrderListing.fromJson(json as Map<String, dynamic>))
          .toList();

      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      lastPage.value = meta['last_page'] != null
          ? (meta['last_page'] as num).toInt()
          : 1;
      currentPage.value = meta['current_page'] != null
          ? (meta['current_page'] as num).toInt()
          : 1;

      if (loadMore) {
        preOrders.addAll(orders);
        currentPage.value++;
      } else {
        preOrders.assignAll(orders);
        currentPage.value = 1;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void changeStatus(PreOrderStatus status) {
    if (selectedStatus.value != status) {
      selectedStatus.value = status;
      vendorFilterPreOrder(); // refresh list with new filter
    }
  }

  bool get canLoadMore => currentPage.value < lastPage.value;
  
  @override
  void reset() {
    preOrders.clear();
    currentPage.value = 1;
    lastPage.value = 1;
    selectedStatus.value = PreOrderStatus.pending;
  }
}

