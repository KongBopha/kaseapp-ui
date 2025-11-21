import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/receiveorder_controller.dart';
import 'package:kaseapp_ui/models/receiveorder_listing.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/images_converter.dart';
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
  final displayQty = isPending ? order.requestedQty : order.fulfilledQty;
  final displayStatus = order.offerStatus;
  final displayNote = order.note;
  final displayDelivery = order.deliveryDate;

  // Get image URL using converter
  final imagesConverter = ImagesConverter();
  final productImageUrl = imagesConverter.getProductImageUrl(order.productImage);

  Color statusColor;
  if (displayStatus.toLowerCase() == 'pending') {
    statusColor = Colors.orange;
  } else if (displayStatus.toLowerCase() == 'accepted' ||
      displayStatus.toLowerCase() == 'confirmed') {
    statusColor = Colors.green;
  } else {
    statusColor = Colors.red;
  }

  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    shadowColor: Colors.black.withOpacity(0.05),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: Product image + info + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  productImageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Image.asset(AppImage.orderIcon, width: 80, height: 80),
                ),
              ),
              const SizedBox(width: 12),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.productName,
                        style: TextStyle(
                          color: AppTheme.itemTitleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                      Text(
                        controller.userController.user.role == 'farmer'
                          ? 'Vendor: ${order.vendorName}'
                          : 'Farm: ${order.vendorName}',
                        style: TextStyle(
                          color: AppTheme.itemSubTitleColor,
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Text('Quantity: $displayQty',
                        style: TextStyle(
                            color: AppTheme.itemSubTitleColor, fontSize: 12)),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  displayStatus.capitalizeFirst!,
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Info grid: location & delivery
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
          if (displayNote.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Note: $displayNote',
                style: TextStyle(
                    color: AppTheme.itemSubTitleColor, fontSize: 12)),
          ],
          // Action buttons for pending orders
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showResponseDialog(
                        context: context,
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
                // const SizedBox(width: 8),
                // Expanded(
                //   child: OutlinedButton(
                //     onPressed: () => _showResponseDialog(
                //         context: context,
                //         order: order, status: OrderDetailsEnum.rejected),
                //     style: OutlinedButton.styleFrom(
                //       foregroundColor: Colors.red,
                //       side: const BorderSide(color: Colors.red),
                //       padding: const EdgeInsets.symmetric(vertical: 12),
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8)),
                //     ),
                //     child: const Text('Reject',
                //         style: TextStyle(fontWeight: FontWeight.w600)),
                //   ),
                // ),
              ],
            ),
          ],
        ],
      ),
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
  required BuildContext context,
  required ReceivePreorderViewModel order,
  required OrderDetailsEnum status,
}) {
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final String dialogTitle = status == OrderDetailsEnum.accepted
      ? 'Accept Pre-order'
      : 'Reject Pre-order';

  final String confirmText = status == OrderDetailsEnum.accepted
      ? 'ACCEPT'
      : 'REJECT';

  // Pre-fill quantity only for accepted orders
  if (status == OrderDetailsEnum.accepted &&
      order.offerStatus.toLowerCase() == 'pending') {
    qtyController.text = order.requestedQty.toStringAsFixed(0);
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          dialogTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show qty field only for Accepted
              if (status == OrderDetailsEnum.accepted)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity you can supply',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: Text(confirmText),
            onPressed: () async {
              final qty = status == OrderDetailsEnum.rejected
                  ? 0
                  : int.tryParse(qtyController.text) ?? 0;

              final success = await controller.respondToPreOrder(
                order: order,
                offerStatus: status,
                fulfilledQty: qty,
                description: descController.text,
              );

              if (success) {
                final index = controller.allOrders
                    .indexWhere((o) => o.preOrderId == order.preOrderId);

                if (index != -1) {
                  controller.allOrders[index] = order.copyWith(
                    offerStatus: status.name,
                    fulfilledQty: qty > 0 ? qty.toDouble() : 0,
                    note: descController.text,
                  );
                }

                Navigator.of(dialogContext).pop();
              } else {
                Get.snackbar(
                  'Error',
                  'Failed to respond. Try again.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }

            },
          ),
        ],
      );
    },
  );
}


}
 