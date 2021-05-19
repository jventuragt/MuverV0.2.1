import 'dart:convert';


Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  String id;
  String username;
  String telefono;
  String email;
  String password;
  String token;
  String image;
  String calificationClient;

  Users({
    this.id,
    this.username,
    this.telefono,
    this.email,
    this.password,
    this.token,
    this.image,
    this.calificationClient,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        username: json["username"],
        telefono: json["telefono"],
        email: json["email"],
        password: json["password"],
        token: json["token"],
        image: json["image"],
        calificationClient: json["calificationClient"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "telefono": telefono,
        "email": email,
        "token": token,
        "image": image,
        "calificationClient": calificationClient,
      };
}
