class Constants {
  // base url 
  // android emulator
  //static const String baseUrl = "http://10.0.2.2:8000/api";  

  // real device ip
  static const String baseUrl = "http://192.168.20.221:8000/api";

  // main url
  static const String mainUrl = "http://192.168.20.221:8000";
  // image url link
  //static const String imgCloud = 'cloudinary://<724248391139355>:<hAYq_8TdSuW1cz50oZn2UW05ceA>@dpx0ydof4';

    // ===== Cloudinary Config =====
  static const String cloudName = "dpx0ydof4";  
  static const String uploadPreset = "kaseApp_images";  
  static const String uploadFolder = "images";  

  // API endpoints 
  static const String preOrders = "$baseUrl/pre-orders";
  static const String products = "$baseUrl/get-products";
  static const String ordersEndpoint = "$baseUrl/orders";
} 