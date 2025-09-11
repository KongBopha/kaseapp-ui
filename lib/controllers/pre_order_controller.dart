import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/Routes/routes.dart';
import 'package:kaseapp_ui/controllers/middleware/resettable_controller.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/models/product.dart';
import 'package:kaseapp_ui/repositories/pre_order_repository.dart';

class PreOrderController extends GetxController implements ResettableController{
  final PreOrderRepository preOrderRepo;
  final UserController userController = Get.find();
  final ProductController productController = Get.find();

  PreOrderController({required this.preOrderRepo});

  var preOrders = <PreOrder>[].obs;
  var products = <Product>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    // Listen to ProductController's products and sync
    ever<List<Product>>(productController.products, (productList) {
      products.assignAll(productList);
      print('=== PreOrderController synced products ===');
      print('Total products available: ${products.length}');
    });
  }

  Future<void> createPreOrder({required PreOrder model}) async {
    if (userController.user.id == null) {
      Get.snackbar('Error', 'User not found');
      Get.toNamed(AppRoutes.login);
      return;
    }

    final product = products.firstWhere(
      (p) => p.id == model.productId,
      orElse: () {
        throw Exception('Selected product not found');
      },
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
  @override
  void reset() {
    preOrders.clear();
    products.clear();
    isLoading.value = true;
    print('PreOrderController has been reset');
  }
}
