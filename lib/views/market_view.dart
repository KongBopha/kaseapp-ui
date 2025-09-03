// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// //import 'package:kaseapp/controllers/farmer_market_supply_controller.dart';

// class MarketView extends StatelessWidget {
//   MarketView({super.key});

//   // final FarmerMarketSupplyController controller =
//   //     Get.put(FarmerMarketSupplyController());

//   @override
//   Widget build(BuildContext context) {
//     // fetch once when screen opens
//     controller.fetchMarketSupply();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Market Supply List")),
//       body: Obx(() {
//         if (controller.loading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.supplyList.isEmpty) {
//           return const Center(child: Text("No supplies available"));
//         }

//         return ListView.builder(
//           itemCount: controller.supplyList.length,
//           itemBuilder: (context, index) {
//             final supply = controller.supplyList[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               child: ListTile(
//                 leading: supply.image.isNotEmpty
//                     ? Image.network(supply.image, width: 50, height: 50, fit: BoxFit.cover)
//                     : const Icon(Icons.image_not_supported),
//                 title: Text("Product: ${supply.productName}"),
//                 subtitle: Text(
//                   "Quantity: ${supply.qty} ${supply.unit}\n"
//                   "Available: ${supply.availability.toLocal().toString().split(' ')[0]}",
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
