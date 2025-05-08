import 'package:flutter/material.dart';
import '../../playpadi_library.dart';
import '../controllers/event_centers_controller.dart';
import '../models/booking_model.dart';
import '../controllers/booking_controller.dart';
import '../models/event_center_model.dart'; // Import the controller

class BookOpenMatch extends StatefulWidget {
  final int bookingId;

  const BookOpenMatch({super.key, required this.bookingId});

  @override
  State<BookOpenMatch> createState() => _BookOpenMatchState();
}

class _BookOpenMatchState extends State<BookOpenMatch> {
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
              const SizedBox(height: 20),

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
              // "Book a court" Section.
              const Text(
                'Book a court',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Create a private match where you can invite your friends',
                style: TextStyle(fontSize: 12),
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
                                Text('Activity: ${court.activity}'),
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
