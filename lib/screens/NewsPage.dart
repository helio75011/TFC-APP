import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'About.dart';
import 'MatchDetails.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  Future<List<dynamic>> fetchUpcomingMatches() async {
    final String apiUrl =
        'https://v3.football.api-sports.io/fixtures?team=96&next=10';
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 30),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 90, bottom: 80),
                  child: Image.asset(
                    'assets/toulouse_logo.png',
                    height: 50,
                    width: 50,
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                  child: Image.asset(
                    'assets/icon.png',
                    height: 50,
                    width: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
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
        child: FutureBuilder<List<dynamic>>(
          future: fetchUpcomingMatches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Pas de matchs'));
            } else {
              List<dynamic> matches = snapshot.data!;
              return ListView.builder(
                itemCount: matches.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Prochains Matchs',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  var match = matches[index - 1];
                  var fixture = match['fixture'];
                  var homeTeam = match['teams']['home'];
                  var awayTeam = match['teams']['away'];
                  var date = DateTime.parse(fixture['date']);
                  var formattedDate = "${date.day}/${date.month}/${date.year}";

                  return HoverableMatchCard(
                    homeTeam: homeTeam,
                    awayTeam: awayTeam,
                    formattedDate: formattedDate,
                    match: match,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class HoverableMatchCard extends StatefulWidget {
  final dynamic homeTeam;
  final dynamic awayTeam;
  final String formattedDate;
  final dynamic match;

  HoverableMatchCard({
    required this.homeTeam,
    required this.awayTeam,
    required this.formattedDate,
    required this.match,
  });

  @override
  _HoverableMatchCardState createState() => _HoverableMatchCardState();
}

class _HoverableMatchCardState extends State<HoverableMatchCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchDetailsPage(match: widget.match),
            ),
          );
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: _isHovering
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border:
                _isHovering ? Border.all(color: Colors.white, width: 1) : null,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.network(
                        widget.homeTeam['logo'],
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.homeTeam['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 30),
                  Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    children: [
                      Image.network(
                        widget.awayTeam['logo'],
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.awayTeam['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Date: ${widget.formattedDate}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
