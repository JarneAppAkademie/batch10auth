import 'package:batch10auth/features/restaurant/domain/restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  List<Restaurant> restaurants = [];

  List<Restaurant> getRestaurants() => restaurants;

  void addRestaurants(Restaurant restaurant) {
    restaurants.add(restaurant);
    notifyListeners();
  }
}
