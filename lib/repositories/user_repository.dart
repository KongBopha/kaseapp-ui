import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kaseapp_ui/models/user_model.dart';
import 'package:kaseapp_ui/utils/error/failure.dart';

import '../utils/helper/api_helper.dart';

// fetch user record from api
class UserRepository {
  final _apiHelper = ApiHelper();


  Future<UserModel?> viewProfile({required int userId}) async {
    try {
      final response = await _apiHelper.get(endpoint: '/showProfile/$userId');

      print("Raw API response: $response");
      if (response['success'] == true && response['data'] != null) {
        return UserModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('viewProfile error: $e');
      return null;
    }
  }
  Future<Either<Failure, dynamic>> updateProfile({
    File? image,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (firstName != null) body['first_name'] = firstName;
      if (lastName != null) body['last_name'] = lastName;
      if (phone != null) body['phone'] = phone;

      final response = await _apiHelper.updateMultipart(
        endpoint: '/auth/update-profile',
        jsonBody: body,
        image: image,
        imageParam: 'profile_url',
      );

      return Right(response);
    } on Failure catch (e) {
      return Left(e);
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

   Future<Either<Failure, dynamic>> updateVendorProfile({
    String? name,
    String? vendorType,
    String? address,
    String? about,
    File? logo,
  }) async {
    try {
      final response = await _apiHelper.postMultipart(
        endPoint: '/vendor/update-profile',
        jsonBody: {
          'name': name,
          'vendor_type': vendorType,
          'address': address,
          'about': about,
        },
        image: logo ?? File(''),
        imageParam: 'logo',
      );

      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  // Update Farm profile 
  Future<Either<Failure, dynamic>> updateFarmProfile({
    String? name,
    String? address,
    String? description,
    File? logo,
    File? cover,
  }) async {
    try {
      final response = await _apiHelper.postMultipart(
        endPoint: '/farm/update-profile',
        jsonBody: {
          'name': name,
          'address': address,
          'description': description,
        },
        image: cover ?? File(''),
        imageParam: 'cover',
      );

      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }
  
}