class Statistic {
  final String teamName;
  final String leagueName;
  final String leagueCountry;
  final String position;
  final int appearances;
  final int lineups;
  final int minutes;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;

  Statistic({
    required this.teamName,
    required this.leagueName,
    required this.leagueCountry,
    required this.position,
    required this.appearances,
    required this.lineups,
    required this.minutes,
    required this.goals,
    required this.assists,
    required this.yellowCards,
    required this.redCards,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      teamName: json['team']['name'] ?? 'inconnu',
      leagueName: json['league']['name'] ?? 'inconnu',
      leagueCountry: json['league']['country'] ?? 'inconnu',
      position: json['games']['position'] ?? 'inconnu',
      appearances: json['games']['appearences'] ?? 0,
      lineups: json['games']['lineups'] ?? 0,
      minutes: json['games']['minutes'] ?? 0,
      goals: json['goals']['total'] ?? 0,
      assists: json['goals']['assists'] ?? 0,
      yellowCards: json['cards']['yellow'] ?? 0,
      redCards: json['cards']['red'] ?? 0,
    );
  }
}
