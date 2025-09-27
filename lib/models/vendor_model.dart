class VendorModel {
  VendorModel({
    this.id,
    this.companyName,
    this.vendorType,
    this.address,
    this.about,
    this.logo,
  });

  final int? id;
  final String? companyName;
  final String? vendorType;
  final String? address;
  final String? about;
  final String? logo;

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        companyName: json['name'] ?? '',
        vendorType: json['vendor_type'] ?? '',
        address: json['address'] ?? '',
        about: json['about'] ?? '',
        logo: json['logo'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': companyName,
        'vendor_type': vendorType,
        'address': address,
        'about': about,
        'logo': logo,
      };
}
