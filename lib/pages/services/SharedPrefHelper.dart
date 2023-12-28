import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  SharedPreferences prefs;
  int? userId;

  UserPreference(this.prefs);
}