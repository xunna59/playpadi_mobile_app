import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/transaction_controller.dart';
import '../../../../models/transaction_model.dart';

class PaymentHistoryTab extends StatefulWidget {
  const PaymentHistoryTab({super.key});

  @override
  State<PaymentHistoryTab> createState() => _PaymentHistoryTabState();
}

class _PaymentHistoryTabState extends State<PaymentHistoryTab> {
  final transactionController _controller = transactionController();
  late Future<List<TransactionModel>> _futureTransactions;

  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    _futureTransactions = _controller.fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: _futureTransactions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final transactions = snapshot.data;

        if (transactions == null || transactions.isEmpty) {
          return const Center(child: Text("No payment history yet."));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: transactions.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                tx.purpose,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${_currencyFormatter.format(tx.amount)} • ${tx.status.toUpperCase()}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: tx.status == 'success' ? Colors.green : Colors.orange,
                ),
              ),
              trailing: Text(
                _formatDate(tx.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
