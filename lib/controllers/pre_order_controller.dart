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
  Future<void> createPreOrder({required PreOrder model}) async {
    if (userController.user.id == null) {
      Get.snackbar('Error', 'User not found');
      Get.toNamed(AppRoutes.login);
      return;
    }

    final product = products.firstWhere(
      (p) => p.id == model.productId,
      orElse: () => throw Exception('Selected product not found'),
    );

    isLoading.value = true;
    final result = await preOrderRepo.createPreOrder(
      model: model,
      userId: userController.user.id!,
      product: product,
    );

    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (success) => print('Pre-order created successfully'),
    );
    isLoading.value = false;
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
