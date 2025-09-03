class FarmModel {
  final int id;
  final int owner_id; // link to user table
  final String name;
  final String? address;
  final String? about;
  final bool status;
  final String? cover;
  final String? logo;

 
  FarmModel({
    required this.id,
    required this.owner_id,
    required this.name,
    this.address,
    this.about,
    this.status = false,
    this.cover,
    required this.logo,
  });

  factory FarmModel.fromJson(Map<String,dynamic> json) => FarmModel(
    id: json['id'],
    owner_id: json['owner_id'],
    name: json['name'],
    address: json['address']??'',
    about: json['about']??'',
    status: json['status']??false,
    cover: json['cover']??'',
    logo: json['logo']??'',
  );
  Map<String,dynamic> toJson() => {
    'id': id,
    'owner_id': owner_id,
    'name': name,
    'address': address,
    'about': about,
    'status': status,
    'cover': cover,
    'logo': logo,
  };
}
