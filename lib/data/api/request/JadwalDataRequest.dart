import 'package:http/http.dart' as http;

import '../ApiSettings.dart';

class JadwalDataRequest {
  Future<http.Response> getAllJadwal(int userId) {
    return http.get(Uri.parse("${ApiSettings.baseUrl}api/jadwal/myjadwal?users_id=${userId}"),
        headers: ApiSettings.headers);
  }

  Future<http.Response> searchJadwal(String query) {
    final uri = Uri.https(ApiSettings.baseUrl, 'api/jadwal', {'query': query});
    return http.get(uri, headers: ApiSettings.headers);
  }
}
