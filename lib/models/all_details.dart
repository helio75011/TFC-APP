class Player {
  final int id;
  final String name;
  final String firstname;
  final String lastname;
  final int age;
  final String birthDate;
  final String birthPlace;
  final String birthCountry;
  final String nationality;
  final String height;
  final String weight;
  final bool injured;
  final String photoUrl;

  Player({
    required this.id,
    required this.name,
    required this.firstname,
    required this.lastname,
    required this.age,
    required this.birthDate,
    required this.birthPlace,
    required this.birthCountry,
    required this.nationality,
    required this.height,
    required this.weight,
    required this.injured,
    required this.photoUrl,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    var player = json['player'];
    return Player(
      id: player['id'] ?? 0,
      name: player['name'] ?? 'inconnu',
      firstname: player['firstname'] ?? 'inconnu',
      lastname: player['lastname'] ?? 'inconnu',
      age: player['age'] ?? 0,
      birthDate: player['birth']['date'] ?? 'inconnu',
      birthPlace: player['birth']['place'] ?? 'inconnu',
      birthCountry: player['birth']['country'] ?? 'inconnu',
      nationality: player['nationality'] ?? 'inconnu',
      height: player['height'] ?? 'inconnu',
      weight: player['weight'] ?? 'inconnu',
      injured: player['injured'] ?? false,
      photoUrl: player['photo'] ?? 'https://via.placeholder.com/150',
    );
  }
}
