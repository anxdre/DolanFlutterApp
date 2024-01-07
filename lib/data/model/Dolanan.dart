class Dolanan {
  int? id;
  String? name;
  int? userMinimal;
  dynamic createdAt;
  dynamic updatedAt;

  Dolanan({
    this.id,
    this.name,
    this.userMinimal,
    this.createdAt,
    this.updatedAt,
  });


  Dolanan.create(
      this.id, this.name, this.userMinimal, this.createdAt, this.updatedAt);

  factory Dolanan.fromJson(Map<String, dynamic> json) => Dolanan(
        id: json["id"],
        name: json["name"],
        userMinimal: json["user_minimal"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_minimal": userMinimal,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
