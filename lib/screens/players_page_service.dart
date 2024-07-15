import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/player_model.dart';

class PlayersPageService {
  Future<List<Player>> fetchPlayers({
    int? id,
    int? team,
    int? league,
    String? season,
    String? search,
    int page = 1,
  }) async {
    final String apiUrl = 'https://v3.football.api-sports.io/players/squads';

    Map<String, dynamic> queryParameters = {
      'page': page.toString(),
    };

    if (id != null) {
      queryParameters['id'] = id.toString();
    }
    if (team != null) {
      queryParameters['team'] = team.toString();
    }
    if (league != null) {
      queryParameters['league'] = league.toString();
    }
    if (season != null) {
      queryParameters['season'] = season;
    }
    if (search != null) {
      queryParameters['search'] = search;
    }

    final String apiKey = '6473ccfb5e7338ec79d8cb6e6fd4a360';

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'x-rapidapi-host': 'v3.football.api-sports.io',
        'x-rapidapi-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData != null &&
          jsonData['response'] != null &&
          jsonData['response'].isNotEmpty) {
        List<Player> players = [];

        var teamData = jsonData['response'][0]['players'];
        for (var item in teamData) {
          Player player = Player.fromJson(item);
          players.add(player);
        }

        return players;
      } else {
        throw Exception('Reponse invalide');
      }
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }
}
