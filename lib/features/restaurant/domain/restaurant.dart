class Restaurant {
  final String id;
  final String name;

  Restaurant({required this.id, required this.name});

  factory Restaurant.fromJson(Map<String, dynamic> json, String id) {
    return Restaurant(id: id, name: json['name'] ?? '');
  }

  Map<String, Object?> toJson() => {'name': name};
}
