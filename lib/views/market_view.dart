import 'package:flutter/cupertino.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/marketsupply_controller.dart';
import 'package:kaseapp_ui/configs/routes/routes.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/images_converter.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Controller & Image converter initialization
    final MarketsupplyController marketController =
        Get.put(MarketsupplyController(
      marketSupplyRepositories: Get.find(),
    ));
    final imagesConverter = ImagesConverter();

    // Fetch data on init
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
            const SizedBox(
              height: 20.0,
            ),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Market Place",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        "July, 10, 2024",
                        style: TextStyle(
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
            SizedBox(
              height: size.height * 0.03,
            ),
            
            // Banner/Poster Section with CarouselSlider
            CarouselSlider(
              options: CarouselOptions(
                height: 160.0,
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                aspectRatio: 3.5,
                enlargeCenterPage: true,
              ),
              items: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(149, 157, 165, 0.2),
                        blurRadius: 24,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF4CAF50),
                        Color(0xFF8BC34A),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Fresh Market',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(149, 157, 165, 0.2),
                        blurRadius: 24,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFF9800),
                        Color(0xFFFFB74D),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Best Quality',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(149, 157, 165, 0.2),
                        blurRadius: 24,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2196F3),
                        Color(0xFF64B5F6),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Fair Prices',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(
              height: size.height * 0.03,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Trending Product",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            
            // Trending Products Section (API data)
            Obx(() {
              if (marketController.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (marketController.trendingProducts.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Center(
                    child: Text(
                      "No trending products found.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...marketController.trendingProducts.map((product) {
                        return Row(
                          children: [
                            TrendingCard(
                              productName: product.productName,
                              productDescription: "${product.preOrderCount} pre-orders",
                              productPrice: "0.0", // You may want to add price to the model
                              productRating: 4.5, // You may want to add rating to the model
                              imageUrl: imagesConverter.getProductImageUrl(product.productImage),
                              unit: product.unit,
                              isFromAPI: true,
                            ),
                            const SizedBox(width: 20.0),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }),

            SizedBox(
              height: size.height * 0.03,
            ),

            // Market Cards Section (API data)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Market View",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "View all",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            // Market Cards Section (API data)
            Obx(() {
              if (marketController.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (marketController.market_supplies.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      "No market supplies found.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              }

              // Build horizontal scrollable market cards from API data
              List<Widget> marketCards = [];
              final supplies = marketController.market_supplies;

              for (var supply in supplies) {
                marketCards.add(
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: MarketCard(
                      productName: supply.productName,
                      productPrice: supply.availableQty.toString(),
                      imageUrl: imagesConverter.getProductImageUrl(supply.productImage),
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(children: marketCards),
                ),
              );
            }),

            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class MarketCard extends StatelessWidget {
  const MarketCard({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.imageUrl,
  });

  final String productPrice;
  final String productName;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Fixed width for horizontal scrolling
      height: 70,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 249, 249, 249),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1.1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      productName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.currency_exchange,
                        size: 18,
                        color: Color.fromARGB(255, 255, 68, 99),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          "$productPrice/kg",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
    required this.productPrice,
    required this.productRating,
    this.unit,
    this.isFromAPI = false,
    this.onTap
  });

  final String productName;
  final String productPrice;
  final String productDescription;
  final double productRating;
  final String imageUrl;
  final String? unit;
  final bool isFromAPI;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.5 - 20,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: const Color.fromARGB(255, 249, 249, 249),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: isFromAPI ? NetworkImage(imageUrl) : AssetImage(imageUrl) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 15,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    width: 28,
                    height: 32,
                    child: const Icon(Icons.bookmark_outline),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isFromAPI ? (unit != null ? "${unit!}" : "Per unit") : "\$$productPrice/Kg",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 22.0,
                      color: Colors.amber,
                    ),
                    Text(
                      productRating.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              productName,
              style: const TextStyle(
                fontSize: 16,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              productDescription,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}