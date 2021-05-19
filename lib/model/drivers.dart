import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
  String id;
  String username;
  String telefono;
  String email;
  String password;
  String plate;
  String token;
  String image;

  Driver({
    this.id,
    this.username,
    this.telefono,
    this.email,
    this.password,
    this.plate,
    this.token,
    this.image,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        username: json["username"],
        telefono: json["telefono"],
        email: json["email"],
        password: json["password"],
        plate: json["plate"],
        token: json["token"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "telefono": telefono,
        "email": email,
        "plate": plate,
        "token": token,
        "image": image,
      };
}
