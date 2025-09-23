import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/Routes/routes.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';
import 'package:kaseapp_ui/controllers/notification_controller.dart';
import 'package:kaseapp_ui/widgets/app_bar/primary_app_bar.dart';
import '../controllers/middleware/auth_controller.dart';
import 'login_view.dart';
import 'register_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = Get.find();
  final NotificationController _notificationController = Get.find();

  void initState() {
   super.initState();
    _initData();
  }

  Future<void> _initData() async {
     if (!_authController.auth) return;

     await _notificationController.fetchNotifications();
  }

  void _handleRestrictedNav({
    required List<String> allowedRoles,
    required String route,
    required String roleName,
  }) {
    if (allowedRoles.contains(_authController.role)) {
      Get.toNamed(route);
    } else {
      Get.dialog(
        AlertDialog(
          title: Text("Access Denied"),
          content: Text("You must become a $roleName to access this feature."),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                if (roleName == "Farmer") {
                  Get.toNamed(AppRoutes.farmerRequest);
                } else if (roleName == "Vendor") {
                  Get.toNamed(AppRoutes.vendorRequest);
                }
              },
              child: Text("Become a $roleName"),
            ),
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
          automaticallyImplyLeading: false,
          onTap: () {},
          onSearch: () => {},
        actions: [
          // Notification Icon with badge
          Obx(() => Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_active, color: AppTheme.APPBAR_COLOR),
                onPressed: () {
                   Get.toNamed(AppRoutes.SummaryView);
                },
              ),
              if (_notificationController.count.value > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_notificationController.count.value}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Banner carousel ---
            SizedBox(
              width: double.infinity,
              height: 160,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 160.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                ),
                items: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/image2.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/image3.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 2x2 Grid ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGridItem(
                  icon: Icons.qr_code_scanner,
                  label: 'Trace',
                  color: Colors.green,
                  onTap: () => Get.toNamed(AppRoutes.track),
                ),
                _buildVerticalDivider(),
                _buildGridItem(
                  icon: Icons.agriculture,
                  label: 'Farm',
                  color: Colors.green,
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
                  color: Colors.green,
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
                  color: Colors.green,
                  onTap: () => Get.toNamed(AppRoutes.marketView),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- Auth Section ---
            Obx(() {
              List<Widget> cards = [];
              if (!_authController.auth) {
                cards.addAll([
                  _buildAuthCard(
                    color: const Color.fromARGB(255, 77, 116, 175),
                    title: "Account Sign In",
                    subtitle: "Click here to sign into your account",
                    onTap: () => Get.to(() => LoginView()),
                  ),
                  _buildAuthCard(
                    color: const Color.fromARGB(255, 66, 148, 100),
                    title: "Register",
                    subtitle: "Click here register an account",
                    onTap: () => Get.to(() => RegisterTestView()),
                  ),
                ]);
              } else {
                cards.addAll([
                  _buildAuthCard(
                    color: const Color.fromARGB(255, 77, 116, 175),
                    title: "Become a Farmer",
                    subtitle: "Click to request farmer role to access FARM features",
                    onTap: () => Get.toNamed(AppRoutes.farmerRequest),
                  ),
                  _buildAuthCard(
                    color: const Color.fromARGB(255, 66, 148, 100),
                    title: "Open a Vendor",
                    subtitle: "Click here to request Vendor role",
                    onTap: () => Get.toNamed(AppRoutes.vendorRequest),
                  ),
                ]);
              }
              return Column(
                children: cards,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Column(
        children: [
          IconButton(
            onPressed: onTap,
            icon: Icon(icon),
            color: color,
            iconSize: 80,
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return const SizedBox(
      height: 100,
      child: VerticalDivider(thickness: 2, color: Colors.green),
    );
  }

  Widget _buildAuthCard({
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
            const SizedBox(height: 5),
            Text(subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
