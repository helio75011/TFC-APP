import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatchDetailsPage extends StatelessWidget {
  final dynamic match;

  MatchDetailsPage({required this.match});

  Future<Map<String, dynamic>> fetchMatchDetails(int matchId) async {
    final String apiUrl =
        'https://v3.football.api-sports.io/fixtures?id=$matchId';
    final String apiKey = '6473ccfb5e7338ec79d8cb6e6fd4a360';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'x-rapidapi-host': 'v3.football.api-sports.io',
        'x-rapidapi-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData['response'][0];
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchHead2Head(int homeTeamId, int awayTeamId) async {
    final String apiUrl =
        'https://v3.football.api-sports.io/fixtures/headtohead?h2h=$homeTeamId-$awayTeamId';
    final String apiKey = '6473ccfb5e7338ec79d8cb6e6fd4a360';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'x-rapidapi-host': 'v3.football.api-sports.io',
        'x-rapidapi-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData['response'];
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var fixture = match['fixture'];
    var homeTeam = match['teams']['home'];
    var awayTeam = match['teams']['away'];
    var date = DateTime.parse(fixture['date']);
    var formattedDate = "${date.day}/${date.month}/${date.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text('Match Details'),
      ),
      body: Stack(
        children: [
          Container(
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
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: fetchMatchDetails(fixture['id']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('Pas de details'));
              } else {
                var matchDetails = snapshot.data!;
                var venue = matchDetails['fixture']['venue'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        color: Colors.white,
                        child: Text(
                          'Match',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Image.network(
                                homeTeam['logo'],
                                width: 100,
                                height: 100,
                              ),
                              SizedBox(height: 10),
                              Text(
                                homeTeam['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'VS',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: [
                              Image.network(
                                awayTeam['logo'],
                                width: 100,
                                height: 100,
                              ),
                              SizedBox(height: 10),
                              Text(
                                awayTeam['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(
                        venue != null ? venue['name'] : 'Pas de stade défini',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        color: Colors.white,
                        child: Text(
                          'Historique des rencontres',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FutureBuilder<List<dynamic>>(
                        future: fetchHead2Head(homeTeam['id'], awayTeam['id']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData) {
                            return Center(child: Text('Pas d Historique'));
                          } else {
                            var head2head = snapshot.data!;
                            return Column(
                              children: head2head.map((match) {
                                var score = match['score'];
                                var fulltime =
                                    score != null && score['fulltime'] != null
                                        ? score['fulltime']
                                        : {'home': 0, 'away': 0};
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      '${match['teams']['home']['name']} vs ${match['teams']['away']['name']}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      'Score: ${fulltime['home']} - ${fulltime['away']}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
