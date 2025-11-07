import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/resettable_controller.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/models/preorder_vendor_listing.dart';
import 'package:kaseapp_ui/models/product.dart';
import 'package:kaseapp_ui/repositories/pre_order_repository.dart';
import 'package:dartz/dartz.dart';
import '../utils/error/failure.dart';

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
    fetchPreorder(); // initial fetch
  }

  /// ========================
  /// Basic PreOrder CRUD
  /// ========================

  Future<bool> createPreOrder({required PreOrder model}) async {
    if (userController.user.id == null) return false;

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

      if (result.isRight()) {
        await fetchPreorder(page: 1);  
      }

      return result.fold((failure) => false, (success) => true);
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

  Future<void> fetchPreorder({int page = 1, String? search, String? timeFilterParam}) async {
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

  /// ========================
  /// PreOrder from Market Surplus
  /// ========================
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

      if (result.isRight()) {
        await fetchPreorder(page: 1); // refresh list after creation
      }

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

  /// ========================
  /// Get PreOrder by ID
  /// ========================
  Future<PreOrder?> getPreOrderById(int id) async {
    try {
      isLoading.value = true;
      final Either<Failure, PreOrder> result = await preOrderRepo.getPreOrderById(id);
      isLoading.value = false;

      return result.fold((failure) {
        print("Get PreOrderById Error: ${failure.message}");
        return null;
      }, (preOrder) => preOrder);
    } catch (e) {
      isLoading.value = false;
      print("Error in getPreOrderById: $e");
      return null;
    }
  }

  /// ========================
  /// Update PreOrder
  /// ========================
  Future<bool> updatePreOrder({required int id, required Map<String, dynamic> updates}) async {
    try {
      isLoading.value = true;
      final Either<Failure, PreOrder> result = await preOrderRepo.updatePreOrder(id: id, updates: updates);
      isLoading.value = false;

      if (result.isRight()) {
        await fetchPreorder(page: currentPage.value); // refresh current page
      }

      return result.fold((failure) {
        print("Update PreOrder Error: ${failure.message}");
        return false;
      }, (success) => true);
    } catch (e) {
      isLoading.value = false;
      print("Error in updatePreOrder: $e");
      return false;
    }
  }

  /// ========================
  /// Delete PreOrder
  /// ========================
  Future<bool> deletePreOrder(int id) async {
    try {
      isLoading.value = true;
      final Either<Failure, bool> result = await preOrderRepo.deletePreOrder(id);
      isLoading.value = false;

      if (result.isRight()) {
        // Remove deleted pre-order from the list
        preOrderListing.removeWhere((item) => item.id == id);
      }

      return result.fold((failure) {
        print("Delete PreOrder Error: ${failure.message}");
        return false;
      }, (success) => success);
    } catch (e) {
      isLoading.value = false;
      print("Error in deletePreOrder: $e");
      return false;
    }
  }

  /// ========================
  /// Pagination helpers
  /// ========================
  Future<void> jumpToPage(int page) async {
    if (page >= 1 && page <= lastPage.value) await fetchPreorder(page: page);
  }

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
