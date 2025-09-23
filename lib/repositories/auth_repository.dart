import 'dart:developer';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';
import 'package:kaseapp_ui/controllers/middleware/secure_storage.dart';
import 'package:kaseapp_ui/models/user_model.dart';

class AuthRepository {
  final ApiHelper apiHelper;
  final SecureStorage storage;
  
  AuthRepository(this.apiHelper, this.storage);

  /// Call /auth/me to check token validity and return UserModel
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      log('AuthRepository: Fetching current user...');
      final response = await apiHelper.get(endpoint: '/auth/me');
      log('AuthRepository: API raw response: $response');

      if (response['success'] == true && response['user'] != null) {
        final userJson = response['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userJson);
        log('AuthRepository: UserModel created: ${user.toJson()}');
        return user.toJson();
      } else {
        throw Exception("Unauthenticated");
      }
    } catch (e) {
      log('AuthRepository: Error fetching current user: $e');
      throw Exception("Unauthenticated");
    }
  }

  Future<void> logout() async {
    try {
      log('AuthRepository: Logging out user...');
      await apiHelper.post(endpoint: '/auth/logout', jsonBody: {});
      log('AuthRepository: Server logout successful');
    } catch (e) {
      log('AuthRepository: Server logout failed (ignored): $e');
    }
  }
}
