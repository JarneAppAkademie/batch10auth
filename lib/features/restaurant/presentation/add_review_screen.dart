import 'package:batch10auth/data/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Bottom-Sheet: Review hinzufügen (Rating 1–5 + Text)
class AddReviewSheet extends StatefulWidget {
  const AddReviewSheet({
    super.key,
    required this.restaurantId,
  });
  final String restaurantId;

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  double _rating = 4; // startwert
  final _textCtrl = TextEditingController();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Review hinzufügen',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Sterne:'),
                  Expanded(
                    child: Slider(
                      min: 1,
                      max: 5,
                      divisions: 4,
                      value: _rating,
                      label: _rating.toStringAsFixed(0),
                      onChanged: (v) => setState(() => _rating = v),
                    ),
                  ),
                  Text(_rating.toStringAsFixed(0)),
                ],
              ),
              TextField(
                controller: _textCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Dein Text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: const Text('Speichern'),
                onPressed: _saving
                    ? null
                    : () async {
                        try {
                          setState(() => _saving = true);
                          await context.read<DatabaseRepository>().addReview(
                            restaurantId: widget.restaurantId,
                            rating: _rating.round(),
                            text: _textCtrl.text.trim(),
                          );
                          if (mounted) Navigator.pop(context);
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
                        } finally {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
