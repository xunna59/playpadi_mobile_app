import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../playpadi_library.dart';
import '../../../controllers/event_centers_controller.dart';
import '../../../core/constants.dart';
import '../../../models/event_center_model.dart';
import '../../../widgets/academy_section.dart';
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
  late final WebViewController _controller;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _loadCenter();

    //  print(widget.eventCenter.latitude);
  }

  void addToFavorites(int? eventCenter) async {
    if (eventCenter == null) return;

    //   print(eventCenter);

    Map<String, String> payload = {'sports_center_id': eventCenter.toString()};

    try {
      final addToFavouriteStatus = await EventCentersController()
          .addToFavourite(payload);
    } catch (e) {
      // handle error
      print('Error adding to favorites: $e');
    }
  }

  void removeFromFavorites(int? eventCenter) async {
    if (eventCenter == null) return;

    //   print(eventCenter);

    Map<String, String> payload = {'sports_center_id': eventCenter.toString()};

    try {
      final removeFromFavouriteStatus = await EventCentersController()
          .removeFromFavourite(payload);
      // handle fetchedCenter if needed
    } catch (e) {
      // handle error
      print('Error removing from favorites: $e');
    }
  }

  Future<void> _loadCenter() async {
    try {
      final fetchedCenter = await EventCentersController().fetchCenterById(
        widget.eventCenter.id,
      );

      _controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(
              Uri.dataFromString('''
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            html, body {
              margin: 0;
              padding: 0;
              overflow: hidden;
              height: 100%;
              width: 100%;
            }
            iframe {
              pointer-events: none;
            }
          </style>
        </head>
        <body>
          <iframe
            width="100%" height="100%" frameborder="0" style="border:0"
            src="https://www.google.com/maps?q=${fetchedCenter?.latitude},${fetchedCenter?.longitude}&hl=es;z=14&output=embed"
            >
          </iframe>
        </body>
      </html>
      ''', mimeType: 'text/html'),
            );

      setState(() {
        eventCenter = fetchedCenter;
        _isMapReady = true;
      });

      print(eventCenter?.isFavourite);
    } on NetworkErrorException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.orange),
        );
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    //  int totalCourts = widget.eventCenter.courts?.length ?? 0;

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
                    onPressed: () {
                      SharePlus.instance.share(
                        ShareParams(
                          text:
                              'Book a Match in ${widget.eventCenter.name} visit https://playpadi.com to Get Started',
                        ),
                      );
                    },
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
                    color: colorScheme.primaryContainer,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: IconButton(
                              icon: Icon(
                                eventCenter?.isFavourite == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    eventCenter?.isFavourite == true
                                        ? Color.fromRGBO(199, 3, 125, 1)
                                        : Colors.grey,
                              ),

                              // onPressed: () {
                              //   if (eventCenter?.isFavourite == true) {
                              //     removeFromFavorites(eventCenter?.id);
                              //   } else {
                              //     addToFavorites(eventCenter?.id);
                              //   }
                              // },
                              onPressed: () async {
                                if (eventCenter == null) return;

                                if (eventCenter!.isFavourite == true) {
                                  removeFromFavorites(eventCenter!.id);
                                  setState(() {
                                    eventCenter = eventCenter!.copyWith(
                                      isFavourite: false,
                                    );
                                  });
                                } else {
                                  addToFavorites(eventCenter!.id);
                                  setState(() {
                                    eventCenter = eventCenter!.copyWith(
                                      isFavourite: true,
                                    );
                                  });
                                }
                              },
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
              length: 4, // number of tabs
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    labelColor: colorScheme.primary,
                    indicatorColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle: TextStyle(fontSize: 12),
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    tabs: const [
                      Tab(text: 'Home'),
                      Tab(text: 'Book'),
                      Tab(text: 'Open Matches'),
                      Tab(text: 'Academy'),
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
                              const SizedBox(height: 20),
                              if (eventCenter?.total_courts != null)
                                Text(
                                  '${eventCenter!.total_courts} available courts',
                                ),

                              const SizedBox(height: 18),

                              // AS CAROUSEL
                              // Center(
                              //   child: SingleChildScrollView(
                              //     scrollDirection: Axis.horizontal,
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children:
                              //           widget.eventCenter.features
                              //               .map(
                              //                 (feature) => Padding(
                              //                   padding: const EdgeInsets.only(
                              //                     right: 15.0,
                              //                   ),
                              //                   child: Text(
                              //                     feature,
                              //                     style: const TextStyle(
                              //                       //   fontWeight: FontWeight.bold,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               )
                              //               .toList(),
                              //     ),
                              //   ),
                              // ),
                              // AS WRAPPED
                              // Wrap(
                              //   alignment:
                              //       WrapAlignment
                              //           .start, // aligns children to the left
                              //   spacing: 15.0,
                              //   runSpacing: 10.0,
                              //   children:
                              //       widget.eventCenter.features
                              //           .map(
                              //             (feature) => Text(
                              //               feature,
                              //               style: const TextStyle(
                              //                 // fontWeight: FontWeight.bold,
                              //               ),
                              //             ),
                              //           )
                              //           .toList(),
                              // ),
                              // AS GRID PATTERN
                              GridView.count(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount:
                                    4, // Adjust to your layout needs
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 12,
                                childAspectRatio: 4, // Wider cells
                                children:
                                    widget.eventCenter.features
                                        .map(
                                          (feature) => Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              feature,
                                              style: const TextStyle(
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),

                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ClubAction(
                                    icon: Icons.directions,
                                    label: 'DIRECTIONS',
                                    color: colorScheme.primary,
                                    onTap: () async {
                                      final googleMapsUrl = Uri.parse(
                                        'https://www.google.com/maps/search/?api=1&query=${eventCenter?.latitude},${eventCenter?.longitude}', // Example: Googleplex
                                      );
                                      if (await canLaunchUrl(googleMapsUrl)) {
                                        await launchUrl(googleMapsUrl);
                                      } else {
                                        print('Could not open the map.');
                                      }
                                    },
                                  ),
                                  ClubAction(
                                    icon: Icons.language,
                                    label: 'WEB',
                                    color: colorScheme.primary,
                                    onTap: () async {
                                      final url = Uri.parse(
                                        eventCenter?.website ??
                                            'https://thepadelbay.com',
                                      );

                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(
                                          url,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        print('Could not open the website.');
                                      }
                                    },
                                  ),
                                  ClubAction(
                                    icon: Icons.phone,
                                    label: 'CALL',
                                    color: colorScheme.primary,
                                    onTap: () async {
                                      final phoneUri = Uri(
                                        scheme: 'tel',
                                        path:
                                            eventCenter?.phone ?? '1234567890',
                                      );

                                      if (await canLaunchUrl(phoneUri)) {
                                        await launchUrl(
                                          phoneUri,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        //  print('Could not launch phone dialer.');
                                      }
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                              // Map Container (covers full width)
                              SizedBox(
                                height: 180,
                                width: double.infinity,
                                child:
                                    _isMapReady
                                        ? WebViewWidget(controller: _controller)
                                        : Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
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
                        BookSectionContent(
                          bookingId: widget.eventCenter.id,
                          sports_center_address: widget.eventCenter.address,
                          sports_center_name: widget.eventCenter.name,
                          games: widget.eventCenter.games,
                        ),

                        // --- Open Matches Tab ---
                        BookOpenMatch(
                          bookingId: widget.eventCenter.id,
                          sports_center_address: widget.eventCenter.address,
                          sports_center_name: widget.eventCenter.name,
                          games: widget.eventCenter.games,
                        ),

                        // --- Academy Tab ---
                        AcademySection(),
                        // const Center(child: Text('Academy Section')),
                        // --- Memberships Tab ---
                        // const Center(child: Text('Membership Section')),
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
