import 'package:flutter/material.dart';
import '../../playpadi_library.dart';
import '../models/booking_model.dart';

class BookingController {
  final APIClient client = APIClient();

  Future<BookingInfo?> fetchBookingInfoById(id) async {
    Map<String, String> data = {'id': id.toString()};

    try {
      final response = await client.fetchSlots(data);
      // Check if the response is in the expected format
      if (response is Map<String, dynamic>) {
        if (response['slots'] is List<dynamic>) {
          final rawBookingInfo =
              response['slots']; // Accessing 'slots' instead of 'bookingInfo'
          List<BookingDate> bookingDates = [];

          // Iterate over each booking slot
          for (var date in rawBookingInfo) {
            List<BookingTime> availableTimes = [];

            // Iterate over each available time for the given date
            for (var time in date['times']) {
              availableTimes.add(
                BookingTime(time: time['time'], status: time['status']),
              );
            }

            // Add the date and available times to the booking dates list
            bookingDates.add(
              BookingDate(
                weekday: date['weekday'],
                day: date['day'],
                month: date['month'],
                date: date['date'],
                availableTimes: availableTimes,
              ),
            );
          }

          // Return the booking information as a BookingInfo object
          return BookingInfo(dates: bookingDates);
        }
      }

      return null; // Return null if the data structure doesn't match the expected format
    } catch (e, st) {
      return null; // Return null in case of any error
    }
  }
}
