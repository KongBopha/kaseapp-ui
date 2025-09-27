import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/receiveorder_controller.dart';
import 'package:kaseapp_ui/models/receiveorder_listing.dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';

class ReceivePreorderView extends StatefulWidget {
  const ReceivePreorderView({super.key});

  @override
  State<ReceivePreorderView> createState() => _ReceivePreorderViewState();
}

class _ReceivePreorderViewState extends State<ReceivePreorderView>
    with SingleTickerProviderStateMixin {
  final ReceiveOrderController controller = Get.find<ReceiveOrderController>();
  final ScrollController _scrollController = ScrollController();
  final AuthController _authController = Get.find();

  late TabController _tabController;

  final List<OrderDetailsEnum> filterStatuses = [
    OrderDetailsEnum.pending,
    OrderDetailsEnum.accepted,
    OrderDetailsEnum.confirmed,
    OrderDetailsEnum.rejected,
  ];

  @override
  void initState() {
    super.initState();

    // Initialize tab controller synchronously
    _tabController = TabController(length: filterStatuses.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      controller.changeStatus(filterStatuses[_tabController.index]);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          controller.canLoadMore) {
        controller.fetchOrders(loadMore: true);
      }
    });

    // Call async data initialization separately
    _initData();
  }

  Future<void> _initData() async {
    if (!_authController.auth) return;

    try {
      // Initial load: pending first
      await controller.changeStatus(OrderDetailsEnum.pending);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load pre-orders: $e');
    }
  }
  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          indicatorColor: Colors.white,
          tabs: filterStatuses
              .map((status) => Tab(text: status.value.capitalizeFirst!))
              .toList(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allOrders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.allOrders.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: controller.allOrders.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.allOrders.length) {
              return controller.canLoadMore
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink();
            }

            final order = controller.allOrders[index];
            return Column(
              children: [
                _buildPreorderCard(order),
                const SizedBox(height: 12),
              ],
            );
          },
        );
      }),
    );
  }

 Widget _buildPreorderCard(ReceivePreorderViewModel order) {
  final isPending = order.offerStatus.toLowerCase() == 'pending';

  // Choose which quantity and status to display
  final displayQty = isPending ? order.requestedQty : order.fulfilledQty;
  final displayStatus = isPending ? order.offerStatus : order.offerStatus;
  final displayNote = order.note;
  final displayDelivery = order.deliveryDate;

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
                  Text(order.productName,
                      style: TextStyle(
                        color: AppTheme.itemTitleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    'Vendor: ${order.vendorName}\nQty: $displayQty',
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
              child: Text(displayStatus,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
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
                  Text(displayDelivery,
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
        Text('Note: $displayNote',
            style: TextStyle(
              color: AppTheme.itemSubTitleColor,
              fontSize: 12,
            )),

        // Action buttons only for pending orders
        if (isPending) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showResponseDialog(
                      order: order, status: OrderDetailsEnum.accepted),
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
                      order: order, status: OrderDetailsEnum.rejected),
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
          Text(
            'When vendors respond to your pre-orders, they will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.itemSubTitleColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

void _showResponseDialog({
  required ReceivePreorderViewModel order,
  required OrderDetailsEnum status,
}) {
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  // Pre-fill quantity for pending orders when accepting
  if (status == OrderDetailsEnum.accepted && order.offerStatus.toLowerCase() == 'pending') {
    qtyController.text = order.requestedQty.toStringAsFixed(0);
  }

  Get.defaultDialog(
    title: status == OrderDetailsEnum.accepted
        ? 'Accept Pre-order'
        : 'Reject Pre-order',
    content: Column(
      children: [
        if (status == OrderDetailsEnum.accepted)
          TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantity you can provide',
            ),
          ),
        TextField(
          controller: descController,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
          ),
        ),
      ],
    ),
    textConfirm: 'Submit',
    textCancel: 'Cancel',
    onConfirm: () async {
      final qty = int.tryParse(qtyController.text) ?? 0;

      final success = await controller.respondToPreOrder(
        order: order,
        offerStatus: status,
        fulfilledQty: qty,
        description: descController.text,
      );

      if (success) {
        // Update the order in the list
        final index = controller.allOrders
            .indexWhere((o) => o.preOrderId == order.preOrderId);

        if (index != -1) {
          final updatedOrder = order.copyWith(
            offerStatus: status.value,
            fulfilledQty: qty > 0 ? qty.toDouble() : order.fulfilledQty,
            note: descController.text,
          );
          controller.allOrders[index] = updatedOrder;
        }

        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'Failed to respond. Try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    },
    onCancel: () {
      Get.back();
    },
  );
}

}
