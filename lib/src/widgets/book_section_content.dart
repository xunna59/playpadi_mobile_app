import 'package:flutter/material.dart';
import '../../playpadi_library.dart';
import '../controllers/event_centers_controller.dart';
import '../models/booking_model.dart';
import '../controllers/booking_controller.dart';
import '../models/event_center_model.dart'; // Import the controller

class BookSectionContent extends StatefulWidget {
  final int bookingId;

  const BookSectionContent({super.key, required this.bookingId});

  @override
  State<BookSectionContent> createState() => _BookSectionContentState();
}

class _BookSectionContentState extends State<BookSectionContent> {
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
        final availableTimes = dates[_selectedDateIndex].availableTimes;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
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
                          //  _selectedTime = dates[index].availableTimes.first;
                        });
                      },
                      child: Container(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date.weekday,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? colorScheme.primary
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                date.day,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(date.month, style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // "Show available slots only" Toggle.
              Row(
                children: [
                  const Text(
                    'Show available slots only',
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
              const SizedBox(height: 12),
              // Time Slots.
              Center(
                child: Wrap(
                  spacing: 15,
                  runSpacing: 12,
                  children:
                      availableTimes.map((time) {
                        final isSelected = time.time == _selectedTime;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTime = time.time;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? colorScheme.primary
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              time.time,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              // "Book a court" Section.
              const Text(
                'Book a court',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Create a private match where you can invite your friends',
              ),

              const SizedBox(height: 12),
              // Court Info Section.
              FutureBuilder<EventCenter?>(
                future: _fetchedCenter,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Check if snapshot has data and it's not null.
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No courts available.'));
                  }

                  final center = snapshot.data!;
                  final courts = center.courts;

                  // Check if the courts list is empty
                  if (courts == null || courts.isEmpty) {
                    return const Center(child: Text('No courts available.'));
                  }

                  // Display all courts using a Column.
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
                                Text(
                                  court.location,
                                ), // Assuming you want to show court location
                                const SizedBox(height: 12),
                                Text('${court.activity}'),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children:
                                      court.bookingInfo['booked_slots']
                                          .map<Widget>(
                                            (slot) =>
                                                Text('Booked Slot: $slot'),
                                          )
                                          .toList(),
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

  Widget _buildPriceOption(String price, String duration) {
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
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                duration,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
