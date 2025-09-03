import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/auth/logout_controller.dart';
import 'package:kaseapp_ui/controllers/auth/register_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/notification_controller.dart';
import 'package:kaseapp_ui/repositories/notification_repository.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';


class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<LogoutController>(() => LogoutController());
    Get.lazyPut(() => ApiHelper());

  }
}
