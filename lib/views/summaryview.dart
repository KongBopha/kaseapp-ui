import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/Routes/routes.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/notification_controller.dart';
//import 'package:kaseapp_ui/models/notification_model.dart';

class NotificationSummaryView extends StatefulWidget {
  @override
  _NotificationSummaryViewState createState() =>
      _NotificationSummaryViewState();
}

class _NotificationSummaryViewState extends State<NotificationSummaryView> {
  final NotificationController controller = Get.find();
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    if (!authController.auth) return;
    await controller.fetchAllNotifications();
  }

  void _viewAll() {
    final role = authController.role.toLowerCase();

    switch (role) {
      case 'farmer':
        Get.toNamed(AppRoutes.retriveOrder);
        break;
      case 'vendor':
        Get.toNamed(AppRoutes.orderRespond);
        break;
      default:
        Get.snackbar('Info', 'No listing available for your role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _viewAll,
            child: const Text(
              'View All',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.summaries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ll notify you when something arrives',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _initNotifications,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.summaries.length,
            itemBuilder: (context, index) {
              final summary = controller.summaries[index];
              final hasUnread = summary.notifications.any((n) => !n.isRead);

              return _NotificationCard(
                summary: summary,
                hasUnread: hasUnread,
                controller: controller,
              );
            },
          ),
        );
      }),
    );
  }
}

class _NotificationCard extends StatefulWidget {
  final dynamic summary;
  final bool hasUnread;
  final NotificationController controller;

  const _NotificationCard({
    required this.summary,
    required this.hasUnread,
    required this.controller,
  });

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  bool _isExpanded = false;

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;

    final productName = summary.product != null
        ? summary.product['name']
        : 'Pre-order #${summary.preOrderId}';

    // Key changes: Access vendor_info for vendor name, user_info for phone, fallback to farm
    String subtitleText = '';
    if (summary.vendor != null) {
      final vendorInfo = summary.vendor['vendor_info'];
      final userInfo = summary.vendor['user_info'];
      final vendorName = vendorInfo?['name'] ?? 'Unknown Vendor';
      final contactPhone = userInfo?['phone'] ?? 'N/A';
      subtitleText = 'Vendor: $vendorName | Contact: $contactPhone';
    } else if (summary.farm != null) {
      subtitleText = 'Farm: ${summary.farm['name']}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.hasUnread
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: widget.hasUnread
                          ? const Color(0xFF10B981)
                          : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                productName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: widget.hasUnread
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.hasUnread)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(left: 8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitleText, // updated here
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${summary.notifications.length} notification${summary.notifications.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expand icon
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
          // Expanded notifications
          if (_isExpanded)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  const Divider(height: 1),
                  ...summary.notifications.map<Widget>((notif) {
                    final isUnread = !notif.isRead;
                    return InkWell(
                      onTap: () {
                        widget.controller.markAsRead(notif.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isUnread
                              ? const Color(0xFF10B981).withOpacity(0.05)
                              : Colors.transparent,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isUnread
                                    ? const Color(0xFF10B981)
                                    : Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isUnread ? Icons.circle : Icons.check,
                                color: Colors.white,
                                size: isUnread ? 12 : 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notif.message,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isUnread
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getTimeAgo(notif.createdAt.toLocal()),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
