import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/models/product.dart';
import 'package:kaseapp_ui/models/receiveorder_model.dart';
import 'package:kaseapp_ui/repositories/pre_order_repository.dart';
import 'package:kaseapp_ui/repositories/product_repository.dart';

class PreOrderController extends GetxController {
  final PreOrderRepository preOrderRepo;
  final ProductRepository productRepo;
  final UserController userController = Get.find();
  final ProductController productController = Get.find();

  PreOrderController({required this.preOrderRepo, required this.productRepo});
  var preOrders = <PreOrder>[].obs;
  var products = <Product>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    //fetchPreOrders();
    productController.fetchProductbyname().then((_) {
      // Sync products to PreOrderController
      products.assignAll(productController.products);
    });
    super.onInit();
  }

  // Future<void> fetchPreOrders() async {
  //   isLoading.value = true;
  //   final result = await preOrderRepo.getPreOrders();
  //   result.fold(
  //     (failure) => Get.snackbar('Error', failure.message),
  //     (list) => receiveOrders.assignAll(list),
  //   );
  //   isLoading.value = false;
  // }

  Future<void> createPreOrder({required PreOrder model}) async {
    if (userController.user.id == null) {
      Get.snackbar('Error', 'User not found');
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
      // fetch from user input 
      model: model,
      userId: userController.user.id!,
      product: product,
    );

    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (success) => result,
    );
    isLoading.value = false;
  }
}
