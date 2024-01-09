import 'dart:convert';

import 'package:dolan/data/api/ApiSettings.dart';
import 'package:http/http.dart' as http;

class ChatRequest {
  String baseUrlNoHttps = "dolanan.anxdre.my.id";
  Future<http.Response> getPartyChat(int jadwalId) {
    print("jadwalId: ${jadwalId}");
    final uri = Uri.https(baseUrlNoHttps, 'api/party/message-party',
        {'jadwal_id': jadwalId.toString()});
    return http.get(uri, headers: ApiSettings.headers);
  }

  Future<http.Response> addPartyChat(int jadwalId, String name, String message) {
    return http.post(Uri.parse("${ApiSettings.baseUrl}api/party/message-party"),
        headers: ApiSettings.headers,
        body: jsonEncode({
          'jadwal_id': jadwalId,
          'name': name,
          'message': message,
        }));
  }
}
