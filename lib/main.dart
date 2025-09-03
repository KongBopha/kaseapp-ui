import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/receiveorder_controller.dart';
import 'package:kaseapp_ui/repositories/receive_order_repository%20.dart';

// Helpers
import 'package:kaseapp_ui/utils/helper/api_helper.dart';

// Bindings & Routes
import 'package:kaseapp_ui/configs/bindings/binding.dart';
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

// Views
import 'package:kaseapp_ui/views/main_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController());
  Get.put(UserController());

  Get.put(ApiHelper());

  Get.put(ProductRepository());
  Get.put(PreOrderRepository());
  Get.put(ReceiveOrderRepository());
  Get.lazyPut(() => NotificationRepository(Get.find<ApiHelper>()));

  Get.put(ProductController(productRepo: Get.find<ProductRepository>()));
  Get.put(PreOrderController(
    preOrderRepo: Get.find<PreOrderRepository>(),
    productRepo: Get.find<ProductRepository>(),
  ));
  Get.lazyPut(() => NotificationController(Get.find<NotificationRepository>()));
  Get.put(ReceiveOrderController(repo: ReceiveOrderRepository()));

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
      initialBinding: RootBinding(),
      getPages: AppRoutes.generateRoutes,
      home: const MainView(),
    );
  }
}
