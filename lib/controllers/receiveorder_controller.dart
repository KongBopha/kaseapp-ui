import 'package:get/get.dart';
import 'package:kaseapp_ui/models/receiveorder_model.dart';
import 'package:kaseapp_ui/repositories/receive_order_repository .dart';

class ReceiveOrderController extends GetxController {
  final ReceiveOrderRepository repo;

  ReceiveOrderController({required this.repo});

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
}
