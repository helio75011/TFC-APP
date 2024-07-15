import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchPlayerDetails(
    int leagueId, int season) async {
  final String apiUrl =
      'https://v3.football.api-sports.io/players?league=$leagueId&season=$season';
  final String apiKey = '6473ccfb5e7338ec79d8cb6e6fd4a360';

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'x-rapidapi-key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    return jsonData;
  } else {
    throw Exception('Erreur: ${response.statusCode}');
  }
}
