class Player {
  final int id;
  final String firstName;
  final String lastName;
  final String position;

  Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.position,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      position: json['position'] ?? '',
    );
  }
}
