import 'package:dartz/dartz.dart';
import 'package:kaseapp_ui/models/login_model.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';

import '../utils/error/failure.dart';

class LoginRepository {
  final _apiHelper = ApiHelper();

  Future<Either<Failure, dynamic>> login({required LoginModel loginModel}) async {
    try {
      final dynamic response = await _apiHelper.postPublic(
        endpoint: '/auth/login',
        jsonBody: loginModel.toJson(),
      );
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}