class VendorModel {
  final int id;
  final int owner_id;
  final String companyName;
  final String? address;
  final String? description;
  final String vendor_type;
  final String? logo;


  VendorModel({required this.id, required this.companyName,   this.address, this.description, required this.owner_id, required this.vendor_type,   this.logo});

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        id: json['id'],
        companyName: json['company_name'] ?? json['name'] ?? '',
        address: json['address'] ?? '',
        description: json['description'] ?? '',
        owner_id: json['owner_id'],
        vendor_type: json['vendor_type'] ?? 'retail',
        logo: json['logo'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'owner_id': owner_id,
        'company_name': companyName,
        'address': address,
        'description': description,
        'vendor_type': vendor_type,
        'logo': logo,
      };
}