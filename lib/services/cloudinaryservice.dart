import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class CloudinaryService {
  static const String cloudName = 'dwwlg2zaj';
  static const String uploadPreset = 'kaseApp_images';

   static Future<String?> uploadImageToCloudinary({
    required File imageFile,
    required String type,
  }) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    //  assign folder based on type
    String folderPath = _getFolderPath(type);

    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final mimeSplit = mimeType.split('/');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..fields['folder'] = folderPath
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType(mimeSplit[0], mimeSplit[1]),
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      print('Uploaded to Cloudinary: ${jsonData['secure_url']}');
      return jsonData['secure_url'];
    } else {
      print('Failed to upload image: ${response.statusCode}');
      return null;
    }
  }

  /// Define folder structure dynamically
  static String _getFolderPath(String type) {
    switch (type) {
      case 'user':
        return 'images/users/profile_pictures';
      case 'vendor':
        return 'images/vendors/logos';
      case 'farm':
        return 'images/farms/banners';
      case 'product':
        return 'images/products/photos';  
      default:
        return 'images/others';
    }
  }
}
