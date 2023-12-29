import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  String idKey = "userId";
  String photoKey = "photo";
  String nameKey = "name";
  SharedPreferences prefs;
  int? userId;

  UserPreference(this.prefs);

  int? getUserId() {
    return prefs.getInt(idKey);
  }

  String? getUserName() {
    return prefs.getString(nameKey);
  }

  String? getUserPhoto() {
    return prefs.getString(photoKey);
  }

  storeUserId(int userId) async {
    await prefs.setInt(idKey, userId);
  }

  storeUserName(String username) async {
    await prefs.setString(nameKey, username);
  }

  storeUserPhoto(String photoUrl) async {
    await prefs.setString(photoKey, photoUrl);
  }

  removeUser() async {
    await prefs.remove(idKey);
  }
}