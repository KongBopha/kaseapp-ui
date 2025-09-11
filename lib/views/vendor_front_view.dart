import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/routes/routes.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';

class VendorFrontView extends StatefulWidget {
  const VendorFrontView({super.key});

  @override
  State<VendorFrontView> createState() => _VendorFrontViewState();
}

class _VendorFrontViewState extends State<VendorFrontView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      backgroundColor: AppTheme.pageBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: AppTheme.appbarBackgroundColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Vendor Portal',
                        style: TextStyle(
                          color: AppTheme.btnTextNormalColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Manage your agricultural orders with ease.',
                        style: TextStyle(
                          color: AppTheme.btnTextNormalColor.withOpacity(0.85),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Quick Actions Title
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    color: AppTheme.pageTitleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Actions Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.85,
                  children: [
                    _buildFeatureCard(
                      context: context,
                      title: 'Pre-Orders',
                      subtitle: 'Create and manage pre-order requests',
                      icon: Icons.add_shopping_cart,
                      color: Colors.green,  
                      onTap: () {
                        Get.toNamed(AppRoutes.vendorOrders);
                      },
                    ),
                    _buildFeatureCard(
                      context: context,
                      title: 'Order History',
                      subtitle: 'Track completed and past orders',
                      icon: Icons.history,
                      color: AppTheme.btnNormalColor,
                      onTap: () {
                        // Get.toNamed('/my${AppRoutes.orderSubHistoryView}');
                      },
                    ),
                    _buildFeatureCard(
                      context: context,
                      title: 'Receive Orders',
                      subtitle: 'View and accept incoming orders',
                      icon: Icons.inventory_2_outlined,
                      color: Colors.orange, // Retained original color
                      onTap: () {
                        Get.toNamed('/my${AppRoutes.orderRespond}');
                      },
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

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    title.tr,
                    style: TextStyle(
                      color: AppTheme.itemTitleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.itemSubTitleColor.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Arrow Indicator
            Positioned(
              top: 12,
              right: 12,
              child: Icon(
                Icons.arrow_forward_ios,
                color: color.withOpacity(0.5),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}