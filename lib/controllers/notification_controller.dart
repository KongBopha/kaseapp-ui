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
      print('Total unread: ${count.value}');
    } finally {
      loading.value = false;
    }
  }

  // mark as read
  Future<void> markAsRead(int id) async{
    try{
      // update locally
      notifications.assignAll(notifications.map((notif){
        if(notif.id == id){
          return notif.copyWith(isRead: true);
        }
        return notif;
      }).toList()
      );

      summaries.assignAll(summaries.map((summary){
        final updateNotifs = summary.notifications.map((notif){
          if(notif.id==id){
            return notif.copyWith(isRead: true);
          }
          return notif;
        }).toList();

        return summary.copyWith(notifications:updateNotifs);
      }).toList()
      );
      //reduce unread count

      count.value =(count.value>0)? count.value-1:0;

      // sync with backend

      await _notificationRepository.markAsRead(id);
      print("Notification $id marked as read successfully.");

    }catch(e){
      print('Error marking notification as read: $e');

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