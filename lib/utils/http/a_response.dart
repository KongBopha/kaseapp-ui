import 'package:dio/dio.dart';

class AResponse<T> {
  final T? data;
  final int? statusCode;
  final String? message;
  final Map<String, dynamic>? headers;

  AResponse({
    this.data,
    this.statusCode,
    this.message,
    this.headers,
  });

  factory AResponse.fromDio(Response response) {
    return AResponse(
      data: response.data,
      statusCode: response.statusCode,
      message: response.statusMessage ?? _defaultMessage(response.statusCode),
      headers: response.headers.map.map(
        (key, value) => MapEntry(key, value.join(',')),
      ),
    );
  }

  static String _defaultMessage(int? code) {
    switch (code) {
      case 200:
        return 'Success';
      case 201:
        return 'Created';
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Server error';
      default:
        return 'Unknown response';
    }
  }
}
