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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMatches();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMatches(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  Future<void> _loadMatches({bool loadMore = false}) async {
    if (_isLoadingMore || (!_hasMore && loadMore)) return;

    setState(() {
      if (!loadMore) {
        _isLoading = true;
        _page = 1; // reset page for refresh
        _hasMore = true; // reset hasMore on refresh
      }
      _isLoadingMore = loadMore;
      if (!loadMore) _matches = []; // clear current matches on refresh
      _error = null;
    });

    try {
      final newMatches = await _controller.getPublicBookings(page: _page);
      setState(() {
        if (newMatches.isEmpty) {
          _hasMore = false;
        } else {
          _page++;
          _matches.addAll(newMatches);
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  // Future<void> _loadMatches({bool loadMore = false}) async {
  //   if (_isLoadingMore || (!_hasMore && loadMore)) return;
  //   setState(() {
  //     if (!loadMore) _isLoading = true;
  //     _isLoadingMore = loadMore;
  //     _error = null;
  //   });

  //   try {
  //     final newMatches = await _controller.getPublicBookings(page: _page);
  //     setState(() {
  //       if (newMatches.isEmpty) {
  //         _hasMore = false;
  //       } else {
  //         _page++;
  //         _matches.addAll(newMatches);
  //       }
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _error = e.toString();
  //     });
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //       _isLoadingMore = false;
  //     });
  //   }
  // }

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
                      : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount:
                            _matches.length +
                            1 +
                            (_hasMore && _isLoadingMore ? 1 : 0),

                        itemBuilder: (context, i) {
                          if (i == 0) {
                            // Header
                            return const Padding(
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
                            );
                          }

                          if (i == _matches.length + 1 &&
                              _hasMore &&
                              _isLoadingMore) {
                            // Show spinner only when loading more data
                            return const Padding(
                              padding: EdgeInsets.all(8),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (i > 0 && i <= _matches.length) {
                            final match = _matches[i - 1];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                // vertical: 4.0,
                                horizontal: 10.0,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  // Navigator.pushNamed(
                                  //   context,
                                  //   AppRoutes.matchDetailsScreen,
                                  //   arguments: match,
                                  // );

                                  final didJoin = await Navigator.pushNamed(
                                    context,
                                    AppRoutes.matchDetailsScreen,
                                    arguments: match,
                                  );

                                  if (didJoin == true) {
                                    _loadMatches();
                                  }
                                },
                                child: AvailableMatchCard(match: match),
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}




 // const SizedBox(height: 24),
                            // const Padding(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 16,
                            //     vertical: 8,
                            //   ),
                            //   child: Text(
                            //     'Request Your Place',
                            //     style: TextStyle(
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            // SingleChildScrollView(
                            //   scrollDirection: Axis.horizontal,
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 16,
                            //   ),
                            //   child: Row(
                            //     children:
                            //         _matches.map((match) {
                            //           return Padding(
                            //             padding: const EdgeInsets.only(
                            //               right: 12,
                            //             ),
                            //             child: SizedBox(
                            //               width: 380,
                            //               child: GestureDetector(
                            //                 onTap: () {
                            //                   Navigator.pushNamed(
                            //                     context,
                            //                     AppRoutes.matchDetailsScreen,
                            //                     arguments: match,
                            //                   );
                            //                 },
                            //                 child: AvailableMatchCard(
                            //                   match: match,
                            //                 ),
                            //               ),
                            //             ),
                            //           );
                            //         }).toList(),
                            //   ),
                            // ),