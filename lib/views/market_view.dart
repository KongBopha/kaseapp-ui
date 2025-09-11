import 'package:flutter/cupertino.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaseapp_ui/configs/routes/routes.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            const Padding(
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
                    backgroundImage: AssetImage(
                      "lib/assets/image.png",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            CarouselSlider(
              options: CarouselOptions(
                // height: 160.0,
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                aspectRatio: 3.5,
                enlargeCenterPage: true,
              ),
              items: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(149, 157, 165, 0.2),
                          blurRadius: 24,
                          spreadRadius: 0,
                          offset: Offset(
                            0,
                            8,
                          ),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      image: DecorationImage(
                        image: AssetImage('lib/assets/banner1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    )),
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(149, 157, 165, 0.2),
                        blurRadius: 24,
                        spreadRadius: 0,
                        offset: Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    image: DecorationImage(
                      image: AssetImage('lib/assets/banner2.jpg'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(149, 157, 165, 0.2),
                        blurRadius: 24,
                        spreadRadius: 0,
                        offset: Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    image: DecorationImage(
                      image: AssetImage('lib/assets/banner3.jpg'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: Container(
            //     width: size.width,
            //     height: size.height * 0.14,
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //         image: const AssetImage("lib/assets/tomato.png"),
            //         fit: BoxFit.cover,
            //         colorFilter: ColorFilter.mode(
            //             Colors.black.withOpacity(0.1), BlendMode.multiply),
            //       ),
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //     child: const Padding(
            //       padding: EdgeInsets.all(20.0),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             "Increase Local Market",
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 20,
            //               fontWeight: FontWeight.w500,
            //               letterSpacing: 1.0,
            //             ),
            //           ),
            //           Text(
            //             "Demand",
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 20,
            //               fontWeight: FontWeight.w500,
            //               letterSpacing: 1.0,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
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
                  // Text(
                  //   "View all",
                  //   style: TextStyle(
                  //     fontSize: 12.0,
                  //     color: Colors.black54,
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TrendingCard(
                      productName: "Tomatoes",
                      productDescription: "Best selling product",
                      productPrice: "4.5",
                      productRating: 3.5,
                      imageUrl: "lib/assets/blueberry.jpg",
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    TrendingCard(
                      productName: "Cherry",
                      productDescription: "High rating product",
                      productPrice: "7.8",
                      productRating: 5.0,
                      imageUrl: "lib/assets/vegetable.jpg",
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    TrendingCard(
                      productName: "Strawberry",
                      productDescription: "Most buying product",
                      productPrice: "6.3",
                      productRating: 10.2,
                      imageUrl: "lib/assets/strawberry.jpg",
                      onTap: () => Get.toNamed('/my${AppRoutes}'),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    TrendingCard(
                      productName: "Banana",
                      productDescription: "Best selling product",
                      productPrice: "4.5",
                      productRating: 3.5,
                      imageUrl: "lib/assets/banana.jpg",
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
              ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      MarketCard(productName: "Mango", productPrice: "200", imageUrl: "lib/assets/blueberry.jpg",),
                      const SizedBox(
                        width: 20.0,
                      ),
                      MarketCard(productName: "Cherry", productPrice: "602", imageUrl: "lib/assets/banana.jpg",),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      MarketCard(productName: "Apple", productPrice: "230", imageUrl: "lib/assets/vegetable.jpg",),
                      const SizedBox(
                        width: 20.0,
                      ),
                      MarketCard(productName: "Rice", productPrice: "123", imageUrl: "lib/assets/strawberry.jpg",),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Local Demand",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  DemandCard(
                    productName: "Tomatoes",
                    productDate: "Jan,03 2024",
                    productPriority: 2,
                    imageUrl: "lib/assets/strawberry.jpg",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DemandCard(
                    productName: "Mango",
                    productDate: "Jan,09 2024",
                    productPriority: 1,
                    imageUrl: "lib/assets/blueberry.jpg",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DemandCard(
                    productName: "Strawberry",
                    productDate: "Jan,01 2024",
                    productPriority: 0,
                    imageUrl: "lib/assets/banana.jpg",
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class DemandCard extends StatelessWidget {
  DemandCard({
    super.key,
    required this.productDate,
    required this.productName,
    required this.productPriority,
    required this.imageUrl,
  });

  String productName;
  String productDate;
  String imageUrl;
  int productPriority;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 76,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 249, 249, 249),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AspectRatio(
                aspectRatio: 1.1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 16,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    productDate,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (productPriority == 2)
            Container(
              width: 90,
              height: 30,
              // padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1.0,
                  color: const Color.fromARGB(255, 28, 219, 34),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 28, 219, 34),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  const Text(
                    "Priority",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 28, 219, 34),
                    ),
                  ),
                ],
              ),
            ),
          if (productPriority == 0)
            Container(
              width: 90,
              height: 30,
              // padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  const Text(
                    "Low",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            if (productPriority == 1)
            Container(
              width: 90,
              height: 30,
              // padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1.0,
                  color: const Color.fromARGB(255, 253, 17, 0),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 253, 17, 0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  const Text(
                    "Medium",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 253, 17, 0),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class MarketCard extends StatelessWidget {
  MarketCard({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.imageUrl,
  });

  String productPrice;
  String productName;
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.5 - 30,
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
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.currency_exchange,
                      size: 18,
                      color: Color.fromARGB(255, 255, 68, 99),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "$productPrice/kg",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
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
    this.onTap
  });

  final String productName;
  final String productPrice;
  final String productDescription;
  final double productRating;
  final String imageUrl;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.5 - 20,
        // height: size.height * 0.22,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          // color: Color.fromARGB(255, 242, 242, 242),
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
                        image: AssetImage(imageUrl),
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
                  "\$$productPrice/Kg",
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