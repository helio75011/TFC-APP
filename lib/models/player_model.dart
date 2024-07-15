class Player {
  final int id;
  final String name;
  final String photoUrl;
  final String position;
  bool isHovered;

  Player({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.position,
    this.isHovered = false,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? 0,
      name: json['name'],
      photoUrl: json['photo'],
      position: json['position'],
      isHovered: false,
    );
  }
}
