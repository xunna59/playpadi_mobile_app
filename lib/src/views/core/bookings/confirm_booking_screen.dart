import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmBookingScreen extends StatelessWidget {
  const ConfirmBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // ─── All your dummy booking details as consts ───────────────
    const sport = 'padel';
    const dateRaw = '2025-05-03';
    const time = '10:00 AM';
    const sessionPrice = '₦25,000';
    const sessionDuration = '30 minutes';
    const court = 'Padel Court 1';
    const sportsCenter = 'PlayPadi Arena';
    const gameType = 'Padel';
    const bookingType = 'Public';
    const gender = 'Mixed';
    const level = '2';
    // ───────────────────────────────────────────────────────────────

    // If you still want the pretty formatted string:
    final formattedDate = DateFormat(
      'EEEE, MMM d, y – h:mm a',
    ).format(DateTime.parse('$dateRaw'));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Confirm Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ─── INFO CARD ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cs.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.primary, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sport.toUpperCase(),
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoColumn('Gender', gender, cs),
                      _infoColumn('Level', level, cs),
                      _infoColumn('Price', sessionPrice, cs),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ─── DETAILS CARD ───────────────────────────────────────────
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              color: cs.secondary,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sports Center
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sportsCenter,
                            style: TextStyle(color: cs.onSurface, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Court
                    Row(
                      children: [
                        const Icon(Icons.sports_tennis_outlined, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            court,
                            style: TextStyle(color: cs.onSurface, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Session Duration
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sessionDuration,
                            style: TextStyle(color: cs.onSurface, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ─── CONFIRM BUTTON ───────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Booking Confirmed!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
