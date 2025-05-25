class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extract types from the types array
    final typesList = (json['types'] as List)
        .map((type) => type['type']['name'] as String)
        .toList();

    return Pokemon(
      id: json['id'],
      name: json['name'],
      // Official artwork from the sprites
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      types: typesList,
      height: json['height'],
      weight: json['weight'],
    );
  }
}