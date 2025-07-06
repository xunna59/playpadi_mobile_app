import 'package:flutter/material.dart';

import '../../../../controllers/cards_controller.dart';
import '../../../../models/saved_cards_model.dart';

class PaymentMethodsTab extends StatefulWidget {
  final VoidCallback onAddCard;

  const PaymentMethodsTab({super.key, required this.onAddCard});

  @override
  State<PaymentMethodsTab> createState() => _PaymentMethodsTabState();
}

class _PaymentMethodsTabState extends State<PaymentMethodsTab> {
  final SavedCardsController _savedCardsController = SavedCardsController();
  late Future<List<SavedCardModel>> _futureSavedCards;

  @override
  void initState() {
    super.initState();
    _futureSavedCards = _savedCardsController.fetchSavedCards();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: widget.onAddCard,
            icon: const Icon(Icons.add),
            label: const Text("Add payment card"),
            style: TextButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: FutureBuilder<List<SavedCardModel>>(
              future: _futureSavedCards,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load cards: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final cards = snapshot.data ?? [];

                if (cards.isEmpty) {
                  return const Center(child: Text("No saved cards yet."));
                }

                return ListView.separated(
                  itemCount: cards.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.secondary),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.credit_card, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "**** **** **** ${card.lastFour}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${card.cardType.isNotEmpty ? card.cardType : 'Card'} - Exp ${card.expMonth}/${card.expYear}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
