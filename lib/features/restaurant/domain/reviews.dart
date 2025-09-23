import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final int rating; // 1..5
  final String text;

  Review({required this.id, required this.rating, required this.text});

  factory Review.fromJson(Map<String, dynamic> json, String id) {
    return Review(
      id: id,
      rating: (json['rating'] as num).toInt(),
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, Object?> toJsonForCreate() => {'rating': rating, 'text': text};
}
