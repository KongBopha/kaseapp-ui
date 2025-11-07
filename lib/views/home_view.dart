import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/Routes/routes.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';
import 'package:kaseapp_ui/controllers/notification_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/widgets/app_bar/primary_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = Get.find();
  final NotificationController _notificationController = Get.find();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    if (_authController.auth) {
      await _notificationController.fetchNotifications();
    }
  }

  void _handleRestrictedNav({
    required List<String> allowedRoles,
    required String route,
    required String roleName,
  }) {
    final userRole = _authController.role;
    final isAuthorized = allowedRoles.contains(userRole);

    if (isAuthorized) {
      Get.toNamed(route);
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text("Access Denied"),
        content: Text("You must become a $roleName to access this feature."),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Disable upgrade if user already has another role
              if (userRole == 'farmer' && roleName == 'Vendor') {
                Get.snackbar(
                  'Access Restricted',
                  'You are already a Farmer and cannot upgrade to Vendor.',
                  backgroundColor: Colors.red.shade400,
                  colorText: Colors.white,
                );
                return;
              } else if (userRole == 'vendor' && roleName == 'Farmer') {
                Get.snackbar(
                  'Access Restricted',
                  'You are already a Vendor and cannot upgrade to Farmer.',
                  backgroundColor: Colors.red.shade400,
                  colorText: Colors.white,
                );
                return;
              }

              Get.toNamed(
                roleName == "Farmer"
                    ? AppRoutes.farmerRequest
                    : AppRoutes.vendorRequest,
              );
            },
            child: Text("Become a $roleName"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        automaticallyImplyLeading: false,
        onTap: () {},
        onSearch: () {},
        actions: [_buildNotificationIcon()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildBannerCarousel(),
            const SizedBox(height: 20),
            _buildFeatureGrid(),
            const SizedBox(height: 30),
            _buildAuthSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Obx(() {
      final count = _notificationController.count.value;
      return Stack(
        children: [
          IconButton(
            icon: Icon(Icons.notifications_active, color: AppTheme.APPBAR_COLOR),
            onPressed: () => Get.toNamed(AppRoutes.SummaryView),
          ),
          if (count > 0)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildBannerCarousel() {
    final images = [
      'lib/assets/image2.png',
      'lib/assets/image3.png',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
      ),
      items: images.map((path) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(path),
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeatureGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildGridItem(
              icon: Icons.qr_code_scanner,
              label: 'Trace',
              onTap: () => Get.toNamed(AppRoutes.track),
            ),
            _buildVerticalDivider(),
            _buildGridItem(
              icon: Icons.agriculture,
              label: 'Farm',
              onTap: () => _handleRestrictedNav(
                allowedRoles: ['farmer'],
                route: AppRoutes.farmerFrontView,
                roleName: "Farmer",
              ),
            ),
          ],
        ),
        const Divider(thickness: 2, color: Colors.green, height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildGridItem(
              icon: Icons.storefront,
              label: 'Vendor',
              onTap: () => _handleRestrictedNav(
                allowedRoles: ['vendor'],
                route: AppRoutes.vendorFrontView,
                roleName: "Vendor",
              ),
            ),
            _buildVerticalDivider(),
            _buildGridItem(
              icon: Icons.bar_chart_sharp,
              label: 'Market',
              onTap: () => Get.toNamed(AppRoutes.marketView),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGridItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    const color = Colors.green;

    return Expanded(
      child: Column(
        children: [
          IconButton(
            onPressed: onTap,
            icon: Icon(icon, size: 70, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() => const SizedBox(
        height: 100,
        child: VerticalDivider(thickness: 2, color: Colors.green),
      );

  // ------------------------------------------------
  //  Authentication / Role Section
  // ------------------------------------------------
  Widget _buildAuthSection() {
    return Obx(() {
      final role = _authController.role; 

      if (role == 'consumer') {
        // Show upgrade role options
        return Column(
          children: [
            _buildAuthCard(
              title: "Become a Farmer",
              subtitle: "Request a farmer role to access FARM features",
              color: const Color(0xFF4D74AF),
              onTap: () => Get.toNamed(AppRoutes.farmerRequest),
            ),
            _buildAuthCard(
              title: "Open a Vendor",
              subtitle: "Request a vendor role to access MARKET features",
              color: const Color(0xFF429464),
              onTap: () => Get.toNamed(AppRoutes.vendorRequest),
            ),
          ],
        );
      } else if (role == 'farmer') {
        // Show farmer banner (cannot upgrade)
        return _buildBannerMessage(
          title: "Welcome, Farmer!",
          message:
              "You can manage your farm, sell products, and connect with vendors.",
          color: const Color(0xFF4D74AF),
        );
      } else if (role == 'vendor') {
        // Show vendor banner (cannot upgrade)
        return _buildBannerMessage(
          title: "Welcome, Vendor!",
          message:
              "You can pre-order products from farmers and manage your pre-orders.",
          color: const Color(0xFF429464),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildAuthCard({
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerMessage({
    required String title,
    required String message,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
