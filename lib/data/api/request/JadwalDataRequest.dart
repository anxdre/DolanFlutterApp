import 'dart:convert';

import 'package:http/http.dart' as http;

import '../ApiSettings.dart';

class JadwalDataRequest {
  static String baseUrlNoHttps = "dolanan.anxdre.my.id";

  Future<http.Response> getAllJadwal(int userId) {
    return http.get(
        Uri.parse(
            "${ApiSettings.baseUrl}api/jadwal/myjadwal?users_id=${userId}"),
        headers: ApiSettings.headers);
  }

  Future<http.Response> searchJadwal(String query) {
    final uri = Uri.https(baseUrlNoHttps, 'api/jadwal', {'query': query});
    return http.get(uri, headers: ApiSettings.headers);
  }

  Future<http.Response> joinParty(int jadwalId, int userId) {
    return http.post(Uri.parse("${ApiSettings.baseUrl}api/party/user-party"),
        headers: ApiSettings.headers,
        body: jsonEncode({'users_id': userId, 'jadwal_id': jadwalId}));
  }

  Future<http.Response> getUserParty(int jadwalId) {
    final uri = Uri.https(baseUrlNoHttps, 'api/party/user-party', {'jadwal_id': jadwalId.toString()});
    return http.get(uri, headers: ApiSettings.headers);
  }

}
