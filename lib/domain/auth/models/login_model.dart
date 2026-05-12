import 'package:home_test_prudential/domain/auth/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.image,
    required super.accessToken,
    required super.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json["id"] ?? 0,
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      gender: json["gender"] ?? "",
      image: json["image"] ?? "",
      accessToken: json["accessToken"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "gender": gender,
    "image": image,
    "accessToken": accessToken,
    "refreshToken": refreshToken,
  };
}
