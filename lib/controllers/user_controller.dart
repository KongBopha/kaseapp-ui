import 'dart:io';
import 'package:get/get.dart';
import 'package:kaseapp_ui/models/farm_model.dart';
import 'package:kaseapp_ui/models/user_model.dart';
import 'package:kaseapp_ui/models/vendor_model.dart';
import 'package:kaseapp_ui/repositories/auth_repository.dart';
import 'package:kaseapp_ui/repositories/user_repository.dart';
import 'package:kaseapp_ui/utils/dialogs/dialogs.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  final Rx<UserModel> _user = UserModel(role: 'consumer').obs;
  final Rx<UserModel?> otherUser = Rx<UserModel?>(null); // other profile
  RxBool loading = false.obs;

  UserModel get user => _user.value;
  Rx<UserModel> get userRx => _user;

  /// Set user and print debug
  void setUser(UserModel userModel) {
    _user.value = userModel;
    print("[UserController] setUser: ${userModel.toJson()}");
  }

  void clearUser() {
    _user.value = UserModel(role: 'consumer');
    print("[UserController] clearUser -> consumer");
  }

  /// Update role locally and persist storage
  Future<void> updateRole(String newRole) async {
    _user.update((val) {
      if (val != null) val.role = newRole;
    });
    print("[UserController] updateRole: $newRole");
    await Get.find<AuthController>().persistUser(_user.value);
  }

  /// Update profile (image example)
  Future<void> updateProfile(File image) async {
    loading.value = true;
    print("[UserController] updateProfile called");
    final response = await _userRepository.updateProfile(image);

    response.fold(
      (failure) {
        loading.value = false;
        print("[UserController] updateProfile failed: ${failure.message}");
        final context = Get.context;
        ErrorDialog.showErrorDialog(
          context!,
          title: 'Update profile error',
          content: '${failure.message}'.tr,
        );
      },
      (success) async {
        loading.value = false;
        final updatedUser = UserModel.fromJson(success);
        _user.value = updatedUser;
        print("[UserController] updateProfile success: ${updatedUser.toJson()}");

        // persist updated user
        await Get.find<AuthController>().persistUser(updatedUser);
      },
    );
  }

  /// Upgrade to Farmer
  Future<void> upgradeToFarmer({
    required String name,
    String? address,
    String? about,
    String? cover,
    String? logo,
  }) async {
    loading.value = true;
    print("[UserController] upgradeToFarmer called: $name");

    final response = await _userRepository.upgradeToFarmer(
      name: name,
      address: address,
      about: about,
      cover: cover,
      logo: logo,
    );

    response.fold(
      (failure) {
        loading.value = false;
        print("[UserController] upgradeToFarmer failed: ${failure.message}");
        final context = Get.context;
        ErrorDialog.showErrorDialog(
          context!,
          title: 'Upgrade to farmer error',
          content: '${failure.message}'.tr,
        );
      },
      (success) async {
        loading.value = false;
        final updatedUserJson = success as Map<String, dynamic>;
        final updatedUser = UserModel.fromJson(updatedUserJson);

        if (updatedUserJson['farm'] != null) {
          updatedUser.farm = FarmModel.fromJson(updatedUserJson['farm']);
        } else if (updatedUser.farm == null) {
          updatedUser.role = 'farmer';
        }

        _user.value = updatedUser;
        print("[UserController] upgradeToFarmer success: ${updatedUser.toJson()}");

        await Get.find<AuthController>().persistUser(updatedUser);
      },
    );
  }

  /// Upgrade to Vendor
  Future<void> upgradeToVendor({
    required String name,
    required String address,
    required String description,
    required String vendorType,
  }) async {
    loading.value = true;
    print("[UserController] upgradeToVendor called: $name");

    final response = await _userRepository.upgradeToVendor(
      name: name,
      address: address,
      description: description,
      vendorType: vendorType,
    );

    response.fold(
      (failure) {
        loading.value = false;
        print("[UserController] upgradeToVendor failed: ${failure.message}");
        final context = Get.context;
        ErrorDialog.showErrorDialog(
          context!,
          title: 'Upgrade to vendor error',
          content: '${failure.message}'.tr,
        );
      },
      (success) async {
        loading.value = false;
        final updatedUserJson = success as Map<String, dynamic>;
        final updatedUser = UserModel.fromJson(updatedUserJson);

        if (updatedUserJson['vendor'] != null) {
          updatedUser.vendor = VendorModel.fromJson(updatedUserJson['vendor']);
        } else {
          updatedUser.role = 'vendor';
        }

        _user.value = updatedUser;
        print("[UserController] upgradeToVendor success: ${updatedUser.toJson()}");

        await Get.find<AuthController>().persistUser(updatedUser);
      },
    );
  }
  Future<void> fetchOtherUserProfile(int userId) async {
    loading.value = true;
    try {
      final profile = await _userRepository.viewProfile(userId: userId);
      otherUser.value = profile;

      if (profile != null) {
        print('Fetched user: ${profile.firstName}');
        if (profile.vendor != null) print('Vendor: ${profile.vendor?.companyName}');
        if (profile.farm != null) print('Farm: ${profile.farm?.name}');
      }
    } finally {
      loading.value = false;
    }
  }
}
