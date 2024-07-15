class PlayerModel {
  final int id;
  final String name;
  final String nationality;

  PlayerModel({
    required this.id,
    required this.name,
    required this.nationality,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['player_id'],
      name: json['player_name'],
      nationality: json['player_nationality'],
    );
  }
}

class PlayersResponseModel {
  final List<PlayerModel> players;

  PlayersResponseModel({required this.players});

  factory PlayersResponseModel.fromJson(Map<String, dynamic> json) {
    List<PlayerModel> players = [];
    if (json['api']['players'] != null) {
      players = List<PlayerModel>.from(
          json['api']['players'].map((player) => PlayerModel.fromJson(player)));
    }
    return PlayersResponseModel(players: players);
  }
}
