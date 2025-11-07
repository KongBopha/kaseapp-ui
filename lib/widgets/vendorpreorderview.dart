import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/vendorpreorder_controller.dart';
import 'package:kaseapp_ui/models/preorder_listing.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/images_converter.dart';
import 'package:kaseapp_ui/utils/pre_order_enum.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';

class VendorPreOrderView extends StatefulWidget {
  const VendorPreOrderView({super.key});

  @override
  State<VendorPreOrderView> createState() => _VendorPreOrderViewState();
}

class _VendorPreOrderViewState extends State<VendorPreOrderView>
    with TickerProviderStateMixin {
  final VendorPreOrderController controller =
      Get.put(VendorPreOrderController(repo: Get.find()));
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: PreOrderStatus.values.length, vsync: this);

    // Pagination with haptic feedback
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          controller.canLoadMore) {
        // Load more items before reaching the exact bottom for better UX
        controller.vendorFilterPreOrder(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: PreOrderStatus.values.length,
      child: Scaffold(
        backgroundColor: AppTheme.pageBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.appbarBackgroundColor,
          elevation: 2,
          title: const Text(
            "Vendor Pre-Orders",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => controller.vendorFilterPreOrder(loadMore: false),
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh pre-orders',
              splashRadius: 24,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TabBar(
                onTap: (index) {
                  final status = PreOrderStatus.values[index];
                  controller.changeStatus(status);
                   if (Theme.of(context).platform == TargetPlatform.iOS) {
 
                  }
                },
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.itemSubTitleColor,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppTheme.APPBAR_COLOR,
                ),
                indicatorPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                 indicatorSize: TabBarIndicatorSize.tab,
                splashBorderRadius: BorderRadius.circular(24),
                tabs: PreOrderStatus.values.map((status) {
                  IconData icon;
                  Color iconColor;

                  switch (status) {
                    case PreOrderStatus.pending:
                      icon = Icons.schedule_rounded;
                      iconColor = Colors.orange.shade600;
                      break;
                    case PreOrderStatus.fulfilled:
                      icon = Icons.check_circle_rounded;
                      iconColor = Colors.green.shade600;
                      break;
                    case PreOrderStatus.partiallyFulfilled:
                      icon = Icons.verified_rounded;
                      iconColor = Colors.blue.shade600;
                      break;
                    case PreOrderStatus.cancelled:
                      icon = Icons.cancel_rounded;
                      iconColor = Colors.red.shade600;
                      break;
                  }

                  return Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 18, color: iconColor),
                          const SizedBox(width: 6),
                          Text(
                            status.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.preOrders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading pre-orders...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          if (controller.preOrders.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              controller.vendorFilterPreOrder(loadMore: false);
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.preOrders.length +
                  (controller.canLoadMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < controller.preOrders.length) {
                  final order = controller.preOrders[index];
                  return Column(
                    children: [
                      _buildPreorderCard(order, index),
                      const SizedBox(height: 16),
                    ],
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    child: const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text(
                            'Loading more...',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }),
      ),
    );
  }

Widget _buildPreorderCard(PreOrderListing order, int index) {
  final bool isPending = order.status.toLowerCase() == 'pending';
  final bool isFulfilled = order.status.toLowerCase() == 'fulfilled';
  final bool isPartiallyFulfilled = order.status.toLowerCase() == 'partially_fulfilled';
  final bool isCancelled = order.status.toLowerCase() == 'cancelled';

  Color statusColor;
  IconData statusIcon;

  if (isPending) {
    statusColor = Colors.orange.shade600;
    statusIcon = Icons.schedule_rounded;
  } else if (isFulfilled) {
    statusColor = Colors.green.shade600;
    statusIcon = Icons.check_circle_rounded;
  } else if (isPartiallyFulfilled) {
    statusColor = Colors.blue.shade600;
    statusIcon = Icons.verified_rounded;
  } else {
    statusColor = Colors.red.shade600;
    statusIcon = Icons.cancel_rounded;
  }

  final imagesConverter = ImagesConverter();
  final productImageUrl = imagesConverter.getProductImageUrl(order.productImage);

  return Card(
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // Navigate to detail view or show bottom sheet
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Product image + name + status badge
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
                      // Product name
                      Text(
                        order.productName,
                        style: TextStyle(
                          color: AppTheme.itemTitleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Quantity badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 14, color: AppTheme.itemSubTitleColor),
                            const SizedBox(width: 4),
                            Text(
                              'Quantity: ${order.quantity}',
                              style: TextStyle(
                                  color: AppTheme.itemSubTitleColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.4)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 18, color: statusColor),
                      const SizedBox(height: 2),
                      Text(
                        order.status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Divider
            Divider(height: 1, color: Colors.grey.shade200),
            
            const SizedBox(height: 12),
            
            // Delivery details section
            Row(
              children: [
                // Location
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TextStyle(
                                color: AppTheme.itemSubTitleColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              order.location,
                              style: TextStyle(
                                color: AppTheme.itemTitleColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Delivery date
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.local_shipping_outlined,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery',
                              style: TextStyle(
                                color: AppTheme.itemSubTitleColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              order.deliveryDate,
                              style: TextStyle(
                                color: AppTheme.itemTitleColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Note section (if exists)
            if (order.note.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note_outlined,
                      size: 16,
                      color: Colors.amber.shade800,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note',
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.note,
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}


  // Widget _buildInfoItem({
  //   required IconData icon,
  //   required String label,
  //   required String value,
  //   required Color valueColor,
  //   bool isFullWidth = false,
  // }) {
  //   return Column(
  //     crossAxisAlignment: isFullWidth 
  //         ? CrossAxisAlignment.start 
  //         : CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
  //         children: [
  //           Icon(
  //             icon,
  //             size: 16,
  //             color: AppTheme.itemSubTitleColor,
  //           ),
  //           const SizedBox(width: 6),
  //           Text(
  //             label,
  //             style: TextStyle(
  //               color: AppTheme.itemSubTitleColor,
  //               fontSize: 13,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 6),
  //       Text(
  //         value,
  //         style: TextStyle(
  //           color: valueColor,
  //           fontSize: 15,
  //           fontWeight: FontWeight.w600,
  //           height: 1.3,
  //         ),
  //         maxLines: isFullWidth ? 3 : 2,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // More engaging empty state
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.itemSubTitleColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 60,
                color: AppTheme.itemSubTitleColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Pre-Orders Found',
              style: TextStyle(
                color: AppTheme.itemTitleColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Switch between tabs to view different\npre-order statuses or pull down to refresh.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.itemSubTitleColor,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            // Action button for empty state
            ElevatedButton.icon(
              onPressed: () => controller.vendorFilterPreOrder(loadMore: false),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.APPBAR_COLOR,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}