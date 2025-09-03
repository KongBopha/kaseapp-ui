import 'package:kaseapp_ui/models/notification_model.dart';
import 'package:kaseapp_ui/models/notification_summary.dart';
import 'package:kaseapp_ui/utils/helper/api_helper.dart';

class NotificationRepository {
  final ApiHelper _apiHelper;

  NotificationRepository(this._apiHelper);

  /// Fetch notifications 
  Future<Map<String, dynamic>> getNotifications() async {
  final response = await _apiHelper.get(endpoint: '/notifications/unread');
  
  // Debug print
  print('Raw API response: $response');
  
  final dataList = (response['data'] as List?) ?? [];
  
  final notifications = dataList
      .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList();

  return {
    'total_unread': response['unread_count'] ?? 0,
    'notifications': notifications,
  };
  }
  // mark as read
Future<List<NotificationSummary>> getAllNotifications() async {
  final response = await _apiHelper.get(endpoint: '/notifications');

  print("API response: $response"); // Debug

  final dataList = (response['data'] as List?) ?? [];
  print("Data list length: ${dataList.length}"); // Debug

  final summaries = dataList
      .map((group) {
        print("Parsing group: $group"); // Debug
        return NotificationSummary.fromJson(group as Map<String, dynamic>);
      })
      .toList();

  print("Parsed summaries length: ${summaries.length}"); // Debug

  return summaries;
}

  
}
