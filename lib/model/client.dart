// To parse this JSON data, do
//
//     final clients = clientsFromJson(jsonString);

import 'dart:convert';

Clients clientsFromJson(String str) => Clients.fromJson(json.decode(str));

String clientsToJson(Clients data) => json.encode(data.toJson());

class Clients {
  Clients({
    this.id,
    this.username,
    this.email,
    this.telefono,
    this.uid,
    this.imagen,
  });

  String id;
  String username;
  String email;
  String telefono;
  String uid;
  String imagen;

  factory Clients.fromJson(Map<String, dynamic> json) => Clients(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        telefono: json["telefono"],
        uid: json["uid"],
        imagen: json["imagen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "telefono": telefono,
        "uid": uid,
        "imagen": imagen,
      };
}
