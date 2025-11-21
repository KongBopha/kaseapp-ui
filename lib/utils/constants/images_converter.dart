import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/base_api.dart';

class ImagesConverter {
  
  String getProductImageUrl(String? productImageUrl) {
    if (productImageUrl == null || productImageUrl.isEmpty) return AppImage.orderIcon;

    if (productImageUrl.startsWith("http")) return productImageUrl;
    final cleanPath = productImageUrl.replaceAll(RegExp(r'^/storage/product_images/'), '');
    return '${Constants.mainUrl}/storage/product_images/$cleanPath';
  }
    // Profile images
  String getProfileImageUrl(String? profileImageUrl) {
    if (profileImageUrl == null || profileImageUrl.isEmpty) return AppImage.userProfile;
    if (profileImageUrl.startsWith("http")) return profileImageUrl;

    final cleanPath = profileImageUrl.replaceAll(RegExp(r'^/storage/profile_photos/'), '');
    return '${Constants.mainUrl}/storage/profile_photos/$cleanPath';
  }
    String getVendorImageUrl(String? vendorImageUrl) {
    if (vendorImageUrl == null || vendorImageUrl.isEmpty) return AppImage.userProfile;
    if (vendorImageUrl.startsWith("http")) return vendorImageUrl;

    final cleanPath = vendorImageUrl.replaceAll(RegExp(r'^/storage/vendor_logos/'), '');
    return '${Constants.mainUrl}/storage/vendor_photos/$cleanPath';
  }
    String getFarmImageUrl(String? farmImageUrl) {
    if (farmImageUrl == null || farmImageUrl.isEmpty) return AppImage.userProfile;
    if (farmImageUrl.startsWith("http")) return farmImageUrl;

    final cleanPath = farmImageUrl.replaceAll(RegExp(r'^/storage/farm_photos/'), '');
    return '${Constants.mainUrl}/storage/farm_photos/$cleanPath';
  }

}