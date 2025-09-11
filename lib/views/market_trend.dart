// import 'package:flutter/material.dart';
// import 'package:kaseapp_ui/models/market_supplies.dart';
// import 'package:kaseapp_ui/models/trendingproduct.dart';
// import 'package:kaseapp_ui/services/market_trend_service.dart';

// class MarketTrendScreen extends StatefulWidget {
//   const MarketTrendScreen({Key? key}) : super(key: key);

//   @override
//   State<MarketTrendScreen> createState() => _MarketTrendScreenState();
// }

// class _MarketTrendScreenState extends State<MarketTrendScreen> {
//   final MarketTrendService _marketTrendService = MarketTrendService();
//   List<TrendingProduct> trendingProducts = [];
//   List<MarketSupplies> marketDemandData = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     setState(() => isLoading = true);
//     try {
//       // Load trending products and market demand data
//       final trending = await _marketTrendService.getTrendingProducts();
//       final marketDemand = await _marketTrendService.getMarketDemand();
      
//       setState(() {
//         trendingProducts = trending;
//         marketDemandData = marketDemand;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       // Handle error
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Market Trend',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
//             onPressed: () {
//               // Show filter dialog
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Top Vegetables Banner
//                   Container(
//                     margin: const EdgeInsets.all(16),
//                     height: 120,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       image: const DecorationImage(
//                         image: NetworkImage('https://snaped.fns.usda.gov/sites/default/files/seasonal-produce/2018-05/watermelon.jpg'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.black.withOpacity(0.3),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                       padding: const EdgeInsets.all(16),
//                       child: const Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           'Top Vegetables this month',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Trending Section
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Trending',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             // Navigate to full trending list
//                           },
//                           child: const Text(
//                             'View all',
//                             style: TextStyle(color: Colors.green),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Trending Products Row
//                   SizedBox(
//                     height: 120,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: 2, // Mock data - replace with trendingProducts.length
//                       itemBuilder: (context, index) {
//                         return Container(
//                           width: 100,
//                           margin: const EdgeInsets.only(right: 16),
//                           child: Column(
//                             children: [
//                               Container(
//                                 width: 60,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   image: DecorationImage(
//                                     image: NetworkImage(
//                                       index == 0 
//                                         ? 'https://snaped.fns.usda.gov/sites/default/files/seasonal-produce/2018-05/watermelon.jpg'
//                                         : 'https://snaped.fns.usda.gov/sites/default/files/seasonal-produce/2018-05/watermelon.jpg',
//                                     ),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 index == 0 ? 'Apple' : 'Tomatoes',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 14,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               Text(
//                                 index == 0 
//                                   ? 'Demand: 500kg\nSupply: 300kg'
//                                   : 'Demand: 200kg\nSupply: 190kg',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey[600],
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Market Demand Section
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Market Demand',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.search, size: 20),
//                               onPressed: () {
//                                 // Show search
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.filter_list, size: 20),
//                               onPressed: () {
//                                 // Show filter
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Market Demand List
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: 4, // Mock data - replace with marketDemandData.length
//                     itemBuilder: (context, index) {
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12),
//                           child: Row(
//                             children: [
//                               // Product Image
//                               Container(
//                                 width: 60,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   image: const DecorationImage(
//                                     image: NetworkImage('https://snaped.fns.usda.gov/sites/default/files/seasonal-produce/2018-05/watermelon.jpg'),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
                              
//                               // Product Details
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Fresh Watermelon',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     const Text(
//                                       'Quality: High',
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       'Expected harvest: 30 August 2024',
//                                       style: TextStyle(
//                                         color: Colors.grey[600],
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'From: Kampong Cham - 60km Away',
//                                       style: TextStyle(
//                                         color: Colors.grey[600],
//                                         fontSize: 11,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
                              
//                               // Action Button
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 16,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: const Text(
//                                   'Order Now',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
                  
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//     );
//   }
// }