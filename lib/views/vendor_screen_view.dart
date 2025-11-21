import 'package:flutter/material.dart';
import 'package:kaseapp_ui/controllers/vendor_offer_controller.dart';
import 'package:get/get.dart';

class VendorOfferScreen extends StatelessWidget {
  final int preOrderId;

  VendorOfferScreen({required this.preOrderId});

  final VendorOfferController controller =
      Get.put(VendorOfferController(Get.find()));

  @override
  Widget build(BuildContext context) {
    controller.loadVendorOffers(preOrderId);

    return Scaffold(
      appBar: AppBar(title: Text("Pre-order Offers")),
      body: controller.obx(
        (state) => Column(
          children: [
            // TOP INFO
            Container(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final order = controller.preOrder.value;
                if (order == null) return SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product: ${order.productName}",
                        style: const TextStyle(fontSize: 18)),
                    Text("Requested Qty: ${order.requestedQty} kg"),
                  ],
                );
              }),
            ),

            // OFFER LIST
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.offers.length,
                  itemBuilder: (context, index) {
                    final item = controller.offers[index];

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text("${item.farmName}"),
                        subtitle: Text(
                            "Farmer: ${item.farmerName}\nQty: ${item.fulfilledQty} kg"),
                        trailing: Text(
                          item.status,
                          style: TextStyle(
                            color: item.status == "confirmed"
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),

        // LOADING
        onLoading: Center(child: CircularProgressIndicator()),

        // ERROR
        onError: (err) => Center(child: Text(err ?? "Error")),
      ),
    );
  }
}
