import 'package:dartz/dartz.dart';
import 'package:kaseapp_ui/utils/error/failure.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';
import 'package:kaseapp_ui/models/register_model.dart';

class RegisterRepository {
  final _apiHelper = ApiHelper();
  
  Future<Either<Failure, dynamic>> register({
    required RegisterModel registerModel,
  }) async {
    try {
      final dynamic response = await _apiHelper.postPublic(
        endpoint: '/auth/signup',
        jsonBody: registerModel.toJson(),
      );
      return Right(response);
    } on Failure catch (exception) {
      return Left(exception);
    }
  }
}
