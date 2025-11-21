import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/receive_order_respond_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/vendor_receive_preorder_model.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/images_converter.dart';
import 'package:kaseapp_ui/utils/order_details_enum.dart';
import 'package:kaseapp_ui/models/user_model.dart';

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

  final List<String?> statuses = [null, 'accepted', 'rejected', 'confirmed'];

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
        title: const Text("Your response from farms"),
        bottom: TabBar(
          controller: _tabController,
          tabs: statuses.map((s) => Tab(text: s?.capitalize ?? 'All')).toList(),
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
            itemCount: controller.receiveOrders.length + (controller.canLoadMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.receiveOrders.length) {
                return VendorReceiveOrderCardStateful(orderIndex: index);
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

class VendorReceiveOrderCardStateful extends StatefulWidget {
  final int orderIndex;
  const VendorReceiveOrderCardStateful({super.key, required this.orderIndex});

  @override
  State<VendorReceiveOrderCardStateful> createState() =>
      _VendorReceiveOrderCardStatefulState();
}

class _VendorReceiveOrderCardStatefulState extends State<VendorReceiveOrderCardStateful> {
  final ReceiveOrderRespondController controller = Get.find();

  void _showFarmerProfile(BuildContext context, VendorReceivePreorderModel orderDetailId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final userController = Get.find<UserController>();
      await userController.fetchOtherUserProfile(orderDetailId.userId);

      Navigator.of(context).pop(); // Close loading indicator

      if (userController.otherUser.value != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtherProfileScreen(
              user: userController.otherUser.value!,
            ),
          ),
        );
      } else {
        Get.snackbar('Error', 'Farmer profile not found', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar('Error', 'Failed to load farmer profile', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preOrder = controller.receiveOrders[widget.orderIndex];
    final isActionable = preOrder.status == OrderDetailsEnum.pending ||
        preOrder.status == OrderDetailsEnum.accepted;
    final imagesConverter = ImagesConverter();
    final productImageUrl = imagesConverter.getProductImageUrl(preOrder.productImage);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE: DETAILS
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(preOrder.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _showFarmerProfile(context, preOrder),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'From ${preOrder.farmName}',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.person, size: 16, color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Quantity offered: ${preOrder.fulfilledQty} kg',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Delivery: ${preOrder.deliveryDate}'),
                  const SizedBox(height: 4),
                  Text('Location: ${preOrder.location}'),
                  if (preOrder.note != null && preOrder.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Note: ${preOrder.note}', overflow: TextOverflow.ellipsis),
                  ],
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _statusColor(preOrder.status, isActionable),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(preOrder.status.name.capitalizeFirst!,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isActionable
                              ? () {
                                  controller.respondToOffer(
                                      orderDetailId: preOrder.orderDetailId,
                                      status: OrderDetailsEnum.confirmed);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isActionable ? Colors.blueAccent : Colors.grey),
                          child: const Text('Confirm', overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isActionable
                              ? () {
                                  controller.respondToOffer(
                                      orderDetailId: preOrder.orderDetailId,
                                      status: OrderDetailsEnum.rejected);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isActionable ? Colors.redAccent : Colors.grey),
                          child: const Text('Reject', overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(width: 12),

            // RIGHT SIDE: PRODUCT IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: preOrder.productImage != null && preOrder.productImage!.isNotEmpty
                  ? Image.network(
                      productImageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(AppImage.orderIcon,
                            width: 100, height: 100, fit: BoxFit.cover);
                      },
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}



  Color _statusColor(OrderDetailsEnum status, bool isActionable) {
    if (isActionable) {
      switch (status) {
        case OrderDetailsEnum.pending:
          return Colors.orange;
        case OrderDetailsEnum.accepted:
          return Colors.green;
        default:
          return Colors.grey;
      }
    } else {
      switch (status) {
        case OrderDetailsEnum.confirmed:
          return Colors.blue;
        case OrderDetailsEnum.rejected:
          return Colors.red;
        default:
          return Colors.grey;
      }
    }
  }

// Enhanced Profile Screen
class OtherProfileScreen extends StatelessWidget {
  final UserModel user;
  const OtherProfileScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(user.firstName ?? 'Profile'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      _getInitials(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getRoleColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.role,
                      style: TextStyle(
                        color: _getRoleColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Contact Information',
              icon: Icons.contact_mail,
              children: [
                _buildInfoTile(icon: Icons.email_outlined, label: 'Email', value: user.email ?? 'Not provided'),
              ],
            ),
            if (user.vendor != null) ...[
              const SizedBox(height: 16),
              _buildSection(
                title: 'Vendor Information',
                icon: Icons.business,
                children: [
                  _buildInfoTile(icon: Icons.store, label: 'Vendor Shop', value: user.vendor?.companyName ?? 'N/A'),
                  _buildInfoTile(icon: Icons.category, label: 'Vendor Type', value: user.vendor?.vendorType ?? 'N/A'),
                  _buildInfoTile(icon: Icons.location_on_outlined, label: 'Address', value: user.vendor?.address ?? 'N/A', maxLines: 2),
                ],
              ),
            ],
            if (user.farm != null) ...[
              const SizedBox(height: 16),
              _buildSection(
                title: 'Farm Information',
                icon: Icons.agriculture,
                children: [
                  _buildInfoTile(icon: Icons.landscape, label: 'Farm Name', value: user.farm?.name ?? 'N/A'),
                  _buildInfoTile(icon: Icons.location_on_outlined, label: 'Address', value: user.farm?.address ?? 'N/A', maxLines: 2),
                  _buildInfoTile(icon: Icons.info_outline, label: 'Status', value: user.farm?.status.toString() ?? 'N/A'),
                ],
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getInitials() {
    String initials = '';
    if (user.firstName != null && user.firstName!.isNotEmpty) {
      initials += user.firstName![0].toUpperCase();
    }
    if (user.lastName != null && user.lastName!.isNotEmpty) {
      initials += user.lastName![0].toUpperCase();
    }
    return initials.isEmpty ? '?' : initials;
  }

  Color _getRoleColor() {
    final role = user.role.toLowerCase();
    if (role.contains('admin')) return Colors.red[700]!;
    if (role.contains('vendor')) return Colors.orange[700]!;
    if (role.contains('farmer')) return Colors.green[700]!;
    return Colors.blue[700]!;
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required String label, required String value, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500), maxLines: maxLines, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
