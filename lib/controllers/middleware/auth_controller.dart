import 'dart:convert';

import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/marketsupply_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/secure_storage.dart';
import 'package:kaseapp_ui/controllers/middleware/resettable_controller.dart';
import 'package:kaseapp_ui/controllers/notification_controller.dart';
import 'package:kaseapp_ui/controllers/order_detail_controller.dart';
import 'package:kaseapp_ui/controllers/pre_order_controller.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/controllers/receive_order_respond_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/user_model.dart';
import 'package:kaseapp_ui/repositories/market_supply_repositories.dart';
import 'package:kaseapp_ui/repositories/notification_repository.dart';
import 'package:kaseapp_ui/repositories/order_detail_repository.dart';
import 'package:kaseapp_ui/repositories/pre_order_repository.dart';
import 'package:kaseapp_ui/repositories/receive_order_respond_repository.dart';

class AuthController extends GetxController {
  final SecureStorage _storage = SecureStorage();
  final UserController _userController = Get.put(UserController());

  final RxBool _auth = false.obs;
  bool get auth => _auth.value;

  String get role => _userController.user.role;
  bool get isConsumer => role == 'consumer';
  bool get isFarmer => role == 'farmer';
  bool get isVendor => role == 'vendor';

  @override
  void onInit() {
    super.onInit();
    hydrateFromStorage();
  }

  Future<void> hydrateFromStorage() async {
    final token = await _storage.readData(key: 'token');
    final userJson = await _storage.readData(key: 'user');

    if (token.isNotEmpty && userJson.isNotEmpty) {
      try {
        _userController.setUser(UserModel.fromJson(json.decode(userJson)));
        _auth.value = true;
        _initAuthControllers();
      } catch (e) {
        await signOut();
      }
    } else {
      _auth.value = false;
      _userController.clearUser();
    }
  }

  Future<void> persistLogin({required String token, required UserModel user}) async {
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
    // 1. Clear token & user
    await _storage.writeData(key: 'token', value: '');
    await _storage.writeData(key: 'user', value: '');
    _auth.value = false;
    _userController.clearUser();

    // 2. Reset all auth-dependent controllers that implement Resettable
    _resetControllers();

    // 3. Redirect to login
    if (Get.currentRoute != '/login') {
      Get.offAllNamed('/login');
    }
  }

  /// Upgrade role and update storage
  Future<void> upgradeRole(String newRole) async {
    _userController.updateRole(newRole);
    await _storage.writeData(
        key: 'user', value: json.encode(_userController.user.toJson()));
  }

  /// Initialize auth-required controllers safely
  void _initAuthControllers() {
    if (!Get.isRegistered<NotificationController>()) {
      Get.put(NotificationController(Get.find<NotificationRepository>()));
    }
    if(!Get.isRegistered<PreOrderController>()){
      Get.put(PreOrderController(preOrderRepo: Get.find<PreOrderRepository>()));
    }
    if(!Get.isRegistered<MarketsupplyController>()){
      Get.put(MarketsupplyController(marketSupplyRepositories: Get.find<MarketSupplyRepositories>()));
    }
    if(!Get.isRegistered<ReceiveOrderController>()){
      Get.put(ReceiveOrderController(orderDetailRepository: Get.find<OrderDetailRepository>()));
    }
    if(!Get.isRegistered<ReceiveOrderRespondController>()){
      Get.put(ReceiveOrderRespondController(receiveOrderRespondRepository: Get.find<ReceiveOrderRespondRepository>()));
    }
  }
  /// Call reset() on all auth-dependent controllers implementing Resettable
  void _resetControllers() {
    final resettableControllers = [
      if (Get.isRegistered<PreOrderController>())
        Get.find<PreOrderController>() as ResettableController,
      if (Get.isRegistered<ProductController>())
        Get.find<ProductController>() as ResettableController,
      if (Get.isRegistered<NotificationController>())
        Get.find<NotificationController>() as ResettableController,
      if (Get.isRegistered<MarketsupplyController>()) Get.find<MarketSupplyRepositories>() as ResettableController,
      if (Get.isRegistered<ReceiveOrderController>()) Get.find<ReceiveOrderController>() as ResettableController,
      if (Get.isRegistered<ReceiveOrderRespondController>()) Get.find<ReceiveOrderRespondController>() as ResettableController,
    ];

    for (final controller in resettableControllers) {
      controller.reset();
    }
  }

  void setAuthenticated(bool value) {
    _auth.value = value;
  }
}
