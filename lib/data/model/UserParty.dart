// To parse this JSON data, do
//
//     final userParty = userPartyFromJson(jsonString);

import 'dart:convert';

UserParty userPartyFromJson(String str) => UserParty.fromJson(json.decode(str));

String userPartyToJson(UserParty data) => json.encode(data.toJson());

class UserParty {
  int? id;
  String? name;

  UserParty({
    this.id,
    this.name,
  });

  factory UserParty.fromJson(Map<String, dynamic> json) => UserParty(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
