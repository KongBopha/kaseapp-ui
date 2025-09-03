class Product {
  final int id;
  final int userId;
  final String name;
  final String? image;
  final String unit;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.userId,
    required this.name,
    required this.unit,
    this.image,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] != null ? (json['id'] as num).toInt() : 0,
    userId: json['owner_id'] != null ? (json['owner_id'] as num).toInt() : 0,
    name: json['name'] ?? "Unknown",
    unit: json['unit'] ?? "unit",
    image: json['image'],
    description: json['description'],
    createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
  );
}


  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'unit': unit,
        'image': image,
        'description': description,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
