import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/event_centers_controller.dart';
import '../models/booking_model.dart';
import '../controllers/booking_controller.dart';
import '../models/court_model.dart';
import '../models/event_center_model.dart';
import '../routes/app_routes.dart';
import 'confirm_booking_modal.dart';
import 'sport_modal_widget.dart';

class BookSectionContent extends StatefulWidget {
  final int bookingId;

  const BookSectionContent({super.key, required this.bookingId});

  @override
  State<BookSectionContent> createState() => _BookSectionContentState();
}

class _BookSectionContentState extends State<BookSectionContent> {
  String? selectedSport;

  int _selectedDateIndex = 0;
  bool _showAvailableSlotsOnly = false;
  String? _selectedTime;
  Future<BookingInfo?>? _bookingInfoFuture;
  Future<EventCenter?>? _fetchedCenter;

  @override
  void initState() {
    super.initState();
    _bookingInfoFuture = BookingController().fetchBookingInfoById(
      widget.bookingId,
    );
    _fetchedCenter = EventCentersController().fetchCenterById(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<BookingInfo?>(
      future: _bookingInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No booking info available.'));
        }

        final bookingInfo = snapshot.data!;
        final dates = bookingInfo.dates;
        final allTimes = dates[_selectedDateIndex].availableTimes;
        final filteredTimes =
            _showAvailableSlotsOnly
                ? allTimes.where((t) => t.status == 'available').toList()
                : allTimes;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final sport = await showSelectSportModal(context);
                      if (sport != null) {
                        setState(() {
                          selectedSport = sport;
                        });
                      }
                      print(selectedSport);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0, top: 12),
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                colorScheme.primary, // Customize border color
                            width: 1.0, // Customize border width
                          ),
                        ),
                        child: Image.asset(
                          'assets/icons/paddle_bat.png',
                          width: 25,
                          height: 25,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final date = dates[index];
                          final isSelected = index == _selectedDateIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDateIndex = index;
                                _selectedTime = null;
                              });
                            },
                            child: Container(
                              width: 60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    date.weekday,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? colorScheme.primary
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      date.day,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    date.month,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Text(
                    'Show Available Slots Only',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Switch(
                    value: _showAvailableSlotsOnly,
                    onChanged: (val) {
                      setState(() {
                        _showAvailableSlotsOnly = val;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTimes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  final time = filteredTimes[index];
                  final isSelected = time.time == _selectedTime;
                  final isAvailable = time.status == 'available';

                  return GestureDetector(
                    onTap:
                        isAvailable
                            ? () {
                              setState(() {
                                _selectedTime = time.time;
                              });
                            }
                            : null,
                    child: Opacity(
                      opacity: isAvailable ? 1.0 : 0.4,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.12),
                          ),
                        ),
                        child: Text(
                          time.time,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            decoration:
                                isAvailable ? null : TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                'Book a Court',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Create a Private Match Where You Can Invite Your Friends',
                style: TextStyle(fontSize: 12),
              ),

              const SizedBox(height: 12),

              FutureBuilder<EventCenter?>(
                future: _fetchedCenter,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No courts available.'));
                  }

                  final center = snapshot.data!;
                  final courts = center.courts;

                  if (courts == null || courts.isEmpty) {
                    return const Center(child: Text('No courts available.'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        courts.map((court) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  court.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(court.location),

                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection:
                                      Axis.horizontal, // Makes it scroll horizontally
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .start, // Align items to the start of the row
                                    children:
                                        court.courtData.map<Widget>((
                                          courtData,
                                        ) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16.0,
                                            ), // Add spacing between items
                                            child: GestureDetector(
                                              // Inside your GestureDetector onTap:
                                              onTap: () {
                                                if (selectedSport == null) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Please select a game first.",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Colors
                                                              .redAccent, // ← here
                                                    ),
                                                  );
                                                  return;
                                                }

                                                if (_selectedTime == null) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Please select a time first.",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Colors
                                                              .redAccent, // ← here
                                                    ),
                                                  );
                                                  return;
                                                }

                                                final dateObj =
                                                    dates[_selectedDateIndex];

                                                final selectedDateObj =
                                                    dates[_selectedDateIndex];

                                                final dateString =
                                                    selectedDateObj.date;

                                                final timeString =
                                                    _selectedTime!;

                                                final selectedCourt = court;

                                                final selectedGame =
                                                    selectedSport;

                                                showConfirmBookingModal(
                                                  context,
                                                  sport:
                                                      selectedGame!, // or whatever gameType you use
                                                  date:
                                                      dateString, // e.g. "2025-05-03"
                                                  time:
                                                      timeString, // e.g. "10:00 AM"
                                                  gender: 'mixed',
                                                  level: 2.2.toString(),
                                                  sessionPrice:
                                                      courtData.price
                                                          .toString(),
                                                  sessionDuration:
                                                      courtData.duration
                                                          .toString(),
                                                  court: selectedCourt.name,
                                                  sportsCenter: center.name,
                                                  sports_center_id: center.id,
                                                  court_id: selectedCourt.id,
                                                  bookingType: 'private',
                                                  address: center.address,
                                                  purpose: 'Book Private Match',
                                                );
                                              },

                                              child: _buildPriceOption(
                                                courtData,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceOption(CourtData courtData) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                //   courtData.price.toString(),
                '\₦${NumberFormat('#,##0', 'en_NG').format(courtData.price)}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                courtData.duration.toString() + " min",
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
