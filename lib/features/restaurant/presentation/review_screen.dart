import 'package:batch10auth/data/database_repository.dart';
import 'package:batch10auth/features/restaurant/presentation/add_review_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });
  final String restaurantId;
  final String restaurantName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurantName)),
      body: StreamBuilder(
        stream: context.read<DatabaseRepository>().watchReviews(restaurantId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final reviews = snap.data ?? [];
          if (reviews.isEmpty)
            return const Center(child: Text('Noch keine Reviews'));
          return ListView.separated(
            itemCount: reviews.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final review = reviews[i];
              final rating = review.rating;
              final text = review.text;
              return ListTile(
                leading: Text(
                  '⭐' * rating,
                  style: const TextStyle(fontSize: 18),
                ),
                title: Text(text.isEmpty ? '(kein Text)' : text),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.rate_review),
        label: const Text('Review'),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => AddReviewSheet(restaurantId: restaurantId),
        ),
      ),
    );
  }
}
