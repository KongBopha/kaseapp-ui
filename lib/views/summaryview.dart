import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/Routes/routes.dart';
import 'package:kaseapp_ui/controllers/notification_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';

class NotificationSummaryView extends StatefulWidget {
  @override
  _NotificationSummaryViewState createState() =>
      _NotificationSummaryViewState();
}

class _NotificationSummaryViewState extends State<NotificationSummaryView> {
  final NotificationController controller = Get.find();
  final UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    controller.fetchAllNotifications();
  }

  void _viewAll() {
    final role = userController.user.role.toLowerCase();
    if (role == 'farmer') {
      Get.toNamed(AppRoutes.retriveOrder);
    } else if (role == 'vendor') {
      Get.toNamed(AppRoutes.orderRespond);
    } else {
      Get.snackbar('Info', 'No listing available for your role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _viewAll,
            child: const Text(
              'View All',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.summaries.isEmpty) {
          return const Center(child: Text('No notifications yet.'));
        }

        return ListView.separated(
          itemCount: controller.summaries.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final summary = controller.summaries[index];

            return ExpansionTile(
              title: Text(
                summary.product != null
                    ? '${summary.product['name']} (Pre-order #${summary.preOrderId})'
                    : 'Pre-order #${summary.preOrderId}',
              ),
              subtitle: Text(
                summary.vendor != null
                    ? 'Vendor: ${summary.vendor['name']}'
                    : summary.farm != null
                        ? 'Farm: ${summary.farm['name']}'
                        : '',
              ),
              children: summary.notifications.map<Widget>((notif) {
                final isUnread = !notif.isRead;

                return ListTile(
                  leading: Icon(
                    isUnread ? Icons.markunread : Icons.check,
                    color: isUnread ? Colors.red : Colors.green,
                  ),
                  title: Text(
                    notif.message,
                    style: TextStyle(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    notif.createdAt.toLocal().toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    controller.markAsRead(notif.id);
                  },
                );
              }).toList(),
            );
          },
        );
      }),
    );
  }
}
