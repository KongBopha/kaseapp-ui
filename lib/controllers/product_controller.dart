import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/product.dart';
import 'package:kaseapp_ui/repositories/product_repository.dart';
class ProductController extends GetxController {
  final ProductRepository productRepo;
  final AuthController authController = Get.find();
  final UserController userController = Get.find();

  ProductController({required this.productRepo});

  var products = <Product>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchProductbyname();
    super.onInit();
  }

  /// Fetch all products and update the reactive list
  Future<void> fetchProductbyname() async {
    isLoading.value = true;
    final result = await productRepo.fetchProductsByName();

    result.fold(
      (failure) {
        Get.snackbar('Error', failure.message);
      },
      (productsList) {
        products.assignAll(productsList);
      },
    );

    isLoading.value = false;
  }
}
