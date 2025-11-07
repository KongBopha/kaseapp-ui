import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/Routes/routes.dart';
import 'package:kaseapp_ui/controllers/pre_order_controller.dart';
import 'package:kaseapp_ui/models/preorder_vendor_listing.dart';
import 'package:kaseapp_ui/utils/constants/images_converter.dart';
class PreOrderFrontView extends StatefulWidget {
  const PreOrderFrontView({super.key});

  @override
  State<PreOrderFrontView> createState() => _PreOrderFrontViewState();
}

class _PreOrderFrontViewState extends State<PreOrderFrontView> {
  final TextEditingController _searchController = TextEditingController();
  final PreOrderController preOrderController = Get.find<PreOrderController>();

  String? _selectedTimeFilter;

  @override
  void initState() {
    super.initState();
    preOrderController.fetchPreorder();
  }
  // generate receipt id
  String _generateReceiptId(int realId) {
  final randomPart = (realId * 9973) % 100000;  
  return 'PR-${randomPart.toString().padLeft(5, '0')}';
}


  void _clearFilters() {
    _searchController.clear();
    _selectedTimeFilter = null;
    preOrderController.timeFilter.value = 'all';
    preOrderController.setFilters(search: '', timeFilterParam: 'all');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTimeFilterButtons(),
          _buildPreOrdersList(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Go back',
      ),
      title: const Text(
        'Pre-Orders',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed(AppRoutes.vendorOrders),
      backgroundColor: Colors.green.shade600,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.add, size: 20),
      label: const Text(
        'New Order',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      tooltip: 'Create new pre-order',
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          preOrderController.setFilters(search: value);
        },
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade600, size: 20),
                  onPressed: _clearFilters,
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade400, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeFilterButtons() {
    final filters = ['all', 'today', 'this_week', 'next_week'];
    final labels = ['All', 'Today', 'This Week', 'Next Week'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(filters.length, (index) {
          final filter = filters[index];
          final label = labels[index];
          final isSelected = _selectedTimeFilter == filter;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeFilter = filter;
                });
                preOrderController.timeFilter.value = filter;
                preOrderController.fetchPreorder(
                  page: 1,
                  search: preOrderController.searchQuery.value,
                  timeFilterParam: filter,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green.shade600 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPreOrdersList() {
    return Expanded(
      child: Obx(() {
        if (preOrderController.isLoading.value &&
            preOrderController.preOrderListing.isEmpty) {
          return _buildLoadingState();
        }

        if (preOrderController.preOrderListing.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Text(
                '${preOrderController.preOrderListing.length} orders found',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: preOrderController.preOrderListing.length,
                itemBuilder: (context, index) {
                  final order = preOrderController.preOrderListing[index];
                  return _buildPreOrderCard(order, index);
                },
              ),
            ),
            _buildPagination(),
          ],
        );
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading pre-orders...',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No pre-orders found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.vendorOrders),
            icon: const Icon(Icons.add),
            label: const Text('Create First Order'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildPreOrderCard(PreOrderListItem order, int index) {
  final status = order.status;
  final statusColor = _getStatusColor(status);
  final statusBgColor = _getStatusBackgroundColor(status);
  final imageConverter = ImagesConverter();
  final productImageUrl = imageConverter.getProductImageUrl(order.productImage);

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
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
      border: Border.all(
        color: Colors.grey.shade200,
        width: 1,
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PR-${_generateReceiptId(order.id)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black87,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Product Info
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      productImageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.green.shade600,
                          size: 40,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${order.quantity} kg",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _showEditDialog(context, order);
                        },
                        icon: Icon(Icons.edit, color: Colors.blue.shade600),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete PR-${order.id}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final success = await preOrderController.deletePreOrder(order.id);
                            if (!success) {
                              Get.snackbar('Error', 'Failed to delete order',
                                  backgroundColor: Colors.red.shade400, colorText: Colors.white);
                            }
                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.red.shade600),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Delivery Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Delivery: ",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      order.deliveryDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
void _showEditDialog(BuildContext context, PreOrderListItem order) {
  final TextEditingController quantityController = 
      TextEditingController(text: order.quantity.toString());
  final TextEditingController deliveryDateController =
      TextEditingController(text: order.deliveryDate);

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Edit Pre-Order #PR-${order.id}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product name (read-only)
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Product',
                  border: const OutlineInputBorder(),
                  hintText: order.productName,
                ),
              ),
              const SizedBox(height: 12),
              
              // Quantity field (editable)
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Delivery date field (editable with date picker)
              TextField(
                controller: deliveryDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Delivery Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.tryParse(order.deliveryDate) ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        deliveryDateController.text =
                            pickedDate.toIso8601String().split('T').first;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              final updatedOrder = {
                'quantity': quantityController.text,
                'delivery_date': deliveryDateController.text,
              }; 

              final success = await preOrderController.updatePreOrder(id: order.id, updates: updatedOrder);
              if (success) {
                Get.snackbar(
                  'Success',
                  'Pre-order updated successfully',
                  backgroundColor: Colors.green.shade400,
                  colorText: Colors.white,
                );
                Navigator.pop(ctx);
              } else {
                Get.snackbar(
                  'Error',
                  'Failed to update order',
                  backgroundColor: Colors.red.shade400,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}


  Widget _buildPagination() {
    return Obx(() {
      if (preOrderController.lastPage.value <= 1) {
        return const SizedBox.shrink();
      }

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: preOrderController.lastPage.value,
            itemBuilder: (context, index) {
              final pageNumber = index + 1;
              final isActive = pageNumber == preOrderController.currentPage.value;

              return GestureDetector(
                onTap: () => preOrderController.jumpToPage(pageNumber),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green.shade600 : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive ? Colors.green.shade600 : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      pageNumber.toString(),
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade700;
      case 'accepted':
        return Colors.green.shade700;
      case 'expired':
        return Colors.red.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade50;
      case 'accepted':
        return Colors.green.shade50;
      case 'expired':
        return Colors.red.shade50;
      default:
        return Colors.blue.shade50;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
