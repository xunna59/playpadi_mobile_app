import 'package:flutter/material.dart';

import '../../../../controllers/faq_controller.dart';
import '../../../../models/faq_model.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final FaqController _faqController = FaqController();
  final TextEditingController _searchController = TextEditingController();

  List<Faq> _faqs = [];
  List<Faq> _filteredFaqs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFaqs() async {
    final fetchedFaqs = await _faqController.fetchFaqs();
    setState(() {
      _faqs = fetchedFaqs;
      _filteredFaqs = fetchedFaqs;
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFaqs =
          _faqs.where((faq) {
            return faq.question.toLowerCase().contains(query) ||
                faq.answer.toLowerCase().contains(query);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("How PlayPadi works"),
        leading: const BackButton(),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search help",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredFaqs.isEmpty
                      ? const Center(child: Text("No FAQs found."))
                      : ListView.builder(
                        itemCount: _filteredFaqs.length,
                        itemBuilder: (context, index) {
                          final faq = _filteredFaqs[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  faq.question,
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  faq.answer,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
