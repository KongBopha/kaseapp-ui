import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kaseapp_ui/utils/error/failure.dart';
import 'package:kaseapp_ui/utils/http/a_http_client.dart';
import 'package:kaseapp_ui/utils/http/a_options.dart';
import 'package:kaseapp_ui/utils/http/a_response.dart';

class AHttpClientRef implements AHttpClient {
  final Dio _dio = Dio(BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: Duration(milliseconds: 60 * 400),
    receiveTimeout: Duration(milliseconds: 60 * 400),
  ));

  // ---------------------- GET ----------------------
  @override
  Future<AResponse> getAPI(String path,
      {AOptions? options, Map<String, dynamic>? queryParameters}) async {
    try {
      final Response response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: options?.headers),
      );

      dynamic apiData;
      if (response.data is String) {
        apiData = json.decode(response.data);
      } else {
        apiData = response.data;
      }

      return AResponse(
        statusCode: response.statusCode,
        data: apiData,
        message: apiData['msg']?.toString() ?? apiData['message']?.toString() ?? '',
      );
    } on DioException catch (e) {
      String message = 'Unknown network error';
      if (e.response != null) {
        final resData = e.response!.data;
        if (resData is Map && resData.containsKey('msg')) {
          message = resData['msg'].toString();
        } else {
          message = resData.toString();
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Request Timeout';
        throw const RequestTimeOutFailure(message: 'Request Timeout');
      }
          print(message);
      throw ServerFailure(message: message);
    } catch (e) {
      print(e.toString());
      throw ServerFailure(message: e.toString());
    } finally {
      log('GET request finished: $path');
    }
  }

  // ---------------------- POST ----------------------
  @override
@override
Future<AResponse> postAPI(
  String path, {
  required dynamic body,
  AOptions? options,
}) async {
  try {
    final Response response = await _dio.post(
      path,
      data: body,
      options: Options(headers: options?.headers),
    );

    // Normalize response
    Map<String, dynamic> apiDataJson;
    if (response.data is String) {
      try {
        apiDataJson = json.decode(response.data);
      } catch (_) {
        // just in case not Json
        return AResponse(
          statusCode: response.statusCode,
          data: null,
          message: response.data.toString(),
        );
      }
    } else if (response.data is Map<String, dynamic>) {
      apiDataJson = response.data;
    } else {
      return AResponse(
        statusCode: response.statusCode,
        data: null,
        message: response.data.toString(),
      );
    }

    return AResponse(
      statusCode: response.statusCode,
      data: apiDataJson,
      message: apiDataJson['message']?.toString() ?? '',
    );
  } on DioException catch (e) {
    String message = 'Unknown error';

    if (e.response != null) {
      try {
        final data = e.response!.data;
        if (data is String) {
          final decoded = json.decode(data);
          message = decoded['message'] ?? data;
        } else if (data is Map<String, dynamic>) {
          // Extract message and first validation error if available
          message = data['message'] ?? 'Request failed';
          if (data.containsKey('errors')) {
            final errors = data['errors'] as Map<String, dynamic>;
            if (errors.isNotEmpty) {
              final firstKey = errors.keys.first;
              final firstError = (errors[firstKey] as List).first;
              message = firstError.toString();
            }
          }
        }
      } catch (_) {
        message = e.response!.data.toString();
      }
    }

    throw ServerFailure(message: message);
  } catch (e) {
    throw ServerFailure(message: e.toString());
  } finally {
    log('end_requested : $path');
  }
}


  // ---------------------- PUT ----------------------
  @override
  Future<AResponse> putAPI(String path,
      {required Map<String, dynamic> body, AOptions? options}) async {
    try {
      final Response response = await _dio.put(
        path,
        data: body,
        options: Options(headers: options?.headers),
      );

      dynamic apiData;
      if (response.data is String) {
        apiData = json.decode(response.data);
      } else {
        apiData = response.data;
      }

      return AResponse(
        statusCode: response.statusCode,
        data: apiData['data'] ?? apiData,
        message: apiData['msg']?.toString() ?? apiData['message']?.toString() ?? '',
      );
    } on DioException catch (e) {
      String message = 'Unknown network error';
      if (e.response != null) {
        final resData = e.response!.data;
        if (resData is Map && resData.containsKey('msg')) {
          message = resData['msg'].toString();
        } else {
          message = resData.toString();
        }
      }
      throw ServerFailure(message: message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    } finally {
      log('PUT request finished: $path');
    }
  }

  // ---------------------- DELETE ----------------------
  @override
  Future<AResponse> deleteAPI(String path,
      {required Map<String, dynamic> body, AOptions? options}) async {
    try {
      final Response response = await _dio.delete(
        path,
        data: body,
        options: Options(headers: options?.headers),
      );

      dynamic apiData;
      if (response.data is String) {
        apiData = json.decode(response.data);
      } else {
        apiData = response.data;
      }

      return AResponse(
        statusCode: response.statusCode,
        data: apiData['data'] ?? apiData,
        message: apiData['msg']?.toString() ?? apiData['message']?.toString() ?? '',
      );
    } on DioException catch (e) {
      String message = 'Unknown network error';
      if (e.response != null) {
        final resData = e.response!.data;
        if (resData is Map && resData.containsKey('msg')) {
          message = resData['msg'].toString();
        } else {
          message = resData.toString();
        }
      }
      throw ServerFailure(message: message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    } finally {
      log('DELETE request finished: $path');
    }
  }

  // ---------------------- MULTIPART POST ----------------------
  Future<AResponse> postMultipartAPI(String path,
      {required Map<String, dynamic> body,
      required File image,
      required String imageParam,
      AOptions? options}) async {
    try {
      final mimeType = image.path.split('.').last;
      body[imageParam] = await MultipartFile.fromFile(
        image.path,
        filename: image.path.split("/").last,
        contentType: MediaType("image", mimeType),
      );

      FormData formData = FormData.fromMap(body);

      final Response response = await _dio.post(
        path,
        data: formData,
        options: Options(headers: options?.headers),
      );

      Map<String, dynamic> apiData;
      if (response.data is String) {
        apiData = json.decode(response.data);
      } else {
        apiData = response.data;
      }

      return AResponse(
        statusCode: response.statusCode,
        data: apiData['data'],
        message: apiData['msg']?.toString() ?? '',
      );
    } on DioException catch (e) {
      String message = 'Unknown network error';
      if (e.response != null) {
        final resData = e.response!.data;
        if (resData is Map && resData.containsKey('msg')) {
          message = resData['msg'].toString();
        } else {
          message = resData.toString();
        }
      }
      throw ServerFailure(message: message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    } finally {
      log('MULTIPART POST request finished: $path');
    }
  }
}