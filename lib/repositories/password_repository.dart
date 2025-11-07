import 'dart:developer';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';

class PasswordRepository {
  final ApiHelper apiHelper;

  PasswordRepository(this.apiHelper);

  /// Step 1: Send reset code to email
  Future<dynamic> sendResetCode(String email) async {
    try {
      log('PasswordRepository: Sending reset code to $email...');
      final response = await apiHelper.postPublic(
        endpoint: '/auth/password/forgot',
        jsonBody: {'email': email},
      );
      log('PasswordRepository: API raw response: $response');
      return response;
    } catch (e) {
      log('PasswordRepository: Error sending reset code: $e');
      throw Exception('Failed to send reset code');
    }
  }

  /// Step 2: Verify reset code
  Future<dynamic> verifyResetCode(String email, String code) async {
    try {
      log('PasswordRepository: Verifying reset code for $email...');
      final response = await apiHelper.postPublic(
        endpoint: '/auth/password/verify-code',
        jsonBody: {'email': email, 'reset_code': code},
      );
      log('PasswordRepository: API raw response: $response');
      return response;
    } catch (e) {
      log('PasswordRepository: Error verifying reset code: $e');
      throw Exception('Failed to verify reset code');
    }
  }

  /// Step 3: Reset password
  Future<dynamic> resetPassword(
      String email, String code, String newPassword) async {
    try {
      log('PasswordRepository: Resetting password for $email...');
      final response = await apiHelper.postPublic(
        endpoint: '/auth/password/reset',
        jsonBody: {
          'email': email,
          'reset_code': code,
          'password': newPassword,
          'password_confirmation': newPassword,
        },
      );
      log('PasswordRepository: API raw response: $response');
      return response;
    } catch (e) {
      log('PasswordRepository: Error resetting password: $e');
      throw Exception('Failed to reset password');
    }
  }
}
