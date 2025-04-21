import 'package:flutter/material.dart';
import '../models/booking_model.dart';

class BookingController extends ChangeNotifier {
  BookingInfo? _bookingInfo;
  bool isLoading = false;
  String? error;

  BookingInfo? get bookingInfo => _bookingInfo;

  Future<void> fetchBookingInfo() async {
    isLoading = true;
    notifyListeners();
    try {
      // Simulated API call delay.
      await Future.delayed(const Duration(seconds: 2));

      // Dummy data example.
      final dummyDates = [
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
      ];

      _bookingInfo = BookingInfo(dates: dummyDates);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
