import 'package:batch10auth/features/restaurant/domain/restaurant.dart';
import 'package:batch10auth/features/restaurant/domain/reviews.dart';

abstract class DatabaseRepository {
  Future<String> addRestaurant(String name);
  Stream<List<Restaurant>> watchRestaurants();
  Future<void> addReview({
    required String restaurantId,
    required int rating,
    required String text,
  });
  Stream<List<Review>> watchReviews(String restaurantId);
  Future<void> addUser(String userId, String email);
}
