import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/resettable_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/order_detail_model.dart';
import 'package:kaseapp_ui/models/preorder_listing.dart';
import 'package:kaseapp_ui/models/receiveorder_listing.dart';
import 'package:kaseapp_ui/models/receiveorder_model.dart';
import 'package:kaseapp_ui/repositories/order_detail_repository.dart';
import 'package:kaseapp_ui/repositories/receive_order_repository .dart';
import 'package:kaseapp_ui/repositories/receive_order_respond_repository.dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';

class ReceiveOrderController extends GetxController
    implements ResettableController {
  final ReceiveOrderRepository repo;
  final OrderDetailRepository orderDetailRepository;
  final ReceiveOrderRespondRepository respondRepository;
  final UserController userController = Get.find();
  final AuthController _authController = Get.find();


  ReceiveOrderController({
    required this.repo,
    required this.orderDetailRepository,
    required this.respondRepository,
  });

  var allOrders = <ReceivePreorderViewModel>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var selectedStatus = OrderDetailsEnum.pending.obs;

  Future<void> changeStatus(OrderDetailsEnum? status) async {
    selectedStatus.value = status ?? OrderDetailsEnum.pending;
    reset();
    await fetchOrders();

  }

  
   
  @override
  void reset() {
    allOrders.clear();
    currentPage.value = 1;
    lastPage.value = 1;
  }

  bool get canLoadMore => currentPage.value < lastPage.value;

  Future<void> fetchOrders({bool loadMore = false}) async {
    if (!_authController.auth) return;
    
    if (isLoading.value) return;
    if (loadMore && !canLoadMore) return;

    isLoading.value = true;
    final pageToFetch = loadMore ? currentPage.value + 1 : 1;

    try {
      List<ReceivePreorderViewModel> orders = [];
      late Map<String, dynamic> response;

      if (selectedStatus.value == OrderDetailsEnum.pending) {
        response = await repo.getReceiveOrders(page: pageToFetch);
        final data = response['data'] as List<dynamic>;
        orders = data
            .map((e) => ReceivePreorderViewModel.fromPreOrderListing(
                PreOrderListing.fromJson(e)))
            .toList();
      } else {
        response = await respondRepository.filterOrderDetails(
          page: pageToFetch,
          offerStatus: selectedStatus.value.value,
        );
        final data = response['data'] as List<dynamic>;
        orders = data
            .map((e) =>
                ReceivePreorderViewModel.fromReceiveOrder(ReceiveorderModel.fromJson(e)))
            .toList();
      }

      if (loadMore) {
        for (var order in orders) {
          final index =
              allOrders.indexWhere((o) => o.preOrderId == order.preOrderId);
          if (index == -1) allOrders.add(order);
        }
        currentPage.value++;
      } else {
        allOrders.assignAll(orders);
        currentPage.value = 1;
      }

      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      lastPage.value = (meta['last_page'] as num?)?.toInt() ?? 1;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> respondToPreOrder({
    required ReceivePreorderViewModel order,
    required OrderDetailsEnum offerStatus,
    required int fulfilledQty,
    String? description,
  }) async {
    try {
      isLoading.value = true;

      final orderDetail = OrderDetailModel(
        pre_order_id: order.preOrderId,
        farm_id: userController.user.id!,
        fulfilled_qty: fulfilledQty,
        offer_status: offerStatus,
        description: description,
      );

      final result = await orderDetailRepository.submitOrderDetail(
        orderDetail: orderDetail,
        userId: orderDetail.farm_id,
        preOrderId: order.preOrderId,
      );

      bool isSuccess = false;

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
          isSuccess = false;
        },
        (createdOrder) {
          final index =
              allOrders.indexWhere((element) => element.preOrderId == order.preOrderId);
          if (index != -1) {
            allOrders[index] = allOrders[index].copyWith(
              offerStatus: offerStatus.value,
              fulfilledQty: fulfilledQty.toDouble(),
              note: description,
            );
          }
          Get.snackbar('Success', 'Response submitted successfully');
          isSuccess = true;
        },
      );

      return isSuccess;
    } catch (e, s) {
      print('RespondToPreOrder Error: $e');
      print(s);
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
