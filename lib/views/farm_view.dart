// import 'package:flutter/material.dart';
// import 'package:kaseapp_ui/configs/routes/routes.dart';
// import 'package:kaseapp_ui/utils/constants/base_api.dart';
// //import 'package:kaseapp_ui/controllers/custom_map_controller.dart';
// //import 'package:kaseapp_ui/controllers/farm_controller.dart';
// import 'package:kaseapp_ui/controllers/user_controller.dart';
// import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';
// import 'package:get/get.dart';

// class FarmView extends StatefulWidget {
//   const FarmView({super.key});

//   @override
//   State<FarmView> createState() => _FarmViewState();
// }

// class _FarmViewState extends State<FarmView> {
//  // final FarmController _farmController = Get.put(FarmController());
// //  final CustomMapController _customMapController = Get.find();
//   final UserController _userController = Get.find();

//   @override
//   void initState() {
//     super.initState();
//     //_farmController.getListFarm();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: MyAppBar(
//         title: "My Farm".tr,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Get.toNamed(
//             '/my${AppRoutes.createFarm}',
//             arguments: _customMapController.address.value,
//           );
//         },
//         backgroundColor: const Color.fromARGB(255, 44, 42, 66),
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
//           child: Column(
//             children: [
//               Obx(
//                 () {
//                   if (!_farmController.isloading) {
//                     if (_farmController.myFarms.isEmpty) {
//                       return SizedBox(
//                         height: size.height / 1.5,
//                         child: Center(
//                           child: Text(
//                             "Please Open New Farm".tr,
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.grey.shade400,
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                     return GridView.builder(
//                       itemCount: _farmController.myFarms.length,
//                       padding: EdgeInsets.zero,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         // mainAxisSpacing: 20,
//                         crossAxisSpacing: 16,
//                         mainAxisSpacing: 16,
//                         childAspectRatio: 1 / 0.73,
//                       ),
//                       shrinkWrap: true,
//                       itemBuilder: (BuildContext context, int index) {
//                         final farm = _farmController.myFarms[index];
//                         return FarmCard(
//                           farmName: farm.name!,
//                           farmDescription: farm.about!,
//                           onTap: () {
//                             Get.toNamed(
//                               '/my${AppRoutes.farmDetail}',
//                               arguments: {
//                                 'farm_id': farm.id,
//                                 'owner_id': farm.owner_id,
//                                 'isFarmOwner':
//                                     _userController.user.id == farm.owner_id,
//                               },
//                             );
//                           },
//                           imageUrl: farm.cover,
//                         );
//                       },
//                     );
//                   }
//                   return SizedBox(
//                     height: size.height / 1.5,
//                     child: Center(
//                       child: Text(
//                         "Fetching".tr,
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.grey.shade400,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class FarmCard extends StatelessWidget {
//   const FarmCard({
//     super.key,
//     required this.farmName,
//     required this.farmDescription,
//     required this.onTap,
//     required this.imageUrl,
//   });

//   final Function() onTap;
//   final String farmName;
//   final String farmDescription;
//   final String? imageUrl;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: onTap,
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 123, 129, 134),
//               borderRadius: BorderRadius.circular(12),
//               image: DecorationImage(
//                 image: imageUrl == null
//                     ? const AssetImage("lib/assets/farm.jpg")
//                     : NetworkImage(
//                             '${BaseAPI.mainUrl}/storage/images/${imageUrl!}')
//                         as ImageProvider,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             width: size.width * 0.5 - 30,
//             height: size.height * 0.15,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     // Icon(
//                     //   Icons.ac_unit_rounded,
//                     //   color: Colors.white,
//                     // ),
//                     Icon(
//                       Icons.more_horiz,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       farmName,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Text(
//                       farmDescription,
//                       style: const TextStyle(
//                         color: Color.fromARGB(255, 220, 220, 220),
//                         overflow: TextOverflow.ellipsis,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
