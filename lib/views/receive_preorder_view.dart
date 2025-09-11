import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/receiveorder_controller.dart';
import 'package:kaseapp_ui/models/receiveorder_model.dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';

class ReceivePreorderView extends StatefulWidget {
  const ReceivePreorderView({super.key});

  @override
  State<ReceivePreorderView> createState() => _ReceivePreorderViewState();
}

class _ReceivePreorderViewState extends State<ReceivePreorderView> {
  final ReceiveOrderController controller = Get.find<ReceiveOrderController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Pagination on scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          controller.canLoadMore) {
        controller.fetchReceiveOrders(loadMore: true);
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
      backgroundColor: AppTheme.pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.appbarBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.btnTextNormalColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Farm Dashboard',
          style: TextStyle(
            color: AppTheme.btnTextNormalColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value && controller.receiveOrders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.receiveOrders.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.receiveOrders.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.receiveOrders.length) {
                return controller.canLoadMore
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink();
              }

              final order = controller.receiveOrders[index];
              return Column(
                children: [
                  _buildPreorderCard(order: order),
                  const SizedBox(height: 12),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPreorderCard({required ReceiveorderModel order}) {
    final bool isPending = order.status.toLowerCase() == 'pending';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      style: TextStyle(
                        color: AppTheme.itemTitleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vendor: ${order.vendorName}\nQty: ${order.quantity}',
                      style: TextStyle(
                        color: AppTheme.itemSubTitleColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isPending ? Colors.orange : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Location & Delivery
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location',
                        style: TextStyle(
                            color: AppTheme.itemSubTitleColor, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(order.location,
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery',
                        style: TextStyle(
                            color: AppTheme.itemSubTitleColor, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(order.deliveryDate,
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Note
          Text('Note: ${order.note}',
              style: TextStyle(
                color: AppTheme.itemSubTitleColor,
                fontSize: 12,
              )),

          // Action buttons
          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showResponseDialog(
                        preOrder: order, offerStatus: OrderDetailsEnum.accepted),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Accept',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showResponseDialog(
                        preOrder: order, offerStatus: OrderDetailsEnum.rejected),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Reject',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: AppTheme.itemSubTitleColor),
          const SizedBox(height: 16),
          Text('No Responses Yet',
              style: TextStyle(
                  color: AppTheme.itemTitleColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('When vendors respond to your pre-orders, they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.itemSubTitleColor, fontSize: 14)),
        ],
      ),
    );
  }

  void _showResponseDialog({
    required ReceiveorderModel preOrder,
    required OrderDetailsEnum offerStatus,
  }) {
    final TextEditingController qtyController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    Get.defaultDialog(
      title: offerStatus == OrderDetailsEnum.accepted
          ? 'Accept Pre-order'
          : 'Reject Pre-order',
      content: Column(
        children: [
          if (offerStatus == OrderDetailsEnum.accepted)
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Quantity you can provide'),
            ),
          TextField(
            controller: descController,
            decoration:
                const InputDecoration(labelText: 'Description (optional)'),
          ),
        ],
      ),
      textConfirm: 'Submit',
      textCancel: 'Cancel',
      onConfirm: () {
        final qty = int.tryParse(qtyController.text) ?? 0;
        controller.respondToPreOrder(
          preOrder: preOrder,
          offerStatus: offerStatus,
          fulfilledQty: qty,
          description: descController.text,
        );
        Get.back();
        // if(){

        // }
       clearPreOrderCard(preOrder);
      },
    );
  }
  // clear card
  void clearPreOrderCard(ReceiveorderModel preOrder){
    controller.receiveOrders.removeWhere(
      (order) => order.preOrderId == preOrder.preOrderId);
  }
}
