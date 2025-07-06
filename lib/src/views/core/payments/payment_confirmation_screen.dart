import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/cards_controller.dart';
import '../../../controllers/transaction_controller.dart';
import '../../../models/saved_cards_model.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final String purpose;
  final double amount;

  const PaymentConfirmationScreen({
    super.key,
    required this.purpose,
    required this.amount,
  });

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  final SavedCardsController _savedCardsController = SavedCardsController();
  final transactionController _txController = transactionController();

  late Future<List<SavedCardModel>> _futureSavedCards;
  List<SavedCardModel> _savedCards = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _futureSavedCards = _savedCardsController.fetchSavedCards();
  }

  Future<void> _confirmAndPay() async {
    setState(() => _isLoading = true);

    try {
      final payload = {
        'amount': widget.amount.toInt(), // e.g. ₦6000 becomes 600000
        'purpose': widget.purpose,
      };

      final response = await _txController.chargeCard(payload);

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Payment successful!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pop(context, true); // return success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment failed: ${response['gateway_response'] ?? 'Unknown error'}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(Icons.lock_outline, size: 50, color: colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              'You are about to make a payment',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 30),

            // Payment info
            ListTile(
              leading: Icon(Icons.description, color: colorScheme.primary),
              title: Text(widget.purpose),
              subtitle: const Text(
                'Payment Type',
                style: TextStyle(fontSize: 10),
              ),
              trailing: Text(
                '₦${widget.amount.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ),

            const Divider(height: 32),

            // Saved card info
            FutureBuilder<List<SavedCardModel>>(
              future: _futureSavedCards,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final cards = snapshot.data ?? [];

                if (_savedCards.isEmpty && cards.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _savedCards = cards;
                    });
                  });
                }

                if (cards.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("No card available to charge."),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // Go back
                          DefaultTabController.of(
                            context,
                          )?.animateTo(0); // Switch tab
                        },
                        icon: const Icon(Icons.add_card),
                        label: const Text('Add a payment card'),
                      ),
                    ],
                  );
                }

                final card = cards.first;

                return ListTile(
                  leading: const Icon(
                    Icons.credit_card,
                    color: Colors.blueGrey,
                  ),
                  title: Text('**** **** **** ${card.lastFour}'),
                  subtitle: Text(
                    "${card.cardType.isNotEmpty ? card.cardType : 'Card'} - Exp ${card.expMonth}/${card.expYear}",
                  ),
                  trailing: const Text("Saved Card"),
                );
              },
            ),

            const Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed:
                        (_isLoading || _savedCards.isEmpty)
                            ? null
                            : _confirmAndPay,
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text('Confirm & Pay'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
