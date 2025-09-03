import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/Routes/routes.dart';
import '/controllers/middleware/auth_controller.dart';
import '../middleware/secure_storage.dart';
import '/controllers/user_controller.dart';
import '/models/user_model.dart';

class LogoutController extends GetxController {
  final AuthController authController = Get.find();
  final UserController userController = Get.find();
  // final GoogleSignIn googleSignIn = GoogleSignIn();
  final secureStorage = SecureStorage();

  void logout() async {
    if (authController.auth) {
      await secureStorage.delete(key: 'token');
      authController.setAuthenticated(false);
      userController.setUser(UserModel());
      Get.toNamed(AppRoutes.mainView);
    }
  }

}
