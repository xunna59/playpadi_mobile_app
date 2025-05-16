import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/booking_controller.dart';
import '../controllers/match_controller.dart';
import '../core/activity_overlay.dart';
import '../models/match_model.dart';

void showConfirmBookingModal(
  BuildContext context, {

  required String sport,
  required String date, // e.g. "2025-05-03"
  required String time, // e.g. "10:00 AM"
  required String gender,
  required String level,
  required String sessionPrice,
  required String address,
  required String sessionDuration,
  required String court,
  required String sportsCenter,
  required String bookingType,
  required int sports_center_id,
  required int court_id,
}) {
  final cs = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: cs.secondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (_) => _ConfirmBookingModalContent(
          sport: sport,
          date: date,
          time: time,
          gender: gender,
          level: level,
          sessionPrice: sessionPrice,
          sessionDuration: sessionDuration,
          court: court,
          sportsCenter: sportsCenter,
          bookingType: bookingType,
          address: address,
          sports_center_id: sports_center_id,
          court_id: court_id,
        ),
  );
}

class _ConfirmBookingModalContent extends StatefulWidget {
  final String sport,
      date,
      time,
      gender,
      level,
      sessionPrice,
      sessionDuration,
      court,
      sportsCenter,
      bookingType,
      address;
  final int court_id, sports_center_id;

  const _ConfirmBookingModalContent({
    Key? key,
    required this.sport,
    required this.date,
    required this.time,

    required this.gender,
    required this.level,
    required this.sessionPrice,
    required this.sessionDuration,
    required this.court,
    required this.sportsCenter,
    required this.bookingType,
    required this.address,
    required this.sports_center_id,
    required this.court_id,
  }) : super(key: key);

  @override
  State<_ConfirmBookingModalContent> createState() =>
      _ConfirmBookingModalContentState();
}

class _ConfirmBookingModalContentState
    extends State<_ConfirmBookingModalContent> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final MatchController matchController = MatchController();
    List<MatchModel> _bookedMatches = [];

    Future<void> _onConfirmBooking() async {
      // Build up your payload
      final payload = {
        'sports_center_id': widget.sports_center_id,
        'court_id': widget.court_id,
        'date': widget.date,
        'slot': widget.time,
        'booking_type': widget.bookingType,
        'session_price': widget.sessionPrice,
        'session_duration': widget.sessionDuration,
        'game_type': widget.sport,
        'gender_allowed': widget.gender,
      };

      LoadingOverlay.show(context);
      try {
        final matches = await matchController.createBooking(payload);

        Navigator.pop(context); // close modal
        // Navigate or show success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Booking Confirmed!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green, // ← here
          ),
        );
      } catch (e) {
        // Handle errors (network, format, server, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Booking failed: $e',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } finally {
        LoadingOverlay.hide();
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle...
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Confirm Booking',
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // INFO CARD
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
                  widget.sport.toUpperCase(),
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.date,
                  style: TextStyle(color: cs.onSurface, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.time,
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoColumn('Gender', widget.gender, cs),
                    _infoColumn(
                      'Duration',
                      '${widget.sessionDuration} Mins',
                      cs,
                    ),
                    _infoColumn('Price', '₦${widget.sessionPrice}', cs),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // DETAILS CARD
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            color: cs.secondary,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _iconRow(
                    Icons.sports_tennis_outlined,
                    '${widget.sportsCenter} | ${widget.court}',
                    cs,
                  ),
                  const SizedBox(height: 12),
                  _iconRow(Icons.location_on_outlined, widget.address, cs),
                  // const SizedBox(height: 12),

                  // _iconRow(
                  //   Icons.access_time_outlined,
                  //   '${sessionDuration} Mins',
                  //   cs,
                  // ),
                  const SizedBox(height: 12),
                  _iconRow(Icons.lock, widget.bookingType, cs),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // CONFIRM BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _onConfirmBooking();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Proceed - ₦${widget.sessionPrice}',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value, ColorScheme cs) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _iconRow(IconData icon, String text, ColorScheme cs) {
    return Row(
      children: [
        Icon(icon, size: 20, color: cs.onSurface),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: cs.onSurface))),
      ],
    );
  }
}
