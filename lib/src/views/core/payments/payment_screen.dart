import 'package:PlayPadi/src/views/core/payments/payment_webview.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // optional fallback
import '../../../controllers/transaction_controller.dart';
import 'widgets/payment_history.dart';
import 'widgets/payment_methods.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Key _methodsTabKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _handleAddCard() async {
    try {
      final payload = {
        'amount': 100, // ₦100
        'purpose': 'Add new card',
      };

      final result = await transactionController().initializePayment(payload);

      if (result != null && result['authorization_url'] != null) {
        final url = result['authorization_url'];

        final payment_response = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PaymentWebView(url: url)),
        );

        if (payment_response == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Card Added Successfully',
                style: TextStyle(color: Colors.white), // Text color
              ),
              backgroundColor: Colors.green, // Background color
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          setState(() {
            _methodsTabKey = UniqueKey();
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to initialize payment')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Payments"), elevation: 0),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                indicator: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "Payment Methods"),
                  Tab(text: "Payment History"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PaymentMethodsTab(
                  key: _methodsTabKey,
                  onAddCard: _handleAddCard,
                ),
                const PaymentHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
