import 'package:batch10auth/data/database_repository.dart';
import 'package:batch10auth/features/restaurant/domain/restaurant.dart';
import 'package:batch10auth/features/restaurant/domain/reviews.dart';
import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier {
  DatabaseRepository db;

  ReviewProvider({required this.db});

  final Map<String, List<Review>> _reviews = {};

  Map<String, List<Review>> get reviews => _reviews;

  bool isLoading = true;

  //TODO add only load once
  Future<void> loadReviews(String restaurantId) async {
    final loadedReviews = await db.getReviews(restaurantId);
    reviews[restaurantId] = loadedReviews;
    isLoading = false;
    notifyListeners();
  }

  Future<void> addReview(String restaurantId, String text, int rating) async {
    String id = await db.addReview(
      restaurantId: restaurantId,
      rating: rating,
      text: text,
    );
    if (reviews[restaurantId] == null) {
      reviews[restaurantId] = [Review(id: id, rating: rating, text: text)];
    } else {
      reviews[restaurantId]!.add(Review(id: id, rating: rating, text: text));
    }

    notifyListeners();
  }
}
