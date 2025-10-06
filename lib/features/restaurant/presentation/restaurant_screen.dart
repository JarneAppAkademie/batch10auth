import 'package:batch10auth/data/database_repository.dart';
import 'package:batch10auth/data/restaurant_provider.dart';
import 'package:batch10auth/data/review_provider.dart';
import 'package:batch10auth/features/restaurant/domain/restaurant.dart';
import 'package:batch10auth/features/restaurant/presentation/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});
  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantProvider>().loadRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseRepository db = context.read<DatabaseRepository>();
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
      body: Consumer<RestaurantProvider>(
        builder: (context, data, child) {
          if (data.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (data.restaurants.isEmpty){
            return const Center(child: Text('Noch keine Restaurants'));
          }

          return ListView.separated(
            itemCount: data.restaurants.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final id = data.restaurants[i].id;
              final name = data.restaurants[i].name;
              return ListTile(
                title: Text(name),
                trailing: Consumer<ReviewProvider>(builder: (context, reviewData, child) => Text("${reviewData.reviews[id]?.length ?? 0}")),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RestaurantDetailPage(
                      restaurantId: id,
                      restaurantName: name,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Restaurant'),
        onPressed: () async {
          final name = await _askForText(
            context,
            title: 'Neues Restaurant',
            label: 'Name',
          );
          if (name == null || name.trim().isEmpty) return;
          if(context.mounted){
            context.read<RestaurantProvider>().addRestaurants(name);
          }
          
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Restaurant erstellt')));
        },
      ),
    );
  }
}

/// Kleiner Helfer für Text-Dialog
Future<String?> _askForText(
  BuildContext context, {
  required String title,
  required String label,
}) async {
  final ctrl = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, ctrl.text),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
