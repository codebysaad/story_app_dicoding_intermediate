import 'dart:convert';

LoginResponse welcomeFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String welcomeToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  final bool error;
  final String message;
  LoginData loginData;

  LoginResponse({
    required this.error,
    required this.message,
    required this.loginData,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    error: json["error"],
    message: json["message"],
    loginData: LoginData.fromJson(json["loginResult"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "loginResult": loginData.toJson(),
  };
}

class LoginData {
  final String userId;
  final String name;
  final String token;

  LoginData({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    userId: json["userId"],
    name: json["name"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "token": token,
  };
}
