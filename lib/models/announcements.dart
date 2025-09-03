class Announcement {
  final int id;
  final int userId;
  final int productId;
  final String type; // 'supply' or 'demand'
  final String title;
  final String content;
  final double quantity;
  final double price;
  final String location;
  final String? note;  
  final DateTime? expectedHarvestDate; 
  final DateTime? deliveryDate; 
  final String? recurringSchedule; 
  final String status; 
  final DateTime createdAt;
  final DateTime updatedAt;

  Announcement({
    required this.id,
    required this.userId,
    required this.productId,
    required this.type,
    required this.title,
    required this.content,
    required this.quantity,
    required this.price,
    required this.location,
    this.note,
    this.expectedHarvestDate,
    this.deliveryDate,
    this.recurringSchedule,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an Announcement from JSON
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      productId: json['product_id'] as int,
      type: json['type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      note: json['note'] as String?,
      expectedHarvestDate: json['expected_harvest_date'] != null
          ? DateTime.parse(json['expected_harvest_date'])
          : null,
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'])
          : null,
      recurringSchedule: json['recurring_schedule'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert an Announcement to JSON (for sending to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'type': type,
      'title': title,
      'content': content,
      'quantity': quantity,
      'price': price,
      'location': location,
      'note': note,
      'expected_harvest_date': expectedHarvestDate?.toIso8601String(),
      'delivery_date': deliveryDate?.toIso8601String(),
      'recurring_schedule': recurringSchedule,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}