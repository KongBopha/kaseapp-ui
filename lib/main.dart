import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/marketsupply_controller.dart';
import 'package:kaseapp_ui/controllers/receive_order_respond_controller.dart';
import 'package:kaseapp_ui/controllers/receiveorder_controller.dart';
import 'package:kaseapp_ui/repositories/market_supply_repositories.dart';
import 'package:kaseapp_ui/repositories/order_detail_repository.dart';
import 'package:kaseapp_ui/repositories/receive_order_repository .dart';
import 'package:kaseapp_ui/repositories/receive_order_respond_repository.dart';
// Helpers
import 'package:kaseapp_ui/utils/helper/api_helper.dart';
// Bindings & Routes
import 'package:kaseapp_ui/configs/routes/routes.dart';

// Controllers
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/controllers/pre_order_controller.dart';
import 'package:kaseapp_ui/controllers/notification_controller.dart';

// Repositories
import 'package:kaseapp_ui/repositories/product_repository.dart';
import 'package:kaseapp_ui/repositories/pre_order_repository.dart';
import 'package:kaseapp_ui/repositories/notification_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -----------------------------
  // Repositories (Global)
  // -----------------------------
  Get.put(ApiHelper());
  Get.put(ProductRepository());
  Get.put(PreOrderRepository());
  Get.put(NotificationRepository(Get.find<ApiHelper>()));
  Get.put(MarketSupplyRepositories());
  Get.put(ReceiveOrderRepository());
  Get.put(ReceiveOrderRespondRepository());
  Get.put(OrderDetailRepository());
  // -----------------------------
  // Controllers
  // -----------------------------
  Get.put(UserController()); 
  Get.put(AuthController()); // AuthController first to manage auth state

  // -----------------------------
  // Lazy-load auth-dependent controllers
  // -----------------------------
  // Use Get.lazyPut to create instances only when needed
  Get.lazyPut<ProductController>(() => ProductController(productRepo: Get.find<ProductRepository>()));
  Get.lazyPut<PreOrderController>(() => PreOrderController(preOrderRepo: Get.find<PreOrderRepository>()));
  Get.lazyPut<NotificationController>(() => NotificationController(Get.find<NotificationRepository>()));
  Get.lazyPut<MarketsupplyController>(() => MarketsupplyController(marketSupplyRepositories: Get.find<MarketSupplyRepositories>()));
  Get.lazyPut<ReceiveOrderController>(() => ReceiveOrderController(repo: Get.find<ReceiveOrderRepository>(),orderDetailRepository:Get.find<OrderDetailRepository>()));
  Get.lazyPut<ReceiveOrderRespondController>(() => ReceiveOrderRespondController(receiveOrderRespondRepository: Get.find<ReceiveOrderRespondRepository>()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KaseApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,  
      getPages: AppRoutes.generateRoutes,
    );
  }
}

