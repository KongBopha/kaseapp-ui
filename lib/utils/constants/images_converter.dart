import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/base_api.dart';

class ImagesConverter {
  
  String getProductImageUrl(String? productImageUrl) {
    if (productImageUrl == null || productImageUrl.isEmpty) return AppImage.orderIcon;

    if (productImageUrl.startsWith("http")) return productImageUrl;
    final cleanPath = productImageUrl.replaceAll(RegExp(r'^/storage/product_images/'), '');
    return '${Constants.mainUrl}/storage/product_images/$cleanPath';
  }
  // String getVendorImageUrl(String? vendorImageUrl){

  // }
  // String getFarmImageUrl(String? farmImageUrl){

  // }
}