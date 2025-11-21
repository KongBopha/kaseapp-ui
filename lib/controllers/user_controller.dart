import 'dart:io';
import 'package:get/get.dart';
import 'package:kaseapp_ui/models/farm_model.dart';
import 'package:kaseapp_ui/models/user_model.dart';
import 'package:kaseapp_ui/models/vendor_model.dart';
import 'package:kaseapp_ui/repositories/user_repository.dart';
import 'package:kaseapp_ui/utils/dialogs/dialogs.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/utils/error/failure.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  final Rx<UserModel> _user = UserModel(role: 'consumer').obs;
  final Rx<UserModel?> otherUser = Rx<UserModel?>(null); // for viewing other profiles
  RxBool loading = false.obs;

  UserModel get user => _user.value;
  Rx<UserModel> get userRx => _user;

  void setUser(UserModel userModel) {
    _user.value = userModel;
    print("[UserController] setUser: ${userModel.toJson()}");
  }

  void clearUser() {
    _user.value = UserModel(role: 'consumer');
    print("[UserController] clearUser -> consumer");
  }

  Future<void> updateRole(String newRole) async {
    _user.update((val) {
      if (val != null) val.role = newRole;
    });
    print("[UserController] updateRole: $newRole");
    await Get.find<AuthController>().persistUser(_user.value);
  }

  /// Update profile and update local user immediately
Future<void> updateProfile({
  File? image,
  String? firstName,
  String? lastName,
  String? phone,
}) async {
  loading.value = true;

  final result = await _userRepository.updateProfile(
    image: image,
    firstName: firstName,
    lastName: lastName,
    phone: phone,
  );

  result.fold(
    (Failure f) {
      print("Error: ${f.message}");
    },
    (data) {
      print("Profile updated successfully");

      // Update local GetX user values after backend success
      _user.update((val) {
        if (val != null) {
          if (firstName != null) val.firstName = firstName;
          if (lastName != null) val.lastName = lastName;
          if (phone != null) val.phone = phone;
          if (data["profile_url"] != null) val.profileUrl = data["profile_url"];
        }
      });

      Get.find<AuthController>().persistUser(_user.value);

      print("[UserController] Local user updated: ${_user.value.toJson()}");
    },
  );

  loading.value = false;
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
   Future<void> updateVendorProfile({
    String? name,
    String? vendorType,
    String? address,
    String? about,
    File? logo,
  }) async {
    loading.value = true;

    final result = await _userRepository.updateVendorProfile(
      name: name,
      vendorType: vendorType,
      address: address,
      about: about,
      logo: logo,
    );

    result.fold(
      (failure) {
        loading.value = false;
        ErrorDialog.showErrorDialog(
          Get.context!,
          title: 'Update vendor profile failed',
          content: failure.message,
        );
      },
      (success) {
        loading.value = false;

        _user.value = _user.value.copyWith(
          vendor: success['vendor'] != null 
              ? VendorModel.fromJson(success['vendor'])
              : null,
        );
      },
    );
  }

  //  Update Farm Profile
  Future<void> updateFarmProfile({
    String? name,
    String? address,
    String? description,
    File? logo,
    File? cover,
  }) async {
    loading.value = true;

    final result = await _userRepository.updateFarmProfile(
      name: name,
      address: address,
      description: description,
      logo: logo,
      cover: cover,
    );

    result.fold(
      (failure) {
        loading.value = false;
        ErrorDialog.showErrorDialog(
          Get.context!,
          title: 'Update farm profile failed',
          content: failure.message,
        );
      },
      (success) {
        loading.value = false;

      _user.value = _user.value.copyWith(
        farm: success['farm'] != null 
            ? FarmModel.fromJson(success['farm'])
            : null,
      );

      },
    );
  }
}
