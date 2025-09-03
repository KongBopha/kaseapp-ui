import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';

class TrackView extends StatelessWidget {
  const TrackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 248, 253),
      appBar: MyAppBar(
        title: "Track".tr,
        backgroundColor: const Color.fromARGB(255, 244, 248, 253),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (value) => {
                    // Get.toNamed('/my${AppRoutes.trackDetailView}'),
                  },
                  decoration: InputDecoration(
                    hintText: "${'Input tracking number'.tr}...",
                    hintStyle: const TextStyle(color: Colors.black45),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const ScanQRView()));
                },
                child: Row(
                  children: [
                    Icon(Icons.qr_code),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text("QR Scan".tr),
                    SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
