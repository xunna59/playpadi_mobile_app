import 'package:flutter/material.dart';
import '../../../controllers/event_centers_controller.dart';
import '../../../core/constants.dart';
import '../../../models/event_center_model.dart';
import '../../../widgets/book_open_match.dart';
import '../../../widgets/clubAction_widget.dart';
import '../../../widgets/book_section_content.dart';

class EventCenterDetailsScreen extends StatefulWidget {
  final EventCenter eventCenter;

  const EventCenterDetailsScreen({super.key, required this.eventCenter});

  @override
  State<EventCenterDetailsScreen> createState() =>
      _EventCenterDetailsScreenState();
}

class _EventCenterDetailsScreenState extends State<EventCenterDetailsScreen> {
  EventCenter? eventCenter;

  @override
  void initState() {
    super.initState();
    _loadCenter();
  }

  Future<void> _loadCenter() async {
    final fetchedCenter = await EventCentersController().fetchCenterById(
      widget.eventCenter.id,
    );

    setState(() {
      eventCenter = fetchedCenter;
      print(widget.eventCenter.games);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    int totalCourts = widget.eventCenter.courts?.length ?? 0;

    // if (eventCenter == null) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            backgroundColor: colorScheme.primary,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                  ),
                ),

                // const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Image and Title Panel
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.network(
                  '$imageBaseUrl${widget.eventCenter.coverImage}',
                  fit: BoxFit.cover,
                ),
              ),
              // Title over Image
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            widget.eventCenter.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.eventCenter.address,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Tabs and Content
          Expanded(
            child: DefaultTabController(
              length: 5, // We have 5 tabs now.
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    labelColor: colorScheme.primary,
                    indicatorColor: colorScheme.primary,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),

                    tabs: [
                      Tab(text: 'Home'),
                      Tab(text: 'Book'),
                      Tab(text: 'Open Matches'),
                      Tab(text: 'Academy'),
                      Tab(text: 'Memberships'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // --- Home Tab ---
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              const Text(
                                'Club Information',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.sports_tennis),
                                  SizedBox(width: 8),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 15,
                                    children:
                                        widget.eventCenter.games
                                            .map(
                                              (game) => Text(
                                                game,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '$totalCourts available courts',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 15,
                                  children:
                                      widget.eventCenter.features
                                          .map(
                                            (feature) => Text(
                                              feature,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),

                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ClubAction(
                                    icon: Icons.directions,
                                    label: 'DIRECTIONS',
                                    color: colorScheme.primary,
                                  ),
                                  ClubAction(
                                    icon: Icons.language,
                                    label: 'WEB',
                                    color: colorScheme.primary,
                                  ),
                                  ClubAction(
                                    icon: Icons.phone,
                                    label: 'CALL',
                                    color: colorScheme.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Map Container (covers full width)
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: screenWidth,
                                  height: 180,
                                  child: Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Text('Map Placeholder'),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Opening hours',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    eventCenter?.openingHours != null
                                        ? eventCenter!.openingHours!.entries.map((
                                          entry,
                                        ) {
                                          final day = entry.key;
                                          final hours = entry.value;

                                          // Safely access open and close times with a fallback for missing data
                                          final openTime =
                                              hours['open'] ?? 'N/A';
                                          final closeTime =
                                              hours['close'] ?? 'N/A';

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(day),
                                                Text('$openTime – $closeTime'),
                                              ],
                                            ),
                                          );
                                        }).toList()
                                        : [
                                          // If openingHours is null, display a placeholder message
                                          const Text(
                                            'No opening hours available',
                                          ),
                                        ], // Prevent crash if no hours exist
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        // --- Book Tab: Booking UI as a Reusable Widget ---
                        BookSectionContent(bookingId: widget.eventCenter.id),

                        // --- Open Matches Tab ---
                        BookOpenMatch(bookingId: widget.eventCenter.id),
                        // --- Academy Tab ---
                        const Center(child: Text('Academy Section')),
                        // --- Memberships Tab ---
                        const Center(child: Text('Membership Section')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
