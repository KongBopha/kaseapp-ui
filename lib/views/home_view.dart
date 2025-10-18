import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/Routes/routes.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';
import 'package:kaseapp_ui/controllers/notification_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/widgets/app_bar/primary_app_bar.dart';
import 'login_view.dart';
import 'register_view.dart';

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
  //  Authentication Section
  // ------------------------------------------------
  Widget _buildAuthSection() {
    return Obx(() {
      final isLoggedIn = _authController.auth;

      final cards = isLoggedIn
          ? [
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
            ]
          : [
              _buildAuthCard(
                title: "Account Sign In",
                subtitle: "Click here to sign into your account",
                color: const Color(0xFF4D74AF),
                onTap: () => Get.to(() =>   LoginView()),
              ),
              _buildAuthCard(
                title: "Register",
                subtitle: "Click here to create a new account",
                color: const Color(0xFF429464),
                onTap: () => Get.to(() => const RegisterTestView()),
              ),
            ];

      return Column(children: cards);
    });
  }

  Widget _buildAuthCard({
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const SizedBox(height: 5),
              Text(subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
