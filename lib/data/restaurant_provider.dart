import 'package:batch10auth/data/database_repository.dart';
import 'package:batch10auth/features/restaurant/domain/restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  DatabaseRepository db;
  RestaurantProvider({required this.db});

  final List<Restaurant> _restaurants = [];
  bool isLoading = true;

  List<Restaurant> get restaurants => _restaurants;
  //TODO add only load once
  Future<void> loadRestaurants() async {
    _restaurants.clear();
    _restaurants.addAll(await db.getRestaurantsWithConverter());
    isLoading = false;
    notifyListeners();
  }

  Future<void> addRestaurants(String name) async {
    String id = await db.addRestaurant(name);

    _restaurants.add(Restaurant(id: id, name: name));

    notifyListeners();
  }
}
