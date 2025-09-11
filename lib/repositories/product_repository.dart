import 'package:dartz/dartz.dart';
import 'package:kaseapp_ui/models/product.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';
import '../utils/error/failure.dart';

class ProductRepository { 
  final ApiHelper _apiHelper = ApiHelper();

  Future<Either<Failure, List<Product>>> fetchProductsByName() async {
    try {
      final response = await _apiHelper.getPublic(endpoint: '/auth/get-products/byname');
      print('Raw Product API Response: $response');


      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final dataList = (response['data'] as List?) ?? [];
        final products = dataList
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();

        print('=== Product API Response ===');
        print('Fetched products: ${products.length}');

        return Right(products);
      } else {
        return Left(ServerFailure(message: 'Invalid API response format: $response'));
      }
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, Product>> getProductsById(int id) async {
    try {
      final response = await _apiHelper.get(endpoint: 'auth/products/$id');

      if (response.containsKey('data')) {
        final product = Product.fromJson(response['data']);
        return Right(product);
      } else {
        return Left(ServerFailure(message: 'Invalid product response format: $response'));
      }
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
