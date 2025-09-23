import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/receive_order_respond_controller.dart';
import 'package:kaseapp_ui/models/vendor_receive_preorder_model.dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';

class VendorReceiveOrderView extends StatefulWidget {
  const VendorReceiveOrderView({super.key});

  @override
  State<VendorReceiveOrderView> createState() => _VendorReceiveOrderViewState();
}

class _VendorReceiveOrderViewState extends State<VendorReceiveOrderView>
    with SingleTickerProviderStateMixin {
  final ReceiveOrderRespondController controller = Get.find();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  final List<String?> statuses = [null, 'pending', 'accepted', 'rejected', 'confirmed'];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: statuses.length, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        controller.changeStatus(statuses[_tabController.index]);
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          controller.canLoadMore) {
        controller.fetchOrders(loadMore: true);
      }
    });

    controller.fetchOrders();
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
      appBar: AppBar(
        title: const Text("Farmers' Responses"),
        bottom: TabBar(
          controller: _tabController,
          tabs: statuses
              .map((s) => Tab(text: s?.capitalize ?? 'All'))
              .toList(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.receiveOrders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.receiveOrders.isEmpty) {
          return const Center(child: Text("No responses yet."));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchOrders(),
          child: ListView.builder(
            controller: _scrollController,
            itemCount:
                controller.receiveOrders.length + (controller.canLoadMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.receiveOrders.length) {
                return _VendorReceiveOrderCard(
                    preOrder: controller.receiveOrders[index]);
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
    final isPending = preOrder.status == OrderDetailsEnum.pending;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product & Farm
            Text(preOrder.productName,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.itemTitleColor)),
            const SizedBox(height: 4),
            Text('From ${preOrder.farmName}',
                style: TextStyle(color: AppTheme.itemSubTitleColor)),
            const SizedBox(height: 8),

            // Fulfilled Quantity
            Text('Quantity offered: ${preOrder.fulfilledQty} kg',
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.w600)),

            const SizedBox(height: 4),
            Text('Delivery: ${preOrder.deliveryDate}',
                style: TextStyle(color: AppTheme.itemTitleColor)),
            const SizedBox(height: 4),
            Text('Location: ${preOrder.location}',
                style: TextStyle(color: AppTheme.itemSubTitleColor)),

            // Note (if exists)
            if (preOrder.note != null && preOrder.note!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Note: ${preOrder.note}',
                  style: TextStyle(color: AppTheme.itemTitleColor)),
            ],

            const SizedBox(height: 8),

            // Action buttons (dynamic)
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.respondToOffer(
                          orderDetailId: preOrder.orderDetailId,
                          status: OrderDetailsEnum.confirmed,
                        );
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.respondToOffer(
                          orderDetailId: preOrder.orderDetailId,
                          status: OrderDetailsEnum.rejected,
                        );
                      },
                      child: const Text('Reject'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
                ],
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(preOrder.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  preOrder.status.name.capitalizeFirst!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper to assign colors based on status
  Color _statusColor(OrderDetailsEnum status) {
    switch (status) {
      case OrderDetailsEnum.pending:
        return Colors.orange;
      case OrderDetailsEnum.accepted:
        return Colors.green;
      case OrderDetailsEnum.confirmed:
        return Colors.blue;
      case OrderDetailsEnum.rejected:
        return Colors.red;
      }
  }
}

