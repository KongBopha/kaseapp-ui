import 'package:kaseapp_ui/models/market_supplies.dart';
import 'package:kaseapp_ui/utils/error/failure.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';
import 'package:dartz/dartz.dart';

class MarketSupplyRepositories {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Either<Failure,List<MarketSupplies>>> fetchMarketSupplies() async{
    try{
        final response = await _apiHelper.get(
        endpoint: '/auth/market-supplies/listing');
        print('Raw Market API response: $response');

    if(response.containsKey('data')){
      final dataList = (response['data'] as List?)??[];
      final marketData = dataList 
          .map((e)=>MarketSupplies.fromJson(e as Map<String,dynamic>))
          .toList();
      
      print('=== Market API Response ===');
      print('Fetched Market: ${marketData.length}');
      return Right(marketData);
    }else{
      return Left(ServerFailure(message:'Invalid API response format: $response'));
    }
    }on Failure catch(e){
      return Left(e);
    }catch(e){
      return Left(ServerFailure(message: e.toString()));
    }
  }
}