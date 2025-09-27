// import 'package:dio/dio.dart';
// import 'package:get/get.dart' hide Response;
// import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
// import 'package:kaseapp_ui/controllers/middleware/secure_storage.dart';
// import 'package:kaseapp_ui/utils/constants/base_api.dart';

// class TokenInterceptor extends Interceptor {
//   final SecureStorage storage;
//   final Dio dio;

//   bool _isRefreshing = false;
//   final List<Function()> _retryQueue = [];

//   TokenInterceptor({required this.storage, required this.dio});

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     final token = await storage.getAccessToken();
//     if (token.isNotEmpty) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//     handler.next(options);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401 &&
//         !err.requestOptions.path.contains('/auth/refresh')) {
//       final refreshToken = await storage.getRefreshToken();

//       if (refreshToken.isEmpty) {
//         final authController = Get.find<AuthController>();
//         authController.signOut();
//         return handler.next(err);
//       }

//       if (_isRefreshing) {
//         // Queue request until refresh finishes
//         _retryQueue.add(() async {
//           final opts = err.requestOptions;
//           opts.headers['Authorization'] =
//               'Bearer ${await storage.getAccessToken()}';
//           try {
//             final response = await dio.fetch(opts);
//             handler.resolve(response);
//           } catch (_) {
//             handler.next(err);
//           }
//         });
//         return;
//       }

//       _isRefreshing = true;

//       try {
//         // Refresh access token
//         final newTokens = await _refreshAccessToken(refreshToken);

//         // Save both tokens with expiry
//         await storage.saveTokens(
//           newTokens['access_token'],
//           newTokens['refresh_token'],
//           newTokens['access_token_expires_at'],
//           newTokens['refresh_token_expires_at'],
//         );

//         // Retry original request
//         final opts = err.requestOptions;
//         opts.headers['Authorization'] = 'Bearer ${newTokens['access_token']}';
//         final response = await dio.fetch(opts);

//         // Retry queued requests
//         for (var retry in _retryQueue) {
//           retry();
//         }
//         _retryQueue.clear();

//         handler.resolve(response);
//       } catch (_) {
//         final authController = Get.find<AuthController>();
//         authController.signOut();
//         handler.next(err);
//       } finally {
//         _isRefreshing = false;
//       }
//     } else {
//       handler.next(err);
//     }
//   }

//   Future<Map<String, dynamic>> _refreshAccessToken(String refreshToken) async {
//     final response = await dio.post(
//       '${Constants.baseUrl}/auth/refresh',
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $refreshToken',
//           'Content-Type': 'application/json'
//         },
//       ),
//     );

//     if (response.statusCode == 200 && response.data != null) {
//       return Map<String, dynamic>.from(response.data);
//     }
//     throw Exception('Failed to refresh token');
//   }
// }
