import 'package:get/get.dart';
import 'package:kaseapp_ui/repositories/password_repository.dart';
import 'package:kaseapp_ui/utils/dialogs/dialogs.dart';

class PasswordController extends GetxController {
  final PasswordRepository _passwordRepository ;

  PasswordController(this._passwordRepository); 

  RxBool loading = false.obs;
  RxBool codeSent = false.obs;
  RxBool codeVerified = false.obs;

  String? email;  
  String? resetCode; 

  /// Step 1: Send reset code to user's email
 Future<void> sendResetCode(String userEmail) async {
  loading.value = true;
  try {
    final response = await _passwordRepository.sendResetCode(userEmail);
    
    if (response['success'] == true) {
      codeSent.value = true;
      email = userEmail;
      Get.snackbar('Success', 'Reset code sent to $userEmail');
    } else {
      ErrorDialog.showErrorDialog(
        Get.context!,
        title: 'Error',
        content: response['message'] ?? 'Something went wrong',
      );
    }
  } catch (e) {
    ErrorDialog.showErrorDialog(Get.context!,
        title: 'Error', content: e.toString());
  } finally {
    loading.value = false;
  }
}


  /// Step 2: Verify OTP code
Future<void> verifyCode(String code) async {
  if (email == null) return;
  loading.value = true;

  try {
    final response = await _passwordRepository.verifyResetCode(email!, code);

    if (response['success'] == true) {
      codeVerified.value = true;
      resetCode = code;
      Get.snackbar('Success', response['message'] ?? 'Code verified.');
    } else {
      ErrorDialog.showErrorDialog(
        Get.context!,
        title: 'Error',
        content: response['message'] ?? 'Failed to verify code',
      );
    }
  } catch (e) {
    ErrorDialog.showErrorDialog(
      Get.context!,
      title: 'Error',
      content: e.toString(),
    );
  } finally {
    loading.value = false;
  }
}


  /// Step 3: Reset password
Future<void> resetPassword(String newPassword, String confirmPassword) async {
  if (email == null || resetCode == null) return;

  if (newPassword != confirmPassword) {
    ErrorDialog.showErrorDialog(
      Get.context!,
      title: 'Error',
      content: 'Passwords do not match',
    );
    return;
  }

  loading.value = true;
  try {
    final response =
        await _passwordRepository.resetPassword(email!, resetCode!, newPassword);

    if (response['success'] == true) {
      Get.snackbar('Success', response['message'] ?? 'Password reset successfully.');
      Get.offAllNamed('/login'); // redirect to login
    } else {
      ErrorDialog.showErrorDialog(
        Get.context!,
        title: 'Error',
        content: response['message'] ?? 'Failed to reset password',
      );
    }
  } catch (e) {
    ErrorDialog.showErrorDialog(
      Get.context!,
      title: 'Error',
      content: e.toString(),
    );
  } finally {
    loading.value = false;
  }
}

}
