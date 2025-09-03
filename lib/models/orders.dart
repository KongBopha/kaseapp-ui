import 'package:kaseapp_ui/utils/order_details_enum.dart';

class Orders{
  int id;
  int vendor_id;
  int farmer_id;
  int product_id;
  int quantity;
  double total_price;
  DateTime schedule;
  DateTime delivery_date;
  OrderDetailsEnum status;

  Orders({
    required this.id,
    required this.vendor_id,
    required this.farmer_id,
    required this.product_id,
    required this.quantity,
    required this.total_price,
    required this.schedule,
    required this.delivery_date,
    required this.status,
  });
}