import 'package:get/get.dart';
import 'package:kaseapp_ui/models/notification_model.dart';
import 'package:kaseapp_ui/models/notification_summary.dart';
import 'package:kaseapp_ui/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _notificationRepository;

  NotificationController(this._notificationRepository);

  var notifications = <NotificationModel>[].obs;
  var count = 0.obs;
  var loading = false.obs;
  var summaries = <NotificationSummary>[].obs;


  Future<void> fetchNotifications() async {
    try {
      loading.value = true;
      final result = await _notificationRepository.getNotifications();

      notifications.assignAll(result['notifications'] as List<NotificationModel>? ?? []);

      count.value = result['total_unread'] ?? 0;

      print('=== Notification API Response ===');
      print('Total unread: ${count.value}');
      //print('Notifications count: ${notifications.length}');
      
    } catch (e) {
      notifications.assignAll(<NotificationModel>[]);
      count.value = 0;
      print('NotificationController error: $e');
    } finally {
      loading.value = false;
    }
  }
  Future<void> markAsRead(int id) async{
    try{

    }catch(e){

    }
  }
  Future<void> fetchAllNotifications() async {
    try {
      loading.value = true;
      final result = await _notificationRepository.getAllNotifications();
      
      print("Fetched summaries: ${result.length}"); // Debug
      for (var summary in result) {
        print("Summary PreOrderId: ${summary.preOrderId}, notifications: ${summary.notifications.length}");
      }

      summaries.assignAll(result);
    } finally {
      loading.value = false;
    }
  }

}