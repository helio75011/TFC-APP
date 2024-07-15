import 'package:flutter/material.dart';

class PlayersPage extends StatelessWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joueurs'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Player 1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
