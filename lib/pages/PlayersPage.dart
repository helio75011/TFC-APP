import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/About.dart';
import '../models/player_model.dart';
import './PlayerDetailsPage.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  late Future<List<Player>> _playersFuture;
  List<Player> _players = [];
  List<Player> _filteredPlayers = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _playersFuture = fetchPlayers();
    _searchController.addListener(_filterPlayers);
  }

  Future<List<Player>> fetchPlayers() async {
    final String apiUrl =
        'https://v3.football.api-sports.io/players/squads?team=96';
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

      if (jsonData != null &&
          jsonData['response'] != null &&
          jsonData['response'].isNotEmpty) {
        List<Player> players = [];

        var team = jsonData['response'][0]['players'];
        for (var item in team) {
          Player player = Player.fromJson(item);
          players.add(player);
        }

        setState(() {
          _players = players;
          _filteredPlayers = players;
        });

        return players;
      } else {
        throw Exception('Reponse invalide');
      }
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }

  void _filterPlayers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlayers = _players
          .where((player) => player.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170),
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 30),
          child: Column(
            children: [
              AppBar(
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
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un joueur...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
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
        child: FutureBuilder<List<Player>>(
          future: _playersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Pas de joueurs'));
            } else {
              return _buildPlayerList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildPlayerList() {
    List<Widget> playerList = [];

    playerList.add(_buildCategoryHeader('Gardiens'));
    playerList.addAll(_buildPlayerItems(_filteredPlayers
        .where((player) => player.position == 'Goalkeeper')
        .toList()));

    playerList.add(_buildCategoryHeader('Défenseurs'));
    playerList.addAll(_buildPlayerItems(_filteredPlayers
        .where((player) => player.position == 'Defender')
        .toList()));

    playerList.add(_buildCategoryHeader('Milieux'));
    playerList.addAll(_buildPlayerItems(_filteredPlayers
        .where((player) => player.position == 'Midfielder')
        .toList()));

    playerList.add(_buildCategoryHeader('Attaquants'));
    playerList.addAll(_buildPlayerItems(_filteredPlayers
        .where((player) => player.position == 'Attacker')
        .toList()));

    return ListView(
      children: playerList,
    );
  }

  List<Widget> _buildPlayerItems(List<Player> players) {
    return players.map((player) {
      return MouseRegion(
        onEnter: (_) => setState(() => player.isHovered = true),
        onExit: (_) => setState(() => player.isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayerDetailsPage(player: player),
              ),
            );
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: player.isHovered
                  ? Colors.white.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: player.isHovered
                  ? Border.all(color: Colors.white, width: 1)
                  : null,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(player.photoUrl),
                ),
                SizedBox(width: 20),
                Text(
                  player.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildCategoryHeader(String categoryName) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      padding: EdgeInsets.all(15.0),
      color: Colors.white,
      child: Text(
        categoryName,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
