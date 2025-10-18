import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/Routes/routes.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/resettable_controller.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/models/preorder_vendor_listing.dart';
import 'package:kaseapp_ui/models/product.dart';
import 'package:kaseapp_ui/repositories/pre_order_repository.dart';
import 'package:kaseapp_ui/views/vendor_front_view.dart';

class PreOrderController extends GetxController implements ResettableController {
  final PreOrderRepository preOrderRepo;
  final UserController userController = Get.find();
  final ProductController productController = Get.find();
  final AuthController _authController = Get.find();

  PreOrderController({required this.preOrderRepo});

  var preOrders = <PreOrder>[].obs;
  var preOrderListing = <PreOrderListItem>[].obs;
  var products = <Product>[].obs;
  var isLoading = false.obs;

  // pagination
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var searchQuery = ''.obs;

  // time filter: 'all', 'today', 'this_week', 'next_week'
  var timeFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    ever<List<Product>>(productController.products, (productList) {
      products.assignAll(productList);
      print('=== PreOrderController synced products ===');
    });
    fetchPreorder(); // fetch initially
  }

    /// Create PreOrder
  Future<bool> createPreOrder({required PreOrder model}) async {
    if (userController.user.id == null) {
      return false; // User not found, view will handle snackbar
    }

    final product = products.firstWhere(
      (p) => p.id == model.productId,
      orElse: () => throw Exception('Selected product not found'),
    );

    try {
      isLoading.value = true;
      final result = await preOrderRepo.createPreOrder(
        model: model,
        userId: userController.user.id!,
        product: product,
      );

      isLoading.value = false;

      // Return true if success, false if failure
      return result.fold(
        (failure) => false,
        (success) => true,
      );
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }


  /// Fetch PreOrders with search & time filter
  Future<void> fetchPreorder({
    int page = 1,
    String? search,
    String? timeFilterParam,
  }) async {
    if (!_authController.auth) return;

    if (search != null) searchQuery.value = search;
    if (timeFilterParam != null) timeFilter.value = timeFilterParam;

    try {
      isLoading.value = true;

      final result = await preOrderRepo.getPreOrders(
        page: page,
        search: searchQuery.value,
        timeFilter: timeFilter.value != 'all' ? timeFilter.value : null,
      );

      final orders = result['orders'] as List<PreOrderListItem>;

      if (page == 1) {
        preOrderListing.assignAll(orders);
      } else {
        preOrderListing.addAll(orders);
      }

      currentPage.value = result['current_page'] as int;
      lastPage.value = result['last_page'] as int;
    } finally {
      isLoading.value = false;
    }
  }
    /// PreOrder creation from Market Surplus
Future<bool> createPreOrderFromSurplus(Map<String, dynamic> data) async {
  if (userController.user.id == null) return false;

  try {
    isLoading.value = true;

    final result = await preOrderRepo.createOrderFromMarket(
      userId: userController.user.id!,
      farmId: data['farm_id'],
      productId: data['product_id'],
      quantity: data['quantity'],
      unit: data['unit'],
      marketSupplyId: data['market_supply_id'],
      note: data['note'], 
      recurringSchedule: data['recurring_schedule'], 
      deliveryDate: data['delivery_date'], 
    );

    isLoading.value = false;
  return result.fold((failure) {
    print(" PreOrderFromSurplus Error: ${failure.message}");
    return false;
  }, (success) {
    print(" PreOrderFromSurplus Success: $success");
    return true;
  });
    } catch (e) {
      isLoading.value = false;
      print("Error creating pre-order from surplus: $e");
      return false;
    }
  }

    /// Jump to a specific page
    Future<void> jumpToPage(int page) async {
      if (page >= 1 && page <= lastPage.value) {
        await fetchPreorder(page: page);
      }
    }

    /// Set search & time filter
    void setFilters({String? search, String? timeFilterParam}) {
      searchQuery.value = search ?? '';
      if (timeFilterParam != null) timeFilter.value = timeFilterParam;
      fetchPreorder(page: 1);
    }

    @override
    void reset() {
      preOrders.clear();
      products.clear();
      preOrderListing.clear();
      currentPage.value = 1;
      lastPage.value = 1;
      isLoading.value = true;
      print('PreOrderController has been reset');
    }
  }
