import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kaseapp_ui/utils/error/failure.dart';

import '../utils/helper/api_helper.dart';

// fetch user record from api
class UserRepository {
  final _apiHelper = ApiHelper();


  Future<dynamic> getUser(int id) async
  {
    try{
      final dynamic response = await _apiHelper.get(
        endpoint: 'auth/me',
        queryParameters: {'id': id}
    );
    return Right(response);
    } on Failure catch (exception) {
      return Left(exception);
    }
  }
  Future<Either<Failure, dynamic>> updateProfile(File image) async {
    try {
      final dynamic response = await _apiHelper.postMultipart(
        endPoint: '/auth/user_profile',
        jsonBody: {},
        image: image,
        imageParam: 'image',
      );
      return Right(response);
    } on Failure catch (exception) {
      // print(exception);
      return Left(exception);
    }
  }
  Future<Either<Failure, dynamic>> upgradeToFarmer({
    required String name,
    required String? address,
    required String? about,
    required String? cover,
    required String? logo,
  }) async {
    try {
      final dynamic response = await _apiHelper.post(
        endpoint: '/auth/upgrade-to-farmer',
        jsonBody: {
          'name': name,
          'address': address,
          'about': about,
          'cover': cover,
          'logo': logo,
        },
      );
      return Right(response);
    } on Failure catch (exception) {
      return Left(exception);
    }
  }
  Future<Either<Failure,dynamic>> upgradeToVendor({
    required String name,
    required String address,
    required String description,
    required String vendorType,
  }) async {
    try {
      final dynamic response = await _apiHelper.post(
        endpoint: '/auth/upgrade-to-vendor',
        jsonBody: {
          'name': name,
          'address': address,
          'description': description,
          'vendor_type': vendorType,
        },
      );
      return Right(response);
    } on Failure catch (exception) {
      return Left(exception);
    }
  }
  
}