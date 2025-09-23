import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/resettable_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/product.dart';
import 'package:kaseapp_ui/repositories/product_repository.dart';
class ProductController extends GetxController implements ResettableController{
  final ProductRepository productRepo;
  final AuthController authController = Get.find();
  final UserController userController = Get.find();

  ProductController({required this.productRepo});

  var products = <Product>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    //fetchProductsByQuery('');
    super.onInit();
  }

  /// Fetch all products and update the reactive list

  Future<void> fetchProductsByQuery(String query) async {
    if (query.isEmpty) {
      products.value = [];
      return;
    }

    isLoading.value = true;
    final result = await productRepo.fetchProductsByQuery(query);

    result.fold(
      (failure) {
        Get.snackbar('Error', 'Failed to fetch products: ${failure.message}');
        products.value = [];
      },
      (productsList) {
        products.value = productsList;
      },
    );

    isLoading.value = false;
  }
  
  @override
  void reset() {
    products.clear();
    isLoading.value = false;
  }
}
