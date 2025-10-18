import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/routes/routes.dart';
import 'package:kaseapp_ui/controllers/marketsupply_controller.dart';
import 'package:kaseapp_ui/utils/constants/images_converter.dart';
import 'package:kaseapp_ui/views/pre_order_view.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Initialize Controller & Image converter
    final MarketsupplyController marketController =
        Get.put(MarketsupplyController(
      marketSupplyRepositories: Get.find(),
    ));
    final imagesConverter = ImagesConverter();

    // Fetch data when screen opens
    marketController.fetchMarketSupplies();
    marketController.fetchTrendingProducts();

    return Scaffold(
      appBar: const MyAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Market Surplus",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                        style: const TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.03),

            // 🔹 Banner Section
            CarouselSlider(
              options: CarouselOptions(
                height: 160.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: [
                _buildBanner("Fresh Market", [Color(0xFF4CAF50), Color(0xFF8BC34A)]),
                _buildBanner("Best Quality", [Color(0xFFFF9800), Color(0xFFFFB74D)]),
                _buildBanner("Fair Prices", [Color(0xFF2196F3), Color(0xFF64B5F6)]),
              ],
            ),

            SizedBox(height: size.height * 0.03),

            //  Trending Product Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Trending Products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: size.height * 0.02),

            Obx(() {
              if (marketController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (marketController.trendingProducts.isEmpty) {
                return const Center(
                  child: Text("No trending products found."),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: marketController.trendingProducts.map((product) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TrendingCard(
                              productName: product.productName,
                              productDescription: "${product.preOrderCount} pre-orders",        
                              imageUrl: imagesConverter.getProductImageUrl(product.productImage),
                              unit: product.unit,
                              isFromAPI: true,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }),

            SizedBox(height: size.height * 0.03),

            //Surplus Market View Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Available Market Surplus",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            Obx(() {
              if (marketController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (marketController.market_supplies.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "No market supplies found.",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: marketController.market_supplies.map((supply) {
                    return MarketSupplyCard(
                      supply: supply,
                      onRequestTap: () {
                        Get.toNamed(
                          AppRoutes.vendorOrders,
                          arguments: {'supply': supply},
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            }),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  //  Banner Helper Widget
  Widget _buildBanner(String title, List<Color> colors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        gradient: LinearGradient(colors: colors),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MarketSupplyCard extends StatelessWidget {
  final dynamic supply;
  final VoidCallback onRequestTap;

  const MarketSupplyCard({
    super.key,
    required this.supply,
    required this.onRequestTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            supply.productImage,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          supply.productName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Farm: ${supply.farmName}\n'
          'Available: ${supply.availableQty} ${supply.unit}\n'
          'Date: ${DateFormat('MMM dd, yyyy').format(supply.availability)}',
          style: const TextStyle(height: 1.5),
        ),
        trailing:ElevatedButton(
          onPressed: () {
            final supplyData = {
              'market_supply_id': supply.id,
              'product_id': supply.productId,
              'product_name': supply.productName,
              'farm_id': supply.farmId,
              'available_qty': supply.availableQty,
              'unit': supply.unit,
              'product_image': supply.productImage,
            };

            Get.to(() => PreOrderRequestView(preFilledData: supplyData));
          },
          child: const Text('Request order'),
        )
      ),
    );
  }
}

 class TrendingCard extends StatelessWidget {
  const TrendingCard({
    super.key,
    required this.productDescription,
    required this.imageUrl,
    required this.productName,
    this.unit,
    this.isFromAPI = false,
  });

  final String productName;
  final String productDescription;
  final String imageUrl;
  final String? unit;
  final bool isFromAPI;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.5 - 20,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: const Color.fromARGB(255, 249, 249, 249),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            productName,
            style: const TextStyle(
              fontSize: 16,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            productDescription,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
