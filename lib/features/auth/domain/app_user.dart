class AppUser {
  // Attribute
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  // Konstruktor
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email, 'photoUrl': photoUrl};
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map["uid"],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
    );
  }
  factory AppUser.fromMapAndID(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
    );
  }
}
