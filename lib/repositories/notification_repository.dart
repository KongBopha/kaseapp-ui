import 'package:kaseapp_ui/models/notification_model.dart';
import 'package:kaseapp_ui/models/notification_summary.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';

class NotificationRepository {
  final ApiHelper _apiHelper;
  NotificationRepository(this._apiHelper);

  /// Fetch notifications 
  Future<Map<String, dynamic>> getNotifications() async {
  
    final response = await _apiHelper.get(endpoint: '/notifications/unread');
    return {
      'total_unread': response['unread_count'] ?? 0,
      'notifications': <NotificationModel>[],  
    };
  }

  // fetch all group notifications
  Future<List<NotificationSummary>> getAllNotifications() async {
    final response = await _apiHelper.get(endpoint: '/notifications');

   print("API response: $response"); // Debug

    final dataList = (response['data'] as List?) ?? [];
   // print("Data list length: ${dataList.length}"); // Debug

    final summaries = dataList
        .map((group) {
          //print("Parsing group: $group"); // Debug
          return NotificationSummary.fromJson(group as Map<String, dynamic>);
        })
        .toList();

   // print("Parsed summaries length: ${summaries.length}"); // Debug

    return summaries;
  }
  // mark as read
  Future<void> markAsRead(int id) async{

    try{
    await _apiHelper.update(
      endpoint: '/notifications/$id/mark-read',
      jsonBody: {'read_status':1},
      );
    }catch(e){
      print("Error in markNotificationAsRead: $e");
      rethrow;
    }

  }
  Future<void> registerFcmToken(String token) async {
  await _apiHelper.post(
    endpoint: '/notifications/register-token',
    jsonBody: {'fcm_token': token},
  );
}

  
}
