import 'dart:async';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/models/notification_model.dart';
import 'package:kaseapp_ui/models/notification_summary.dart';
import 'package:kaseapp_ui/repositories/notification_repository.dart';
import 'middleware/resettable_controller.dart';

class NotificationController extends GetxController implements ResettableController {
  final NotificationRepository _notificationRepository;
  final AuthController _authController = Get.find();

  NotificationController(this._notificationRepository);

  var notifications = <NotificationModel>[].obs;
  var count = 0.obs;
  var loading = false.obs;
  var summaries = <NotificationSummary>[].obs;

  Timer? _pollingTimer;  

  @override
  void onInit() {
    super.onInit();
    startAutoPolling(); 
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();  
    super.onClose();
  }

  @override
  void reset() {
    notifications.clear();
    count.value = 0;
    summaries.clear();
    loading.value = false;
  }
  

  Future<void> fetchNotifications() async {
    if (!_authController.auth) return; 
    try {
      final result = await _notificationRepository.getNotifications();
      notifications.assignAll(result['notifications'] as List<NotificationModel>? ?? []);
      count.value = result['total_unread'] ?? 0;
    } catch (e) {
      reset();
    }
  }
    void startAutoPolling({Duration interval = const Duration(seconds: 10)}) {
    _pollingTimer?.cancel();  
    _pollingTimer = Timer.periodic(interval, (timer) async {
      if (_authController.auth) {
        print('Auto polling notifications...');
        await fetchNotifications();
      }
    });
  }

  /// Fetch all grouped notifications
  Future<void> fetchAllNotifications() async {
    if (!_authController.auth) return;  
    try {
      loading.value = true;
      final result = await _notificationRepository.getAllNotifications();
      summaries.assignAll(result);
    } finally {
      loading.value = false;
    } 
  }

  /// Mark a notification as read
  Future<void> markAsRead(int id) async {
    notifications.assignAll(notifications.map((n) =>
        n.id == id ? n.copyWith(isRead: true) : n).toList());
    count.value = (count.value > 0) ? count.value - 1 : 0;
    await _notificationRepository.markAsRead(id);
  }


}
