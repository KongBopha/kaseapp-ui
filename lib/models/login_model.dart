class LoginModel {
  String  password;
  String  login;

  LoginModel({
    required this.password,
    required this.login,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'login': login,
    };
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      password: json['password'],
      login: json['login'],
    );
  }
  
}