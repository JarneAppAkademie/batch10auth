import 'package:batch10auth/data/database_repository.dart';
import 'package:batch10auth/data/review_provider.dart';
import 'package:batch10auth/features/restaurant/domain/reviews.dart';
import 'package:batch10auth/features/restaurant/presentation/add_review_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatefulWidget {
  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });
  final String restaurantId;
  final String restaurantName;

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewProvider>().loadReviews(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    final reviewData = context.watch<ReviewProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurantName)),
      body: reviewData.isLoading
          ? reviewData.reviews[widget.restaurantId]?.isEmpty ?? true
                ? const Center(child: Text('Noch keine Reviews'))
                : Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: reviewData.reviews[widget.restaurantId]?.length ?? 0,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final review = reviewData.reviews[widget.restaurantId]?[i];
                final int rating = review?.rating ?? 0;
                final text = review?.text ?? "";
                return ListTile(
                  leading: Text(
                    '⭐' * rating,
                    style: const TextStyle(fontSize: 18),
                  ),
                  title: Text(text.isEmpty ? '(kein Text)' : text),
                );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.rate_review),
        label: const Text('Review'),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => AddReviewSheet(restaurantId: widget.restaurantId),
        ),
      ),
    );
  }
}
