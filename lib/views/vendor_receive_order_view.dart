import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/receive_order_respond_controller.dart';
import 'package:kaseapp_ui/models/vendor_receive_preorder_model.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';

class VendorReceiveOrderView extends StatefulWidget {
  const VendorReceiveOrderView({super.key});

  @override
  State<VendorReceiveOrderView> createState() => _VendorReceiveOrderViewState();
}

class _VendorReceiveOrderViewState extends State<VendorReceiveOrderView> {
  final ScrollController _scrollController = ScrollController();
  final ReceiveOrderRespondController controller = Get.find<ReceiveOrderRespondController>();

  @override
  void initState() {
    super.initState();
    controller.fetchFarmRespond();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          controller.canLoadMore) {
        controller.fetchFarmRespond(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmers' Responses"),
        backgroundColor: AppTheme.appbarBackgroundColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.receiveOrders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.receiveOrders.isEmpty) {
          return const Center(child: Text("No responses yet."));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchFarmRespond(),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: controller.receiveOrders.length + (controller.canLoadMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.receiveOrders.length) {
                final order = controller.receiveOrders[index];
                return _VendorReceiveOrderCard(preOrder: order);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      }),
    );
  }
}

class _VendorReceiveOrderCard extends StatelessWidget {
  final VendorReceivePreorderModel preOrder;
  final ReceiveOrderRespondController controller = Get.find();

  _VendorReceiveOrderCard({required this.preOrder});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(preOrder.productName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.itemTitleColor)),
            const SizedBox(height: 4),
            Text('From ${preOrder.farmName}', style: TextStyle(color: AppTheme.itemSubTitleColor)),
            const SizedBox(height: 8),
            Text('Quantity offered: ${preOrder.fulfilled_qty} kg',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Delivery: ${_formatDate(preOrder.deliveryDate)}',
                style: TextStyle(color: AppTheme.itemTitleColor)),
            const SizedBox(height: 4),
            Text('Location: ${preOrder.location}', style: TextStyle(color: AppTheme.itemSubTitleColor)),
            if (preOrder.note != null && preOrder.note!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Note: ${preOrder.note}', style: TextStyle(color: AppTheme.itemTitleColor)),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _showConfirmDialog(preOrder),
                  child: const Text('Confirm'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _showRejectDialog(preOrder),
                  child: const Text('Reject'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(VendorReceivePreorderModel order) {
    Get.defaultDialog(
      title: 'Confirm Offer',
      content: Text('Are you sure you want to confirm this offer from ${order.farmName}?'),
      textConfirm: 'Yes',
      textCancel: 'Cancel',
      onConfirm: () {
        controller.respondToOffer(
          orderDetailId: order.orderDetailId,
          status: OrderDetailsEnum.confirmed,
        );
        Get.back();
      },
    );
  }

  void _showRejectDialog(VendorReceivePreorderModel order) {
    Get.defaultDialog(
      title: 'Reject Offer',
      content: Text('Are you sure you want to reject this offer from ${order.farmName}?'),
      textConfirm: 'Yes',
      textCancel: 'Cancel',
      onConfirm: () {
        controller.respondToOffer(
          orderDetailId: order.orderDetailId,
          status: OrderDetailsEnum.rejected,
        );
        Get.back();
      },
    );
  }

  static String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (_) {
      return dateString;
    }
  }
}
