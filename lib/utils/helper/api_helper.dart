
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
  // Helpers
  // -----------------------------
  bool _isHtmlResponse(dynamic data) {
    if (data is String) {
      return data.trimLeft().startsWith('<!DOCTYPE html') || data.contains('<html');
    }
    return false;
  }

  Map<String, String> _headers(String? token) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  void _handleUnauthorized(AResponse response) {
    if (response.statusCode == 401 || _isHtmlResponse(response.data)) {
      Get.find<AuthController>().signOut();
      throw ServerFailure(message: 'Session expired. Please log in again.');
    }
  }

  // -----------------------------
  // PRIVATE GET
  // -----------------------------
  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final token = await _secureStorage.readData(key: 'token');
      final response = await _aHttpClient.getAPI( 
        Constants.baseUrl + endpoint,
        queryParameters: queryParameters,
        options: AOptions(headers: _headers(token)),
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerFailure(message: 'Invalid response from server');
    } catch (e) {
      rethrow;
    }
  }

  // -----------------------------
  // PRIVATE POST
  // -----------------------------
  Future<dynamic> post({
    required String endpoint,
    required Map<String, dynamic> jsonBody,
    bool isFormData = false,
  }) async {
    final token = await _secureStorage.readData(key: 'token');
    final response = await _aHttpClient.postAPI(
      Constants.baseUrl + endpoint,
      body: isFormData ? FormData.fromMap(jsonBody) : jsonBody,
      options: AOptions(headers: _headers(token)),
    );

    _handleUnauthorized(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    }

    // throw ServerFailure(
    //   message: response.message.isNotEmpty
    //       ? response.message
    //       : "Unexpected error occurred" ?? '',
    // );
  }


  // -----------------------------q
  // PRIVATE PUT
  // -----------------------------
  Future<dynamic> update({
    required String endpoint,
    required Map<String, dynamic> jsonBody,
  }) async {
    try {
      final token = await _secureStorage.readData(key: 'token');
      final response = await _aHttpClient.putAPI(
        Constants.baseUrl + endpoint,
        body: jsonBody,
        options: AOptions(headers: _headers(token)),
      );

      _handleUnauthorized(response);

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // -----------------------------
  // PRIVATE DELETE
  // -----------------------------
  Future<dynamic> delete({
    required String endpoint,
    required Map<String, dynamic> queryParameters,
  }) async {
    try {
      final token = await _secureStorage.readData(key: 'token');
      final response = await _aHttpClient.deleteAPI(
        Constants.baseUrl + endpoint,
        body: queryParameters,
        options: AOptions(headers: _headers(token)),
      );

      _handleUnauthorized(response);

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
 Future<dynamic> updateMultipart({
  required String endpoint,
  required Map<String, dynamic> jsonBody,
  File? image,
  String imageParam = 'profile_url',
}) async {
  try {
    final token = await _secureStorage.readData(key: 'token');

    if (image != null) {
      final response = await _aHttpClient.postMultipartAPI(
        Constants.baseUrl + endpoint,
        body: jsonBody,
        image: image,
        imageParam: imageParam,
        options: AOptions(headers: _headers(token)),
      );

      _handleUnauthorized(response);

      return response.data;
    } else {
      final response = await _aHttpClient.postAPI(
        Constants.baseUrl + endpoint,
        body: jsonBody,
        options: AOptions(headers: _headers(token)),
      );

      _handleUnauthorized(response);

      return response.data;
    }
  } catch (e) {
    rethrow;
  }
}
  // -----------------------------
  // MULTIPART POST
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

      final response = await _aHttpClient.postMultipartAPI(
        Constants.baseUrl + endPoint,
        body: jsonBody,
        image: image,
        imageParam: imageParam,
        options: AOptions(headers: _headers(token)),
      );

      _handleUnauthorized(response);

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // -----------------------------
  // PUBLIC ROUTES
  // -----------------------------
  Future<dynamic> getPublic({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _aHttpClient.getAPI(
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
      final response = await _aHttpClient.postAPI(
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
