import 'dart:convert';

class UserModel {
    String name;
    String email;
    String gender;
    String status;

    UserModel({
        required this.name,
        required this.email,
        required this.gender,
        required this.status,
    });

    factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        email: json["email"],
        gender: json["gender"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "gender": gender,
        "status": status,
    };
}
