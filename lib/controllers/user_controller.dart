import 'dart:io';
import 'package:get/get.dart';
import 'package:kaseapp_ui/models/farm_model.dart';
import 'package:kaseapp_ui/models/user_model.dart';
import 'package:kaseapp_ui/models/vendor_model.dart';
import 'package:kaseapp_ui/repositories/user_repository.dart';
import 'package:kaseapp_ui/utils/dialogs/dialogs.dart';
import 'package:kaseapp_ui/utils/error/failure.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  RxBool loading = false.obs;
  final Rx<UserModel> _user = UserModel(role: 'consumer').obs;
  final Rx<UserModel> _owner = UserModel().obs;

  UserModel get user => _user.value;
  UserModel get owner => _owner.value;
  bool get isLoading => loading.value;

  void setUser(UserModel userModel) {
    _user.value = userModel;
  }

  void clearUser() {
    _user.value = UserModel(role: 'consumer');
  }

  /// Fetch other user's detail by id (owner)
  Future<void> getUserById(int id) async {
    loading.value = true;
    final response = await _userRepository.getUser(id);

    response.fold(
      (failure) {
        loading.value = false;
        final context = Get.context;
        if (failure is NoInternetConnection) {
          ErrorDialog.showErrorDialog(
            context!,
            title: ' ${'Internet Connection'.tr}',
            content: ' ${'No Internet Connection'.tr}',
          );
        } else {
          Get.snackbar('Error', failure.message);
        }
      },
      (response) {
        loading.value = false;
        final data = response['data'];
        _owner.value = UserModel.fromJson(data);
      },
    );
  }

  /// Update profile (image example)
  Future<void> updateProfile(File image) async {
    loading.value = true;
    final response = await _userRepository.updateProfile(image);

    response.fold(
      (failure) {
        loading.value = false;
        final context = Get.context;
        if (failure is NoInternetConnection) {
          ErrorDialog.showErrorDialog(
            context!,
            title: ' ${'Internet Connection'.tr}',
            content: ' ${'No Internet Connection'.tr}',
          );
        } else {
          ErrorDialog.showErrorDialog(
            context!,
            title: 'Update profile error',
            content: ' ${failure.message}'.tr,
          );
        }
      },
      (success) async {
        loading.value = false;
        final updatedUser = UserModel.fromJson(success);
        _user.value = updatedUser;

        // update persistent storage via AuthController
        await Get.find<AuthController>().persistUser(updatedUser);
      },
    );
  }
  // fetch user info


  /// Upgrade the current authenticated user to Farmer.
  Future<void> upgradeToFarmer({
    required String name,
    required String? address,
    required String? about,
    required String? cover,
    required String? logo,

  }) async {
    loading.value = true;
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
        final context = Get.context;
        if (failure is NoInternetConnection) {
          ErrorDialog.showErrorDialog(
            context!,
            title: ' ${'Internet Connection'.tr}',
            content: ' ${'No Internet Connection'.tr}',
          );
        } else {
          ErrorDialog.showErrorDialog(
            context!,
            title: 'Upgrade to farmer error',
            content: ' ${failure.message}'.tr,
          );
        }
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

        // persist changed user in secure storage via AuthController
        await Get.find<AuthController>().persistUser(updatedUser);
      },
    );
  }

  /// Upgrade to vendor 
  Future<void> upgradeToVendor({
    required String name,
    required String address,
    required String description,
    required String vendorType,
  }) async {
    loading.value = true;
    final response = await _userRepository.upgradeToVendor(
      name: name,
      address: address,
      description: description,
      vendorType: vendorType,
    );

    response.fold(
      (failure) {
        loading.value = false;
        final context = Get.context;
        if (failure is NoInternetConnection) {
          ErrorDialog.showErrorDialog(
            context!,
            title: ' ${'Internet Connection'.tr}',
            content: ' ${'No Internet Connection'.tr}',
          );
        } else {
          ErrorDialog.showErrorDialog(
            context!,
            title: 'Upgrade to vendor error',
            content: ' ${failure.message}'.tr,
          );
        }
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
        await Get.find<AuthController>().persistUser(updatedUser);
      },
    );
  }

  /// Update role locally and persist storage
  Future<void> updateRole(String newRole) async {
    _user.update((val) {
      if (val != null) val.role = newRole;
    });

    await Get.find<AuthController>().persistUser(_user.value);
  }
}
