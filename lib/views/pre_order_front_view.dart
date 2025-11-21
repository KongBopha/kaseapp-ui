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
  final ScrollController _scrollController = ScrollController();
  String? _selectedTimeFilter;

  @override
  void initState() {
    super.initState();
    preOrderController.fetchPreorder();

    // Automatic fetch when scrolling near the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !preOrderController.isLoading.value &&
          preOrderController.currentPage.value < preOrderController.lastPage.value) {
        preOrderController.fetchPreorder(
            page: preOrderController.currentPage.value + 1);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _searchController.clear();
    _selectedTimeFilter = null;
    preOrderController.timeFilter.value = 'all';
    preOrderController.setFilters(search: '', timeFilterParam: 'all');
  }

  String _generateReceiptId(int realId) {
    final randomPart = (realId * 9973) % 100000;
    return 'PR-${randomPart.toString().padLeft(5, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTimeFilterButtons(),
          Expanded(child: _buildPreOrdersList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Pre-Orders',
        style: TextStyle(
            color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Colors.grey.shade200),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed(AppRoutes.vendorOrders),
      backgroundColor: Colors.green.shade600,
      icon: const Icon(Icons.add),
      label: const Text('New Order'),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => preOrderController.setFilters(search: value),
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear), onPressed: _clearFilters)
              : null,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
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
                setState(() => _selectedTimeFilter = filter);
                preOrderController.timeFilter.value = filter;
                preOrderController.fetchPreorder(
                    page: 1,
                    search: preOrderController.searchQuery.value,
                    timeFilterParam: filter);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green.shade600 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(label,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPreOrdersList() {
    return Obx(() {
      if (preOrderController.isLoading.value &&
          preOrderController.preOrderListing.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (preOrderController.preOrderListing.isEmpty) {
        return Center(child: Text('No pre-orders found'));
      }

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: preOrderController.preOrderListing.length +
            (preOrderController.isLoading.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < preOrderController.preOrderListing.length) {
            final order = preOrderController.preOrderListing[index];
            return _buildPreOrderCard(order);
          } else {
            // Show loading indicator at the bottom while fetching more
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                ),
              ),
            );
          }
        },
      );
    });
  }

  Widget _buildPreOrderCard(PreOrderListItem order) {
    final statusColor = _getStatusColor(order.status);
    final statusBgColor = _getStatusBackgroundColor(order.status);
    final productImageUrl = ImagesConverter().getProductImageUrl(order.productImage);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${_generateReceiptId(order.id)}",
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3))),
                child: Text(order.status.toUpperCase(),
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Product info + actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  productImageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.inventory_2_outlined, color: Colors.green.shade600, size: 60),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.productName,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text("Quantity: ${order.quantity}", style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.local_shipping_outlined, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text("Delivery: ", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                        Text(order.deliveryDate,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () => _showEditDialog(context, order),
                    icon: Icon(Icons.edit, color: Colors.blue.shade600),
                  ),
                  IconButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text('Are you sure you want to delete ${_generateReceiptId(order.id)}?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await preOrderController.deletePreOrder(order.id);
                      }
                    },
                    icon: Icon(Icons.delete, color: Colors.red.shade600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
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

 void _showEditDialog(BuildContext context, PreOrderListItem order) {
  final TextEditingController quantityController =
      TextEditingController(text: order.quantity.toString());
  final TextEditingController deliveryDateController =
      TextEditingController(text: order.deliveryDate);

  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Pre-Order #${_generateReceiptId(order.id)}',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Product Name (Read-only)
              _modernTextField('Product', order.productName, enabled: false),

              const SizedBox(height: 16),

              // Quantity
              _modernTextField('Quantity (kg)', quantityController, keyboardType: TextInputType.number),

              const SizedBox(height: 16),

              // Delivery Date with picker
              _modernDateField(ctx, 'Delivery Date', deliveryDateController),

              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16,color: Colors.black)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedOrder = {
                        'qty': quantityController.text,
                        'delivery_date': deliveryDateController.text,
                      };

                      final success = await preOrderController.updatePreOrder(
                          id: order.id, updates: updatedOrder);
                      if (success) {
                        Get.snackbar('Success', 'Pre-order updated successfully',
                            backgroundColor: Colors.green.shade400, colorText: Colors.white);
                        Navigator.pop(ctx);
                      } else {
                        Get.snackbar('Error', 'You cannot update this pre order',
                            backgroundColor: Colors.red.shade400, colorText: Colors.white);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 16,color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Modern text field
Widget _modernTextField(String label, dynamic controllerOrValue,
    {bool enabled = true, TextInputType keyboardType = TextInputType.text}) {
  return TextField(
    controller: controllerOrValue is TextEditingController ? controllerOrValue : null,
    enabled: enabled,
    readOnly: !enabled,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      hintText: enabled ? null : controllerOrValue.toString(),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}

// Modern date picker field
Widget _modernDateField(BuildContext ctx, String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    readOnly: true,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_today, color: Colors.blue),
        onPressed: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: ctx,
            initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            controller.text = pickedDate.toIso8601String().split('T').first;
          }
        },
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}

}
