import 'dart:convert';

import 'package:batch10auth/data/database_repository.dart';
import 'package:batch10auth/features/restaurant/domain/restaurant.dart';
import 'package:batch10auth/features/restaurant/domain/reviews.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository implements DatabaseRepository {
  final _db = FirebaseFirestore.instance;

  final restaurantsRef = FirebaseFirestore.instance
      .collection('restaurants')
      .withConverter<Restaurant>(
        fromFirestore: (snapshot, _) =>
            Restaurant.fromJson(snapshot.data()!, snapshot.id),
        toFirestore: (Restaurant restaurant, _) => restaurant.toJson(),
      );

  // Restaurants
  @override
  Stream<List<Restaurant>> watchRestaurants() => _db
      .collection('restaurants')
      .orderBy('name')
      .snapshots()
      .map(
        (e) => e.docs.map((doc) {
          final docId = doc.id;
          return Restaurant.fromJson(doc.data(), docId);
        }).toList(),
      );

  Stream<List<Restaurant>> watchRestaurantsWithConverter() => restaurantsRef
      .orderBy('name')
      .snapshots()
      .map((e) => e.docs.map((docs) => docs.data()).toList());

  Future<List<Restaurant>> getRestaurantsWithConverter() async {
    final snap = await restaurantsRef.get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<String> addRestaurant(String name) async {
    final doc = await _db.collection('restaurants').add({'name': name});
    return doc.id;
  }

  /*
  @override
  Future<String> deleteRestaurant(String name) async {
    final doc = await _db.collection('restaurants').;
    return doc.id;
  }
*/
  Future<String> addRestaurantWithConverter(Restaurant restaurant) async {
    final doc = await restaurantsRef.add(restaurant);
    return doc.id;
  }

  // Reviews für ein Restaurant (Subcollection)
  @override
  Stream<List<Review>> watchReviews(String restaurantId) => _db
      .collection('restaurants')
      .doc(restaurantId)
      .collection('reviews')
      .snapshots()
      .map(
        (e) =>
            e.docs.map((doc) => Review.fromJson(doc.data(), doc.id)).toList(),
      );

  @override
  Future<void> addReview({
    required String restaurantId,
    required int rating, // 1..5
    required String text,
  }) async {
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('reviews')
        .add({'rating': rating, 'text': text});
  }

  //TODO User einfügen
}
