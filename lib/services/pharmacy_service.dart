import 'dart:convert';
import 'package:http/http.dart' as http;

class PharmacyService {
  final String apiKey;

  PharmacyService(this.apiKey);

  Future<List<dynamic>> fetchNearbyPharmacies(double latitude, double longitude, int distance, {bool onDuty = false}) async {
    final headers = {
      'Authorization': 'Bearer $apiKey',
    };

    final endpoint = onDuty
        ? 'https://www.nosyapi.com/apiv2/service/pharmacies-on-duty/locations'
        : 'https://www.nosyapi.com/apiv2/service/pharmaciesv2/locations';

    final url = Uri.parse('$endpoint?latitude=$latitude&longitude=$longitude&distance=$distance');

    final res = await http.get(url, headers: headers);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.get error: statusCode= $status');

    final data = json.decode(res.body);
    return data['data']; // Eczane verilerini döndür
  }
}
