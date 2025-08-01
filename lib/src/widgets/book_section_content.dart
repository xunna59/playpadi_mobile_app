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
import 'inkwell_modal.dart';
import 'match_sports_modal.dart';

class BookSectionContent extends StatefulWidget {
  final int bookingId;
  final String sports_center_address;
  final String sports_center_name;
  final List<String> games;

  const BookSectionContent({
    super.key,
    required this.bookingId,
    required this.sports_center_address,
    required this.sports_center_name,
    required this.games,
  });

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

    if (widget.games.isNotEmpty) {
      selectedSport = widget.games.first;
    }

    final payload = {
      'id': widget.bookingId.toString(),
      'game_type': (selectedSport ?? '').toLowerCase(),
    };

    _bookingInfoFuture = BookingController().fetchBookingInfoById(payload);
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
          print('Booking info error: ${snapshot.error}');
          return const Center(child: Text('No booking info available.'));
        }

        final bookingInfo = snapshot.data!;
        final dates = bookingInfo.dates;
        final allTimes = dates[_selectedDateIndex].availableTimes;
        final filteredTimes =
            _showAvailableSlotsOnly
                ? allTimes.where((t) => t.totalAvailableCourts > 0).toList()
                : allTimes;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomFilterChip(
              //   label: selectedSport ?? 'Select Game',
              //   backgroundColor: Theme.of(context).colorScheme.primary,
              //   onTap: () async {
              //     final sport = await showMatchSelectSportModal(context);
              //     if (sport != null) {
              //       setState(() {
              //         selectedSport = sport;
              //       });
              //     }
              //   },
              // ),
              CustomFilterChip(
                label: selectedSport ?? 'Select Game',
                backgroundColor: Theme.of(context).colorScheme.primary,
                onTap: () async {
                  final sport = await showMatchSelectSportModal(
                    context,
                    sports: widget.games,
                  );

                  if (sport != null) {
                    setState(() {
                      selectedSport = sport;
                    });
                  }
                },
              ),

              const SizedBox(height: 2),

              Row(
                children: [
                  // GestureDetector(
                  //   onTap: () async {
                  //     final sport = await showSelectSportModal(context);
                  //     if (sport != null) {
                  //       setState(() {
                  //         selectedSport = sport;
                  //       });
                  //     }
                  //     print(selectedSport);
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(right: 5.0, top: 12),
                  //     child: Container(
                  //       height: 100,
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //         color: colorScheme.secondary,
                  //         borderRadius: BorderRadius.circular(8),
                  //         border: Border.all(
                  //           color:
                  //               colorScheme.primary, // Customize border color
                  //           width: 1.0, // Customize border width
                  //         ),
                  //       ),
                  //       child: Image.asset(
                  //         'assets/icons/paddle_bat.png',
                  //         width: 25,
                  //         height: 25,
                  //         fit: BoxFit.contain,
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                  final isAvailable = time.totalAvailableCourts > 0;

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

              FutureBuilder<BookingInfo?>(
                future: _bookingInfoFuture,
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

                  final bookingInfo = snapshot.data!;
                  final selectedDate = bookingInfo.dates[_selectedDateIndex];

                  BookingTime? selectedTimeSlot;

                  if (_selectedTime != null) {
                    selectedTimeSlot = selectedDate.availableTimes.firstWhere(
                      (time) => time.time == _selectedTime,
                      orElse:
                          () => BookingTime(
                            time: '',
                            court_status: '',
                            totalAvailableCourts: 0,
                            courts: [],
                          ),
                    );
                  }

                  if (selectedTimeSlot == null ||
                      selectedTimeSlot.time.isEmpty) {
                    return const Center(
                      heightFactor: 5,
                      child: Text('Select Time to see Available Courts.'),
                    );
                  }

                  final courts = selectedTimeSlot.courts;

                  if (courts.isEmpty) {
                    return const Center(
                      child: Text('No courts available for this time.'),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        courts.map((court) {
                          final isAvailable = court.courtStatus == 'available';

                          return Opacity(
                            opacity:
                                isAvailable
                                    ? 1.0
                                    : 0.4, // Visually dim if unavailable
                            child: IgnorePointer(
                              ignoring:
                                  !isAvailable, // Disable interaction if unavailable
                              child: Container(
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
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        decoration:
                                            isAvailable
                                                ? null
                                                : TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      court.location,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children:
                                            court.courtData.map<Widget>((
                                              courtData,
                                            ) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 16.0,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (selectedSport == null) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            "Please select a game first.",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.redAccent,
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
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                        ),
                                                      );
                                                      return;
                                                    }

                                                    final selectedDateObj =
                                                        bookingInfo
                                                            .dates[_selectedDateIndex];

                                                    showConfirmBookingModal(
                                                      context,
                                                      sport: selectedSport!,
                                                      date:
                                                          selectedDateObj.date,
                                                      time: _selectedTime!,
                                                      gender: 'mixed',
                                                      level: 2.2.toString(),
                                                      sessionPrice:
                                                          courtData.price
                                                              .toString(),
                                                      sessionDuration:
                                                          courtData.duration
                                                              .toString(),
                                                      court: court.name,
                                                      sportsCenter:
                                                          widget
                                                              .sports_center_name,
                                                      sports_center_id:
                                                          widget.bookingId,
                                                      court_id: court.id,
                                                      bookingType: 'private',
                                                      address:
                                                          widget
                                                              .sports_center_address,
                                                      purpose:
                                                          'Book Private Match',
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
                              ),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                courtData.duration.toString() + " min",
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
