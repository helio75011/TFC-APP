import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'About.dart';
import '../services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    scheduleTestNotification();
  }

  Future<void> scheduleTestNotification() async {
    var scheduledDate = DateTime.now().add(Duration(seconds: 10));
    print('Test');
    await _notificationService.scheduleNotification(
      id: 0,
      title: 'Test Notification',
      body: 'Test',
      scheduledDate: scheduledDate,
    );
    print('Test notification');
  }

  Future<dynamic> fetchNextMatch() async {
    final String apiUrl =
        'https://v3.football.api-sports.io/fixtures?team=96&next=1';
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
        child: FutureBuilder<dynamic>(
          future: fetchNextMatch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Erreur'));
            } else {
              var match = snapshot.data;
              var homeTeam = match['teams']['home'];
              var awayTeam = match['teams']['away'];
              var date = DateTime.parse(match['fixture']['date']);
              var formattedDate =
                  "${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute}0";
              var venue = match['fixture']['venue']['name'];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Prochain Match :',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.network(
                            homeTeam['logo'],
                            height: 120,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            homeTeam['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 50.0),
                      Text(
                        'VS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 50.0),
                      Column(
                        children: [
                          Image.network(
                            awayTeam['logo'],
                            height: 120,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            awayTeam['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'au $venue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
