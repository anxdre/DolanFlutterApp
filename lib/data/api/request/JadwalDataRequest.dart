import 'dart:convert';

import 'package:http/http.dart' as http;

import '../ApiSettings.dart';

class JadwalDataRequest {
  Future<http.Response> getAllJadwal() {
    return http.get(Uri.parse("${ApiSettings.baseUrl}api/jadwal"),
        headers: ApiSettings.headers);
  }
}
