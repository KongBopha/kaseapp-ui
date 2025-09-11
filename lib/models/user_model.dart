import 'package:kaseapp_ui/models/farm_model.dart';
import 'package:kaseapp_ui/models/vendor_model.dart';

class UserModel {
  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.profileUrl,
    this.role = "consumer",
    this.farm,
    this.vendor,
    this.email,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? profileUrl;
  final String? email;
  final String? phone;
  String role;
  FarmModel? farm;
  VendorModel? vendor;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profileUrl: json["profile_url"],
        role: json['role'] ?? 'consumer',
        farm: json['farm'] != null ? FarmModel.fromJson(json['farm']) : null,
        vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor']) : null,
        email: json["email"],
        phone: json["phone"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "role": role,
        "farm": farm?.toJson(),
        "vendor": vendor?.toJson(),
        "profile_url": profileUrl,
        "email": email,
        "phone": phone,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
  factory UserModel.empty() => UserModel(role: 'consumer');
}
