class Game {
  final int id;
  final String name;
  final String released;
  final String backgroundImage;
  final double rating;
  final String description;


  Game({
    required this.id,
    required this.name,
    required this.released,
    required this.backgroundImage,
    required this.rating,
    required this.description


  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      released: json['released'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      rating: json['rating'] ?? '',
      description: json['description_raw'] ?? '',

    );
  }
}