class RegisterModel {
  final String firstName;
  final String lastName;
  final String? sex;
  final String? email;
  final String? phone;
  final String password;
  final String confirmPassword;
  final String? profileUrl;
  final String? address;

  RegisterModel({
    required this.firstName,
    required this.lastName,
    this.sex,
    required this.password,
    required this.confirmPassword,
    this.email,
    this.phone,
    this.profileUrl,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'sex': sex,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': confirmPassword,
      'profile_url': profileUrl,
      'address': address,
    };
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      sex: json['sex'] ?? '',
      email: json['email'],
      phone: json['phone'],
      password: json['password'] ?? '',
      confirmPassword: json['password_confirmation'] ?? '',
      profileUrl: json['profile_url'],
      address: json['address'],
    );
  }

  RegisterModel copyWith({
    String? firstName,
    String? lastName,
    String? sex,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    String? profileUrl,
    String? address,
  }) {
    return RegisterModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      sex: sex ?? this.sex,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      profileUrl: profileUrl ?? this.profileUrl,
      address: address ?? this.address,
    );
  }
}
