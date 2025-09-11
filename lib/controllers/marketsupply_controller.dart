import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/resettable_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/market_supplies.dart';
import 'package:kaseapp_ui/repositories/market_supply_repositories.dart';
class MarketsupplyController extends GetxController implements ResettableController{

  final MarketSupplyRepositories marketSupplyRepositories;
  final AuthController authController = Get.find();
  final UserController userController = Get.find();

  MarketsupplyController({required this.marketSupplyRepositories});

  var market_supplies = <MarketSupplies>[].obs;
  var isLoading = false.obs;

  // fetch data market supply

  Future<void>fetchMarketSupplies() async{
    isLoading.value = true;
    final result = await marketSupplyRepositories.fetchMarketSupplies();

    result.fold((failure){
      Get.snackbar("Error", failure.message);
    }, (marketSuppliesList){
      market_supplies.assignAll(marketSuppliesList);
    });
    
    isLoading.value = false;

  }
    @override
  void reset() {
    market_supplies.clear();
    isLoading.value = false;
    print("MarketSupplyController has been reset");
  }

}