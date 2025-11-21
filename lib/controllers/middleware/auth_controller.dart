import 'dart:convert';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/secure_storage.dart';
import 'package:kaseapp_ui/controllers/notification_controller.dart';
import 'package:kaseapp_ui/controllers/order_detail_controller.dart';
import 'package:kaseapp_ui/controllers/pre_order_controller.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/controllers/receiveorder_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/controllers/vendorpreorder_controller.dart';
import 'package:kaseapp_ui/models/user_model.dart';
import 'package:kaseapp_ui/repositories/auth_repository.dart';
import 'package:kaseapp_ui/repositories/notification_repository.dart';
import 'package:kaseapp_ui/repositories/order_detail_repository.dart';
import 'package:kaseapp_ui/repositories/pre_order_repository.dart';
import 'package:kaseapp_ui/repositories/product_repository.dart';
import 'package:kaseapp_ui/repositories/receive_order_repository%20.dart';
import 'package:kaseapp_ui/repositories/receive_order_respond_repository.dart';

class AuthController extends GetxController {
  final SecureStorage _storage = SecureStorage();
  final UserController _userController = Get.put(UserController());
  String? _token;
  final RxBool _auth = false.obs;

  bool get auth => _auth.value;

  String get role => _userController.user.role;
  bool get isConsumer => role == 'consumer';
  bool get isFarmer => role == 'farmer';
  bool get isVendor => role == 'vendor';
  String? get token => _token;

  @override
  void onInit() {
    super.onInit();
    hydrateFromStorage();
  }

  Future<void> hydrateFromStorage() async {
    final token = await _storage.readData(key: 'token');
    final userJson = await _storage.readData(key: 'user');
    _token = token.isNotEmpty ? token : null;

    if (token.isNotEmpty && userJson.isNotEmpty) {
      try {
        _userController.setUser(UserModel.fromJson(json.decode(userJson)));

        final apiUserJson = await Get.find<AuthRepository>().getCurrentUser();
        final apiUser = UserModel.fromJson(apiUserJson);

        _userController.setUser(apiUser);
        await _storage.writeData(
            key: 'user', value: json.encode(apiUser.toJson()));

        _auth.value = true;
        _initAuthControllers();
      } catch (e) {
        _auth.value = false;
        _userController.clearUser();
        await signOut();
      }
    } else {
      _auth.value = false;
      _userController.clearUser();
    }
  }
//   Future<void> hydrateFromStorage() async {
//   final token = await _storage.readData(key: 'token');
//   final userJson = await _storage.readData(key: 'user');
//   _token = token.isNotEmpty ? token : null;

//   if (token.isNotEmpty && userJson.isNotEmpty) {
//     try {
//       _userController.setUser(UserModel.fromJson(json.decode(userJson)));
//       _auth.value = true;
//       _initAuthControllers();

//       _refreshUserInBackground();
      
//     } catch (e) {
//       _auth.value = false;
//       _userController.clearUser();
//       await signOut();
//     }
//   } else {
//     _auth.value = false;
//     _userController.clearUser();
//   }
// }

// Future<void> _refreshUserInBackground() async {
//   try {
//     final apiUserJson = await Get.find<AuthRepository>().getCurrentUser();
//     final apiUser = UserModel.fromJson(apiUserJson);
    
//     _userController.setUser(apiUser);
//     await _storage.writeData(
//         key: 'user', value: json.encode(apiUser.toJson()));
//   } catch (e) {
//     print('Background refresh failed: $e');
//   }
// }

  Future<void> persistLogin(
      {required String token, required UserModel user}) async {
    _token = token;
    await _storage.writeData(key: 'token', value: token);
    await _storage.writeData(key: 'user', value: json.encode(user.toJson()));
    _userController.setUser(user);
    _auth.value = true;

    _initAuthControllers();
  }

  Future<void> persistUser(UserModel user) async {
    await _storage.writeData(key: 'user', value: json.encode(user.toJson()));
    _userController.setUser(user);
  }

  Future<void> signOut() async {
    _token = null;
    await _storage.writeData(key: 'token', value: '');
    await _storage.writeData(key: 'user', value: '');
    _auth.value = false;
    _userController.clearUser();
    _resetControllers();
    if (Get.currentRoute != '/login') {
      Get.offAllNamed('/login');
    }
  }

  Future<void> upgradeRole(String newRole) async {
    _userController.updateRole(newRole);
    await _storage.writeData(
        key: 'user', value: json.encode(_userController.user.toJson()));
  }

  void _initAuthControllers() {
    if(!Get.isRegistered<NotificationController>()) {
      Get.put(NotificationController(Get.find<NotificationRepository>()));
    }
    if (!Get.isRegistered<ProductController>()) {
      Get.put(ProductController(productRepo: Get.find<ProductRepository>()));
    }

    if (isVendor) {
      if (!Get.isRegistered<PreOrderController>()) {
        Get.put(
            PreOrderController(preOrderRepo: Get.find<PreOrderRepository>()));
      }
      if (!Get.isRegistered<VendorPreOrderController>()) {
        Get.put(
            VendorPreOrderController(repo: Get.find<ReceiveOrderRepository>()));
      }
      if (!Get.isRegistered<ReceiveOrderController>()) {
        Get.put(ReceiveOrderController(
          orderDetailRepository: Get.find<OrderDetailRepository>(),
          repo: Get.find<ReceiveOrderRepository>(),
          respondRepository: Get.find<ReceiveOrderRespondRepository>(),
        ));
      }
    }

    if (isFarmer) {
      if (!Get.isRegistered<OrderDetailController>()) {
        Get.put(
            OrderDetailController(orderDetailRepository: Get.find<OrderDetailRepository>()));
      }
      if (!Get.isRegistered<VendorPreOrderController>()) {
        Get.put(
            VendorPreOrderController(repo: Get.find<ReceiveOrderRepository>()));
      }
      if (!Get.isRegistered<ReceiveOrderController>()) {
        Get.put(ReceiveOrderController(
          orderDetailRepository: Get.find<OrderDetailRepository>(),
          repo: Get.find<ReceiveOrderRepository>(),
          respondRepository: Get.find<ReceiveOrderRespondRepository>(),
        ));
      }
    }
  }

  void _resetControllers() {
    if (Get.isRegistered<PreOrderController>()) Get.delete<PreOrderController>();
    if (Get.isRegistered<ProductController>()) Get.delete<ProductController>();
    if (Get.isRegistered<NotificationController>())
      Get.delete<NotificationController>();
    if (Get.isRegistered<VendorPreOrderController>())
      Get.delete<VendorPreOrderController>();
    if (Get.isRegistered<ReceiveOrderController>()) Get.delete<ReceiveOrderController>();
  }

  void setAuthenticated(bool value) {
    _auth.value = value;
  }
}