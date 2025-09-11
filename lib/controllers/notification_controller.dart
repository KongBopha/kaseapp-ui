import 'package:get/get.dart';
import 'package:kaseapp_ui/models/notification_model.dart';
import 'package:kaseapp_ui/models/notification_summary.dart';
import 'package:kaseapp_ui/repositories/notification_repository.dart';
import 'middleware/resettable_controller.dart';

class NotificationController extends GetxController implements ResettableController {
  final NotificationRepository _notificationRepository;

  NotificationController(this._notificationRepository);

  var notifications = <NotificationModel>[].obs;
  var count = 0.obs;
  var loading = false.obs;
  var summaries = <NotificationSummary>[].obs;

  @override
  void reset() {
    notifications.clear();
    count.value = 0;
    summaries.clear();
    loading.value = false;
  }

  Future<void> fetchNotifications() async {
    try {
      loading.value = true;
      final result = await _notificationRepository.getNotifications();
      notifications.assignAll(result['notifications'] as List<NotificationModel>? ?? []);
      count.value = result['total_unread'] ?? 0;
    } catch (e) {
      reset();
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchAllNotifications() async {
    try {
      loading.value = true;
      final result = await _notificationRepository.getAllNotifications();
      summaries.assignAll(result);
    } finally {
      loading.value = false;
    }
  }

  Future<void> markAsRead(int id) async {
    notifications.assignAll(notifications.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList());
    count.value = (count.value > 0) ? count.value - 1 : 0;
    await _notificationRepository.markAsRead(id);
  }
}
