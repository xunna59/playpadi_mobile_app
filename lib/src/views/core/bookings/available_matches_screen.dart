import 'package:flutter/material.dart';
import '../../../controllers/match_controller.dart';
import '../../../models/match_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/available_matches_card.dart';

class AvailableMatchesScreen extends StatefulWidget {
  const AvailableMatchesScreen({super.key});

  @override
  State<AvailableMatchesScreen> createState() => _AvailableMatchesScreenState();
}

class _AvailableMatchesScreenState extends State<AvailableMatchesScreen> {
  final MatchController _controller = MatchController();
  List<MatchModel> _matches = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _controller.getPublicBookings();
      setState(() {
        _matches = data;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildFilterChip({
    required String label,
    bool selected = false,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (selected ? colorScheme.primary : Colors.grey[200]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? (selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Available'),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.notifications_none),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(label: 'Padel', selected: true),
                  const SizedBox(width: 8),
                  _buildFilterChip(label: '24 Clubs'),
                  const SizedBox(width: 8),
                  _buildFilterChip(label: 'Today'),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Clear',
                    backgroundColor: Colors.grey[200],
                    textColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadMatches,
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(child: Text('Error: $_error'))
                      : _matches.isEmpty
                      ? const Center(child: Text('No matches found.'))
                      : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Text(
                                'All Available Matches',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListView.builder(
                              itemCount: _matches.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemBuilder:
                                  (context, i) => GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.matchDetailsScreen,
                                        arguments: _matches[i],
                                      );
                                    },
                                    child: AvailableMatchCard(
                                      match: _matches[i],
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 24),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                'Request Your Place',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children:
                                    _matches.map((match) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: SizedBox(
                                          width: 380,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.matchDetailsScreen,
                                                arguments: match,
                                              );
                                            },
                                            child: AvailableMatchCard(
                                              match: match,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
