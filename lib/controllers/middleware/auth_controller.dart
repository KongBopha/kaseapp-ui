// lib/controllers/middleware/auth_controller.dart
import 'dart:convert';

import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/secure_storage.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/user_model.dart';

class AuthController extends GetxController {
  final SecureStorage _storage = SecureStorage();
   
  final UserController _userController = Get.put(UserController());

  final RxBool _auth = false.obs;
  bool get auth => _auth.value;

  /// role helpers (read from the UserController's current user)
  String get role => _userController.user.role;
  bool get isConsumer => role == 'consumer';
  bool get isFarmer => role == 'farmer';
  bool get isVendor => role == 'vendor';

  @override
  void onInit() {
    super.onInit();
    _hydrateFromStorage();
  }

  /// Read token + user from secure storage and hydrate runtime state
  Future<void> _hydrateFromStorage() async {
    final token = await _storage.readData(key: 'token');
    final userJson = await _storage.readData(key: 'user');

    if (token.isNotEmpty && userJson.isNotEmpty) {
      try {
        final mapUser = json.decode(userJson);
        final userModel = UserModel.fromJson(mapUser);
        _userController.setUser(userModel);
        _auth.value = true;
      } catch (e) {
        await signOut();
      }
    } else {
      _auth.value = false;
    }
  }

  /// Called right after a successful login/register: staore token + user
  Future<void> persistLogin({required String token, required UserModel user}) async {
    await _storage.writeData(key: 'token', value: token);
    await _storage.writeData(key: 'user', value: json.encode(user.toJson()));
    _userController.setUser(user);
    _auth.value = true;
  }

  /// Keep user storage in sync when profile/role changes
  Future<void> persistUser(UserModel user) async {
    await _storage.writeData(key: 'user', value: json.encode(user.toJson()));
    _userController.setUser(user);
  }

  /// Sign out: clear storage and reset memory
  Future<void> signOut() async {
    await _storage.writeData(key: 'token', value: '');
    await _storage.writeData(key: 'user', value: '');
    _auth.value = false;
    _userController.clearUser();
  }
  Future<void> upgradeRole(String newRole) async {
  _userController.updateRole(newRole);
  await persistUser(_userController.user); // updates storage
}

  void setAuthenticated(bool value) {
    _auth.value = value;
  }
}
