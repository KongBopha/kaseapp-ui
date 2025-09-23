class Constants {
  // base url 
  // android emulator
  //static const String baseUrl = "http://10.0.2.2:8000/api";  

  // real device ip
  static const String baseUrl = "http://172.20.10.3:8000/api";

  // main url
  //static const String mainUrl = "http://10.0.2.2:8000";  
  // real device ip
  static const String mainUrl = "http://172.20.10.3:8000";

  // API endpoints 
  static const String preOrders = "$baseUrl/pre-orders";
  static const String products = "$baseUrl/get-products";
  static const String ordersEndpoint = "$baseUrl/orders";
} 