import 'a_response.dart';
import 'a_options.dart';

abstract class AHttpClient {
  Future<AResponse> getAPI(String path, {AOptions? options});
  Future<AResponse> postAPI(String path,
      {required Map<String, dynamic> body, AOptions? options});
  Future<AResponse> deleteAPI(String path,
      {required Map<String, dynamic> body, AOptions? options});
  Future<AResponse> putAPI(String path,
      {required Map<String, dynamic> body, AOptions? options});
}