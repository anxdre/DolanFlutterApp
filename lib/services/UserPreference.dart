import 'dart:async' show Future;

import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static String idKey = "userId";
  static String photoKey = "photo";
  static String nameKey = "name";
  static String emailKey = "email";
  SharedPreferences prefs = instance;
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

  String? getUserEmail() {
    return prefs.getString(emailKey);
  }

  storeUserId(int userId) async {
    await prefs.setInt(idKey, userId);
  }

  storeUserName(String username) async {
    await prefs.setString(nameKey, username);
  }

  storeEmail(String email) async {
    await prefs.setString(emailKey, email);
  }

  storeUserPhoto(String photoUrl) async {
    await prefs.setString(photoKey, photoUrl);
  }

  removeUser() async {
    await prefs.remove(idKey);
  }
}
