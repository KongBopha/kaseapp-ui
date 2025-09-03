import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    controller.fetchAllNotifications(); // Fetch notifications automatically
  }

  void _viewAll() {
    final role = userController.user.role.toLowerCase();
    if (role == 'farmer') {
      Get.toNamed('/order/details'); // Farmer sees pending pre-orders
    } else if (role == 'vendor') {
      Get.toNamed('/vendor-summary'); // Vendor sees their summaries
    } else {
      Get.snackbar('Info', 'No listing available for your role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _viewAll,
            child: Text(
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
                    : '',
              ),
              children: const [
                // Skip taps; we don’t handle detailed navigation here
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                      'Tap on "View All" to see the full listing for your role.'),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
