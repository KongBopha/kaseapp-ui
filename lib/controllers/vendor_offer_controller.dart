import 'package:kaseapp_ui/models/preorder_response.dart';
import 'package:kaseapp_ui/repositories/pre_order_repository.dart';
import 'package:get/get.dart';

class VendorOfferController extends GetxController with StateMixin<PreOrderOfferResponse> {
  final PreOrderRepository repository;
  
  VendorOfferController(this.repository);

  var preOrder = Rxn<PreOrderItem>();
  var offers = <OfferItem>[].obs;

  Future<void> loadVendorOffers(int preOrderId) async {
    change(null, status: RxStatus.loading());

    final result = await repository.getVendorOffers(preOrderId);

    result.fold(
      (failure) {
        change(null, status: RxStatus.error(failure.message));
      },
      (data) {
        preOrder.value = data.preOrder;
        offers.assignAll(data.offers);

        change(data, status: RxStatus.success());
      },
    );
  }

  @override
  void onClose() {
    preOrder.value = null;
    offers.clear();
    super.onClose();
  }
}
