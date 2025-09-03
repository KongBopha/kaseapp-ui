import 'dart:io';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/secure_storage.dart';
import 'package:kaseapp_ui/utils/error/failure.dart';
import 'package:kaseapp_ui/utils/helper/a_http_client_ref.dart';
import 'package:kaseapp_ui/utils/http/a_http.dart';
import '../constants/base_api.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class ApiHelper {
  final _aHttpClient = AHttpClientRef();
  final SecureStorage _secureStorage = SecureStorage();

  // -----------------------------
  //        TOKEN REFRESH
  // -----------------------------
  Future<bool> _refreshToken() async {
    try {
      final String oldToken = await _secureStorage.readData(key: 'token');
      if (oldToken.isEmpty) return false;

      final AResponse response = await _aHttpClient.postAPI(
        Constants.baseUrl + '/auth/refresh',
        body: {},
        options: AOptions(headers: {
          'Authorization': 'Bearer $oldToken',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        final newToken = response.data['access_token'];
        if (newToken != null) {
          await _secureStorage.writeData(key: 'token', value: newToken);
          return true;
        }
      }
    } catch (e) {
      print('Token refresh failed: $e');
    }
    return false;
  }

  // -----------------------------
  //        PRIVATE GET
  // -----------------------------
  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final token = await _secureStorage.readData(key: 'token');
      final AResponse response = await _aHttpClient.getAPI(
        Constants.baseUrl + endpoint,
        queryParameters: queryParameters,
        options: AOptions(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return await get(endpoint: endpoint, queryParameters: queryParameters);
        } else {
          Get.find<AuthController>().signOut();
          throw ServerFailure(message: 'Session expired. Please log in again.');
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }

      throw ServerFailure(message: 'Invalid response from server');
    } catch (e) {
      rethrow;
    }
  }

  // -----------------------------
  //        PRIVATE POST
  // -----------------------------
  Future<dynamic> post({
    required String endpoint,
    required Map<String, dynamic> jsonBody,
    bool isFormData = false,
  }) async {
    try {
      final token = await _secureStorage.readData(key: 'token');
      final AResponse response = await _aHttpClient.postAPI(
        Constants.baseUrl + endpoint,
        body: isFormData ? FormData.fromMap(jsonBody) : jsonBody,
        options: AOptions(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return await post(endpoint: endpoint, jsonBody: jsonBody, isFormData: isFormData);
        } else {
          Get.find<AuthController>().signOut();
          throw ServerFailure(message: 'Session expired. Please log in again.');
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }

      return {'success': false, 'message': 'Invalid response from server'};
    } catch (e) {
      rethrow;
    }
  }

  // -----------------------------
  //        PRIVATE PUT
  // -----------------------------
  Future<dynamic> update({
    required String endpoint,
    required Map<String, dynamic> jsonBody,
  }) async {
    try {
      final token = await _secureStorage.readData(key: 'token');
      final AResponse response = await _aHttpClient.putAPI(
        Constants.baseUrl + endpoint,
        body: jsonBody,
        options: AOptions(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return await update(endpoint: endpoint, jsonBody: jsonBody);
        } else {
          Get.find<AuthController>().signOut();
          throw ServerFailure(message: 'Session expired. Please log in again.');
        }
      }

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // -----------------------------
  //        PRIVATE DELETE
  // -----------------------------
  Future<dynamic> delete({
    required String endpoint,
    required Map<String, dynamic> queryParameters,
  }) async {
    try {
      final token = await _secureStorage.readData(key: 'token');
      final AResponse response = await _aHttpClient.deleteAPI(
        Constants.baseUrl + endpoint,
        body: queryParameters,
        options: AOptions(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return await delete(endpoint: endpoint, queryParameters: queryParameters);
        } else {
          Get.find<AuthController>().signOut();
          throw ServerFailure(message: 'Session expired. Please log in again.');
        }
      }

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // -----------------------------
  //        MULTIPART POST
  // -----------------------------
  Future<dynamic> postMultipart({
    required String endPoint,
    required Map<String, dynamic> jsonBody,
    required File image,
    required String imageParam,
  }) async {
    try {
      final token = await _secureStorage.readData(key: 'token');
      final mimeType = image.path.split('.').last;

      jsonBody[imageParam] = await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
        contentType: DioMediaType('image', mimeType),
      );

      final AResponse response = await _aHttpClient.postMultipartAPI(
        Constants.baseUrl + endPoint,
        body: jsonBody,
        image: image,
        imageParam: imageParam,
        options: AOptions(headers: {
          'Authorization': 'Bearer $token',
          'Content-Language': Get.locale!.languageCode,
        }),
      );

      if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return await postMultipart(
            endPoint: endPoint,
            jsonBody: jsonBody,
            image: image,
            imageParam: imageParam,
          );
        } else {
          Get.find<AuthController>().signOut();
          throw ServerFailure(message: 'Session expired. Please log in again.');
        }
      }

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // -----------------------------
  //        PUBLIC ROUTES
  // -----------------------------
  Future<dynamic> getPublic({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final AResponse response = await _aHttpClient.getAPI(
        Constants.baseUrl + endpoint,
        queryParameters: queryParameters,
        options: AOptions(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }

      throw ServerFailure(message: 'Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postPublic({
    required String endpoint,
    required Map<String, dynamic> jsonBody,
    bool isFormData = false,
  }) async {
    try {
      final AResponse response = await _aHttpClient.postAPI(
        Constants.baseUrl + endpoint,
        body: isFormData ? FormData.fromMap(jsonBody) : jsonBody,
        options: AOptions(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }

      return {'success': false, 'message': 'Invalid response from server'};
    } catch (e) {
      rethrow;
    }
  }
}