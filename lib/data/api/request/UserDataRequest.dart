import 'dart:convert';


import 'package:dolan/data/api/ApiSettings.dart';
import 'package:http/http.dart' as http;

import '../../model/User.dart';

class UserDataRequest{
  Future<http.Response> loginUser(String email,String password) {
    return http.post(Uri.parse("${ApiSettings.baseUrl}api/auth/login"),
    headers: ApiSettings.headers,
    body: jsonEncode({
      'email': email,
      'password' : password
    }));
  }

  Future<http.Response> registerUser(String email,String name, String password) {
    return http.post(Uri.parse("${ApiSettings.baseUrl}api/auth/register"),
    headers: ApiSettings.headers,
    body: jsonEncode({
      'email':email,
      'password':password,
      'name':name
    }));
  }

  Future<http.Response> updateUser(User user,String password) {
    return http.post(Uri.parse("${ApiSettings.baseUrl}api/auth/update"),
    headers: ApiSettings.headers,
    body: jsonEncode({
      'id' :user.id,
      'email':user.email,
      'name':user.name,
      'password': password,
      'photoUrl': user.photoUrl
    }));
  }
}