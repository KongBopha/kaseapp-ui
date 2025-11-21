import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/secure_storage.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/controllers/pre_order_controller.dart';
import 'package:kaseapp_ui/controllers/notification_controller.dart';
import 'package:kaseapp_ui/controllers/marketsupply_controller.dart';
import 'package:kaseapp_ui/controllers/receiveorder_controller.dart';
import 'package:kaseapp_ui/controllers/receive_order_respond_controller.dart';
import 'package:kaseapp_ui/controllers/vendorpreorder_controller.dart';

// Repositories
import 'package:kaseapp_ui/repositories/auth_repository.dart';
import 'package:kaseapp_ui/repositories/product_repository.dart';
import 'package:kaseapp_ui/repositories/pre_order_repository.dart';
import 'package:kaseapp_ui/repositories/notification_repository.dart';
import 'package:kaseapp_ui/repositories/market_supply_repositories.dart';
import 'package:kaseapp_ui/repositories/order_detail_repository.dart' as orderDetail;
import 'package:kaseapp_ui/repositories/receive_order_repository .dart';
import 'package:kaseapp_ui/repositories/receive_order_respond_repository.dart';

// Helpers & Routes 
import 'package:kaseapp_ui/utils/helper/api_helper.dart';
import 'package:kaseapp_ui/configs/routes/routes.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);  
  print(" Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notification
  const AndroidInitializationSettings initAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  Get.put(ApiHelper());
  Get.put(SecureStorage());
  Get.put(AuthRepository(Get.find<ApiHelper>(), Get.find<SecureStorage>()));
  Get.put(ProductRepository());
  Get.put(PreOrderRepository());
  Get.put(NotificationRepository(Get.find<ApiHelper>()));
  Get.put(MarketSupplyRepositories());
  Get.put(orderDetail.OrderDetailRepository());
  Get.put(ReceiveOrderRepository());
  Get.put(ReceiveOrderRespondRepository());

  Get.put(UserController());
  Get.put(AuthController());

  Get.lazyPut<ProductController>(
    () => ProductController(productRepo: Get.find<ProductRepository>()),
    fenix: true,
  );

  Get.lazyPut<PreOrderController>(
    () => PreOrderController(preOrderRepo: Get.find<PreOrderRepository>()),
    fenix: true,
  );

  Get.lazyPut<NotificationController>(
    () => NotificationController(Get.find<NotificationRepository>()),
    fenix: true,
  );

  Get.lazyPut<MarketsupplyController>(
    () => MarketsupplyController(
        marketSupplyRepositories: Get.find<MarketSupplyRepositories>()),
    fenix: true,
  );

  Get.lazyPut<ReceiveOrderController>(
    () => ReceiveOrderController(
      orderDetailRepository: Get.find<orderDetail.OrderDetailRepository>(),
      repo: Get.find<ReceiveOrderRepository>(),
      respondRepository: Get.find<ReceiveOrderRespondRepository>(),
    ),
    fenix: true,
  );

  Get.lazyPut<VendorPreOrderController>(
    () => VendorPreOrderController(repo: Get.find<ReceiveOrderRepository>()),
    fenix: true,
  );

  Get.lazyPut<ReceiveOrderRespondController>(
    () => ReceiveOrderRespondController(
        repository: Get.find<ReceiveOrderRespondRepository>()),
    fenix: true,
  );

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
      initialRoute: AppRoutes.splash, // Start with SplashScreen
      getPages: AppRoutes.generateRoutes,
    );
  }
}
