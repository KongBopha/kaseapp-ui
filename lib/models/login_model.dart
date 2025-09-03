class LoginModel {
  String  password;
  String  phone;

  LoginModel({

    required this.password,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'phone': phone,
    };
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      password: json['password'],
      phone: json['phone'],
    );
  }
  
}