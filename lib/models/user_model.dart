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
  late final String? firstName;
  late final String? lastName;
  late final String? profileUrl;
  late final String? email;
  late final String? phone;
  late String role;
  FarmModel? farm;
  VendorModel? vendor;
  final DateTime? createdAt;
  final DateTime? updatedAt;


factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: (json["id"] as num?)?.toInt() ?? 0,
      firstName: json["first_name"] ?? '',
      lastName: json["last_name"] ?? '',
      profileUrl: json["profile_url"] ?? '',
      role: json['role'] ?? 'consumer',
      farm: json['farm'] != null ? FarmModel.fromJson(json['farm']) : null,
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor']) : null,
      email: json["email"] ?? '',
      phone: json["phone"] ?? '',
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"]) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"]) ?? DateTime.now()
          : DateTime.now(),
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
   UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? profileUrl,
    String? email,
    String? phone,
    String? role,
    FarmModel? farm,
    VendorModel? vendor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileUrl: profileUrl ?? this.profileUrl,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      farm: farm ?? this.farm,
      vendor: vendor ?? this.vendor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
