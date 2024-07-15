import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/player_model.dart';
import '../models/player_stats_model.dart';

class PlayerDetailsPage extends StatelessWidget {
  final Player player;

  PlayerDetailsPage({required this.player});

  Future<List<Statistic>> fetchPlayerStatistics(int playerId) async {
    final String apiUrl =
        'https://v3.football.api-sports.io/players?id=$playerId&season=2023';
    final String apiKey = '6473ccfb5e7338ec79d8cb6e6fd4a360';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'x-rapidapi-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['response'] != null && jsonData['response'].isNotEmpty) {
        var statisticsJson = jsonData['response'][0]['statistics'] as List;
        return statisticsJson.map((stat) => Statistic.fromJson(stat)).toList();
      } else {
        throw Exception('Aucunes infos sur ce joueur');
      }
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }

  Widget buildLeagueStatistics(String leagueName, List<Statistic> statistics) {
    var leagueStats = statistics.firstWhere(
      (stat) => stat.leagueName == leagueName,
      orElse: () => Statistic(
        teamName: 'N/A',
        leagueName: leagueName,
        leagueCountry: 'N/A',
        position: 'N/A',
        appearances: 0,
        lineups: 0,
        minutes: 0,
        goals: 0,
        assists: 0,
        yellowCards: 0,
        redCards: 0,
      ),
    );

    Color backgroundColor;
    Color textColor;
    String title;

    if (leagueName == 'Ligue 1') {
      backgroundColor = Color(0xFF8B9512);
      textColor = Colors.white;
      title = 'Statistiques $leagueName';
    } else if (leagueName == 'Coupe de France') {
      backgroundColor = Color(0xFF1F5894);
      textColor = Colors.white;
      title = 'Statistiques $leagueName';
    } else if (leagueName == 'UEFA Europa League') {
      backgroundColor = Colors.orange;
      textColor = Colors.white;
      title = 'Statistiques $leagueName';
    } else {
      backgroundColor = Colors.grey;
      textColor = Colors.white;
      title = 'Statistiques $leagueName';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 36.0),
        Container(
          color: backgroundColor,
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        SizedBox(height: 36.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/temps_jouer.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(height: 8.0),
                Text(
                  '${leagueStats.minutes}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Image.asset(
                  'assets/jaune.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(height: 8.0),
                Text(
                  '${leagueStats.yellowCards}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Image.asset(
                  'assets/rouge.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(height: 8.0),
                Text(
                  '${leagueStats.redCards}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Image.asset(
                  'assets/but.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(height: 8.0),
                Text(
                  '${leagueStats.goals}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Image.asset(
                  'assets/passe.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(height: 8.0),
                Text(
                  '${leagueStats.assists}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques Joueurs'),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.7, 1.0],
            colors: [
              Color(0xFF0E0024),
              Color(0xFF410979),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: FutureBuilder<List<Statistic>>(
          future: fetchPlayerStatistics(player.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Pas d infos'));
            } else {
              var statistics = snapshot.data!;

              return Center(
                child: Container(
                  margin: EdgeInsets.only(top: 100.0),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: Image.network(
                                player.photoUrl,
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 50),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Matches Joués: ${statistics.first.appearances}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Position: ${statistics.first.position}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Nationalité: ${statistics.first.leagueCountry}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        buildLeagueStatistics('Ligue 1', statistics),
                        buildLeagueStatistics('Coupe de France', statistics),
                        buildLeagueStatistics('UEFA Europa League', statistics),
                        SizedBox(height: 16.0),
                        ...statistics
                            .map((stat) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  // child: Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.center,
                                  //   children: [
                                  //     Text('Team: ${stat.teamName}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //     Text('League: ${stat.leagueName}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //     Text('Country: ${stat.leagueCountry}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //     Text('Position: ${stat.position}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //     Text('Appearances: ${stat.appearances}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //     Text('Lineups: ${stat.lineups}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //     Text('Minutes: ${stat.minutes}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //     Text('Goals: ${stat.goals}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //     Text('Assists: ${stat.assists}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //     Text('Yellow Cards: ${stat.yellowCards}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //     Text('Red Cards: ${stat.redCards}',
                                  //         style: TextStyle(
                                  //             fontSize: 18.0,
                                  //             color: Colors.white)),
                                  //   ],
                                  // ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
