import 'package:flutter/material.dart';
import '../controllers/court_controller.dart';
import '../models/booking_model.dart';
import '../models/court_model.dart'; // Create this model file as shown earlier

class BookSectionContent extends StatefulWidget {
  // Optionally, accept bookingInfo if already available.
  final BookingInfo? bookingInfo;

  const BookSectionContent({super.key, this.bookingInfo});

  @override
  State<BookSectionContent> createState() => _BookSectionContentState();
}

class _BookSectionContentState extends State<BookSectionContent> {
  int _selectedDateIndex = 0;
  bool _showAvailableSlotsOnly = false;
  String? _selectedTime;
  Future<List<CourtModel>>? _courtsFuture;

  @override
  void initState() {
    super.initState();
    // If booking data is passed in, initialize _selectedTime.
    if (widget.bookingInfo != null &&
        widget.bookingInfo!.dates.isNotEmpty &&
        widget.bookingInfo!.dates.first.availableTimes.isNotEmpty) {
      _selectedTime = widget.bookingInfo!.dates.first.availableTimes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final BookingInfo bookingInfo =
        widget.bookingInfo ??
        BookingInfo(
          dates: [
            BookingDate(
              weekday: 'TUE',
              day: '04',
              month: 'Feb',
              availableTimes: ['07:30', '08:00', '08:30', '09:00'],
            ),
            BookingDate(
              weekday: 'WED',
              day: '05',
              month: 'Feb',
              availableTimes: ['07:30', '08:00', '08:30', '09:00'],
            ),
            BookingDate(
              weekday: 'THU',
              day: '06',
              month: 'Feb',
              availableTimes: ['07:30', '08:00', '08:30', '09:00'],
            ),
            BookingDate(
              weekday: 'FRI',
              day: '07',
              month: 'Feb',
              availableTimes: ['07:30', '08:00', '08:30', '09:00'],
            ),
            BookingDate(
              weekday: 'SAT',
              day: '08',
              month: 'Feb',
              availableTimes: ['08:00', '08:30', '09:00', '09:30'],
            ),
            BookingDate(
              weekday: 'SUN',
              day: '09',
              month: 'Feb',
              availableTimes: ['08:00', '08:30', '09:00', '09:30'],
            ),
            BookingDate(
              weekday: 'MON',
              day: '10',
              month: 'Feb',
              availableTimes: ['08:00', '08:30', '09:00', '09:30'],
            ),
          ],
        );

    final dates = bookingInfo.dates;
    // Use available times from the currently selected date.
    final availableTimes = dates[_selectedDateIndex].availableTimes;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal Date Selector.
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
                      // Reset selected time for the new date.
                      _selectedTime = dates[index].availableTimes.first;
                    });
                  },
                  child: Container(
                    width: 60,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          date.weekday,
                          style: TextStyle(
                            //  color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
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
                              // color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          date.month,
                          style: TextStyle(
                            // color: isSelected ? Colors.white : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
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
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children:
                availableTimes.map((time) {
                  // In a real integration, check slot availability here.
                  final isSelected = time == _selectedTime;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTime = time;
                        _courtsFuture = CourtController().fetchCourts();
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
                        // border: Border.all(
                        //   color: Theme.of(context).primaryColor,
                        // ),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          //  color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
          const SizedBox(height: 8),
          // Private match toggle.
          Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Private match'),
              Spacer(),
              Switch(value: false, onChanged: (val) {}),
            ],
          ),
          const SizedBox(height: 12),
          // Court Info Section.
          FutureBuilder<List<CourtModel>>(
            future: _courtsFuture,
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
              final courts = snapshot.data!;
              // Display all courts using a Column.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    courts.map((court) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary,
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
                            Text(court.features),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  court.pricing.map((p) {
                                    return _buildPriceOption(
                                      '\$${p.amount}',
                                      '${p.duration} min',
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              );
            },
          ),
          const SizedBox(height: 12),
          // (Optional) Add CTA button or navigation here.
        ],
      ),
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
