/// id : 2
/// name : "Andre"
/// email : "andre@admin.com"
/// email_verified_at : null
/// photoUrl : null
/// created_at : "2023-12-28T13:57:55.000000Z"
/// updated_at : "2023-12-28T13:57:55.000000Z"

class User {
  User({
      num? id, 
      String? name, 
      String? email, 
      dynamic emailVerifiedAt, 
      dynamic photoUrl, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _email = email;
    _emailVerifiedAt = emailVerifiedAt;
    _photoUrl = photoUrl;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _emailVerifiedAt = json['email_verified_at'];
    _photoUrl = json['photoUrl'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _name;
  String? _email;
  dynamic _emailVerifiedAt;
  dynamic _photoUrl;
  String? _createdAt;
  String? _updatedAt;
User copyWith({  num? id,
  String? name,
  String? email,
  dynamic emailVerifiedAt,
  dynamic photoUrl,
  String? createdAt,
  String? updatedAt,
}) => User(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  emailVerifiedAt: emailVerifiedAt ?? _emailVerifiedAt,
  photoUrl: photoUrl ?? _photoUrl,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get name => _name;
  String? get email => _email;
  dynamic get emailVerifiedAt => _emailVerifiedAt;
  dynamic get photoUrl => _photoUrl;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['email_verified_at'] = _emailVerifiedAt;
    map['photoUrl'] = _photoUrl;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}